from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from functools import wraps
from werkzeug.security import generate_password_hash
from flask import g
from MySQLdb.cursors import DictCursor
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.secret_key = "supersecretkey"

# Configuración MySQL directa para tus queries actuales
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mysql'
app.config['MYSQL_DB'] = 'Entrelaza'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# Configuración SQLAlchemy para el modelo Notificacion
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:mysql@localhost/Entrelaza'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


# Modelo
class Notificacion(db.Model):
    __tablename__ = 'notificaciones'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id', ondelete='CASCADE'), nullable=False)
    mensaje = db.Column(db.String(255), nullable=False)
    tipo = db.Column(db.Enum('solicitud','respuesta'), nullable=False)
    leida = db.Column(db.Boolean, default=False)
    fecha = db.Column(db.DateTime, default=datetime.utcnow)




def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'usuario' not in session:
            flash("Debes iniciar sesión", "warning")
            return redirect(url_for('login'))
        if session['usuario'].get('role') != 'admin':
            flash("No tienes permisos para acceder aquí", "danger")
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

app = Flask(__name__)
app.secret_key = "supersecretkey"

# Configuración MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mysql'
app.config['MYSQL_DB'] = 'Entrelaza'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

@app.route('/')
def index():
    cursor = mysql.connection.cursor()
    usuario = session.get('usuario')

    # --- Traer equipos según usuario ---
    if usuario:
        # Solo equipos que necesiten la carrera del usuario (tanto públicos como privados)
        cursor.execute('''
            SELECT DISTINCT e.*, 
                   (SELECT COUNT(*) FROM equipo_integrantes ei WHERE ei.equipo_id = e.id) AS integrantes_actuales
            FROM equipos e
            JOIN equipo_carreras ec ON e.id = ec.equipo_id
            JOIN carreras c ON ec.carrera_id = c.id
            WHERE c.nombre = %s
        ''', (usuario['carrera'],))
    else:
        # Visitante ve solo equipos públicos
        cursor.execute('''
            SELECT e.*, 
                   (SELECT COUNT(*) FROM equipo_integrantes ei WHERE ei.equipo_id = e.id) AS integrantes_actuales
            FROM equipos e
            WHERE e.privacidad = 'publico'
        ''')

    equipos = cursor.fetchall()

    # --- Filtrar equipos que no estén llenos o que contengan al usuario ---
    filtrados = []
    if usuario:
        for eq in equipos:
            cursor.execute(
                'SELECT 1 FROM equipo_integrantes WHERE equipo_id = %s AND usuario_id = %s',
                (eq['id'], usuario['id'])
            )
            pertenece = cursor.fetchone()
            if eq['integrantes_actuales'] < eq['max_integrantes'] or pertenece:
                filtrados.append(eq)
        equipos = filtrados
    else:
        equipos = [eq for eq in equipos if eq['integrantes_actuales'] < eq['max_integrantes']]

    # --- Agregar integrantes y carreras necesarias ---
    for equipo in equipos:
        cursor.execute('''
            SELECT u.id, u.nombre_completo, u.carrera, u.grado, u.grupo
            FROM equipo_integrantes ei
            JOIN usuarios u ON ei.usuario_id = u.id
            WHERE ei.equipo_id = %s
        ''', (equipo['id'],))
        equipo['integrantes'] = cursor.fetchall()

        cursor.execute('''
            SELECT c.nombre
            FROM equipo_carreras ec
            JOIN carreras c ON ec.carrera_id = c.id
            WHERE ec.equipo_id = %s
        ''', (equipo['id'],))
        equipo['carreras_necesarias'] = [c['nombre'] for c in cursor.fetchall()]

    # --- Verificar si el usuario ya tiene un proyecto ---
    mi_proyecto = None
    equipos_disponibles = equipos.copy()  # por defecto todos los filtrados
    if usuario:
        cursor.execute('''
            SELECT e.* FROM equipos e
            JOIN equipo_integrantes ei ON e.id = ei.equipo_id
            WHERE ei.usuario_id = %s
            LIMIT 1
        ''', (usuario['id'],))
        mi_proyecto = cursor.fetchone()

        if mi_proyecto:
            # Traer integrantes y carreras del proyecto
            cursor.execute('''
                SELECT u.id, u.nombre_completo, u.carrera, u.grado, u.grupo
                FROM equipo_integrantes ei
                JOIN usuarios u ON ei.usuario_id = u.id
                WHERE ei.equipo_id = %s
            ''', (mi_proyecto['id'],))
            mi_proyecto['integrantes'] = cursor.fetchall()

            cursor.execute('''
                SELECT c.nombre
                FROM equipo_carreras ec
                JOIN carreras c ON ec.carrera_id = c.id
                WHERE ec.equipo_id = %s
            ''', (mi_proyecto['id'],))
            mi_proyecto['carreras_necesarias'] = [c['nombre'] for c in cursor.fetchall()]

            # Quitar su proyecto de los equipos disponibles
            equipos_disponibles = [eq for eq in equipos if eq['id'] != mi_proyecto['id']]

    cursor.close()
    return render_template(
        "project.html",
        equipos=equipos_disponibles,
        usuario=usuario,
        mi_proyecto=mi_proyecto
    )

# ruta admin
@app.route('/admin')
@admin_required
def admin_panel():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT nombre FROM carreras")
    carreras = [row['nombre'] for row in cursor.fetchall()]
    cursor.close()
    return render_template('admin.html', carreras=carreras)

# tabla de usuarios
@app.route('/admin/usuarios')
@admin_required
def admin_usuarios():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM usuarios")
    usuarios = cursor.fetchall()
    cursor.close()
    return render_template('admin_usuarios.html', usuarios=usuarios)

# tabla de equipos
@app.route('/admin/equipos')
@admin_required
def admin_equipos():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM equipos")
    equipos = cursor.fetchall()
    cursor.close()
    return render_template('admin_equipos.html', equipos=equipos)

# borrar usuarios o equipos
@app.route('/admin/borrar_usuario/<int:id>', methods=['POST'])
@admin_required
def borrar_usuario(id):
    cursor = mysql.connection.cursor()
    
    # Antes de borrar al usuario, obtenemos los equipos donde está
    cursor.execute('SELECT equipo_id FROM equipo_integrantes WHERE usuario_id = %s', (id,))
    equipos = [row['equipo_id'] for row in cursor.fetchall()]
    
    # Borrar al usuario
    cursor.execute("DELETE FROM usuarios WHERE id=%s", (id,))
    mysql.connection.commit()
    
    # Revisar si alguno de los equipos quedó vacío
    for equipo_id in equipos:
        cursor.execute('SELECT COUNT(*) AS total FROM equipo_integrantes WHERE equipo_id = %s', (equipo_id,))
        resultado = cursor.fetchone()
        if resultado['total'] == 0:
            # Borrar equipo y sus carreras asociadas
            cursor.execute('DELETE FROM equipo_carreras WHERE equipo_id = %s', (equipo_id,))
            cursor.execute('DELETE FROM equipos WHERE id = %s', (equipo_id,))
            mysql.connection.commit()
            flash(f"El equipo {equipo_id} quedó vacío y fue eliminado automáticamente", "info")
    
    cursor.close()
    flash("Usuario eliminado", "success")
    return redirect(url_for('admin_usuarios'))

@app.route('/admin/borrar_equipo/<int:id>', methods=['POST'])
@admin_required
def borrar_equipo(id):
    cursor = mysql.connection.cursor()
    cursor.execute("DELETE FROM equipos WHERE id=%s", (id,))
    mysql.connection.commit()
    cursor.close()
    flash("Equipo eliminado", "success")
    return redirect(url_for('admin_equipos'))

# agregar usuario en admin
@app.route('/admin/agregar_usuario', methods=['GET', 'POST'])
@admin_required
def agregar_usuario():
    if request.method == 'POST':
        nombre = request.form['nombre']
        carrera = request.form['carrera']
        grado = request.form['grado']      # NUEVO
        grupo = request.form['grupo']      # NUEVO
        codigo = request.form['codigo']
        correo = request.form['correo']
        telefono = request.form['telefono']  # NUEVO
        contrasena = request.form['contrasena']
        role = request.form.get('role', 'user')

        # 🔑 Hashear la contraseña antes de guardarla
        hashed_password = generate_password_hash(contrasena, method='pbkdf2:sha256')

        cursor = mysql.connection.cursor()
        cursor.execute('''
            INSERT INTO usuarios(nombre_completo, carrera, grado, grupo, codigo, correo, telefono, contrasena, role)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
        ''', (nombre, carrera, grado, grupo, codigo, correo, telefono, hashed_password, role))
        mysql.connection.commit()
        cursor.close()

        flash("Usuario agregado correctamente", "success")
        return redirect(url_for('admin_usuarios'))

    return render_template('agregar_usuario.html')

# Registro de usuario
@app.route('/register', methods=['GET', 'POST'])
def register():
    """
    Registro de usuario.
    Incluye grado, grupo y teléfono.
    Verifica correo institucional y evita duplicados.
    """
    if request.method == 'POST':
        nombre = request.form['nombre']
        carrera = request.form['carrera']
        grado = request.form['grado']        # NUEVO
        grupo = request.form['grupo']        # NUEVO
        codigo = request.form['codigo']
        correo = request.form['correo']
        telefono = request.form['telefono']  # NUEVO
        password = request.form['password']
        
        if not correo.endswith("@alumnos.udg.mx"):
            flash("Debes usar tu correo institucional (@alumnos.udg.mx)", "danger")
            return redirect(url_for('register'))

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM usuarios WHERE codigo = %s OR correo = %s", (codigo, correo))
        if cursor.fetchone():
            flash("Ya existe un usuario con ese código o correo", "danger")
            cursor.close()
            return redirect(url_for('register'))

        # Hashear la contraseña
        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')

        # Insertar usuario con teléfono, grado y grupo
        cursor.execute('''
            INSERT INTO usuarios(nombre_completo, carrera, grado, grupo, codigo, correo, telefono, contrasena)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        ''', (nombre, carrera, grado, grupo, codigo, correo, telefono, hashed_password))

        mysql.connection.commit()
        cursor.close()
        flash("Registro exitoso, ahora inicia sesión", "success")
        return redirect(url_for('login'))

    return render_template("register.html")

# Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    Login de usuario.
    Guarda en sesión id, nombre, carrera, grado, grupo, código, correo, teléfono y rol.
    """
    if request.method == 'POST':
        codigo = request.form['codigo']
        password = request.form['password']

        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM usuarios WHERE codigo = %s', (codigo,))
        user = cursor.fetchone()
        cursor.close()

        from werkzeug.security import check_password_hash
        if user and check_password_hash(user['contrasena'], password):
            # Guardar en sesión incluyendo grado, grupo y teléfono
            session['usuario'] = {
                'id': user['id'],
                'nombre_completo': user['nombre_completo'],
                'carrera': user['carrera'],
                'grado': user.get('grado'),
                'grupo': user.get('grupo'),
                'codigo': user['codigo'],
                'correo': user['correo'],
                'telefono': user.get('telefono'),
                'role': user.get('role', 'user')
            }

            flash(f"Bienvenido, {user['nombre_completo']}", "success")

            if session['usuario']['role'] == 'admin':
                return redirect(url_for('admin_panel'))
            else:
                return redirect(url_for('index'))
        else:
            flash("Código o contraseña incorrectos", "danger")
            return redirect(url_for('login'))

    return render_template("login.html")

# agregar equipo admin
@app.route('/admin/agregar_equipo', methods=['GET', 'POST'])
@admin_required
def agregar_equipo():
    cursor = mysql.connection.cursor()

    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        max_integrantes = int(request.form['max_integrantes'])
        integrantes_raw = request.form.get('integrantes', '')
        carreras_seleccionadas = request.form.getlist('carreras')
        privacidad = request.form.get('privacidad', 'publico')  # --- NUEVO ---

        # Insertar equipo
        cursor.execute(
            "INSERT INTO equipos(nombre_proyecto, descripcion, max_integrantes, creador_id, privacidad) VALUES (%s,%s,%s,%s,%s)",
            (nombre, descripcion, max_integrantes, session['usuario']['id'], privacidad)
        )
        equipo_id = cursor.lastrowid

        # Insertar integrantes, evitando duplicar al creador
        cursor.execute(
            "INSERT INTO equipo_integrantes (equipo_id, usuario_id) VALUES (%s, %s)",
            (equipo_id, session['usuario']['id'])
        )

        integrantes = [i.strip() for i in integrantes_raw.split(',') if i.strip()]
        for integrante_nombre in integrantes:
            if integrante_nombre == session['usuario']['nombre_completo']:
                continue
            # Insertar solo si existe el usuario
            cursor.execute(
                "INSERT INTO equipo_integrantes (equipo_id, usuario_id) "
                "SELECT %s, id FROM usuarios WHERE nombre_completo=%s LIMIT 1",
                (equipo_id, integrante_nombre)
            )

        # Insertar carreras asociadas
        for carrera_nombre in carreras_seleccionadas[:4]:  # máximo 4
            cursor.execute("SELECT id FROM carreras WHERE nombre=%s", (carrera_nombre,))
            carrera_row = cursor.fetchone()
            if carrera_row:
                cursor.execute(
                    "INSERT INTO equipo_carreras (equipo_id, carrera_id) VALUES (%s,%s)",
                    (equipo_id, carrera_row['id'])
                )

        mysql.connection.commit()
        cursor.close()
        flash("Equipo agregado", "success")
        return redirect(url_for('admin_equipos'))

    # GET: mostrar formulario con carreras
    cursor.execute("SELECT nombre FROM carreras")
    carreras = [row['nombre'] for row in cursor.fetchall()]
    cursor.close()
    return render_template('agregar_equipo.html', carreras=carreras)

# Mostrar proyecto del usuario
@app.route('/mi_equipo')
def mi_equipo():
    if 'usuario' not in session:
        flash("Debes iniciar sesión para ver tu proyecto", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    # Buscar proyecto del usuario, incluyendo asesor
    cursor.execute('''
        SELECT e.id, e.nombre_proyecto, e.descripcion, e.max_integrantes, e.asesor, e.privacidad, e.creador_id
        FROM equipos e
        JOIN equipo_integrantes ei ON e.id = ei.equipo_id
        WHERE ei.usuario_id = %s
        LIMIT 1
    ''', (usuario['id'],))
    equipo = cursor.fetchone()

    if not equipo:
        flash("No perteneces a ningún proyecto aún", "info")
        cursor.close()
        return redirect(url_for('index'))

    # Integrantes del equipo con grado y grupo incluidos
    cursor.execute('''
    SELECT u.id, 
           u.nombre_completo,
           u.carrera,
           u.telefono,
           u.grado,
           u.grupo
    FROM equipo_integrantes ei
    JOIN usuarios u ON ei.usuario_id = u.id
    WHERE ei.equipo_id = %s
''', (equipo['id'],))
    equipo['integrantes'] = cursor.fetchall()


    # Carreras necesarias
    cursor.execute('''
        SELECT c.nombre
        FROM equipo_carreras ec
        JOIN carreras c ON ec.carrera_id = c.id
        WHERE ec.equipo_id = %s
    ''', (equipo['id'],))
    equipo['carreras_necesarias'] = [c['nombre'] for c in cursor.fetchall()]

    cursor.close()
    return render_template('mi_equipo.html', usuario=usuario, equipo=equipo)

# Logout
@app.route('/logout')
def logout():
    session.pop('usuario', None)
    flash("Sesión cerrada", "info")
    flash("Has iniciado sesión correctamente", "success")
    return redirect(url_for('index'))

# Crear proyecto
@app.route('/create_project', methods=['GET', 'POST'])
def create_project():
    if 'usuario' not in session:
        flash("Debes iniciar sesión para crear un proyecto", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    # Verificar que el usuario exista
    cursor.execute("SELECT id FROM usuarios WHERE id=%s", (usuario['id'],))
    if not cursor.fetchone():
        flash("Usuario no válido", "danger")
        cursor.close()
        return redirect(url_for('index'))

    # Verificar que no haya creado ya un equipo
    cursor.execute('SELECT * FROM equipos WHERE creador_id = %s', (usuario['id'],))
    if cursor.fetchone():
        flash("Ya creaste un equipo, no puedes crear otro", "danger")
        cursor.close()
        return redirect(url_for('index'))

    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        max_integrantes = int(request.form['max_integrantes'])
        asesor = request.form.get('asesor', '').strip()  # <- nuevo campo
        integrantes_raw = request.form.get('integrantes', '')
        carreras_seleccionadas = request.form.getlist('carreras')
        privacidad = request.form.get('privacidad', 'publico')  # --- NUEVO ---

        # Limitar el número de carreras al máximo permitido
        carreras_seleccionadas = carreras_seleccionadas[:4]

        # Crear el equipo con asesor y privacidad
        cursor.execute(
            "INSERT INTO equipos (nombre_proyecto, descripcion, max_integrantes, creador_id, asesor, privacidad) "
            "VALUES (%s,%s,%s,%s,%s,%s)",
            (nombre, descripcion, max_integrantes, usuario['id'], asesor, privacidad)
        )
        equipo_id = cursor.lastrowid

        # --- INSERTAR AL CREADOR ---
        cursor.execute(
            "INSERT INTO equipo_integrantes (equipo_id, usuario_id) VALUES (%s, %s)",
            (equipo_id, usuario['id'])
        )

        # --- INSERTAR OTROS INTEGRANTES ---
        integrantes = [i.strip() for i in integrantes_raw.split(',') if i.strip()]
        for integrante_nombre in integrantes:
            if integrante_nombre.lower() == usuario['nombre_completo'].lower():
                continue  # evitar duplicar al creador

            # Obtener el ID del usuario
            cursor.execute("SELECT id FROM usuarios WHERE nombre_completo=%s LIMIT 1", (integrante_nombre,))
            row = cursor.fetchone()
            if row:
                usuario_id = row['id']

                # Verificar si ya está en el equipo
                cursor.execute(
                    "SELECT 1 FROM equipo_integrantes WHERE equipo_id=%s AND usuario_id=%s",
                    (equipo_id, usuario_id)
                )
                if cursor.fetchone():
                    continue  # ya existe, no insertar

                # Insertar
                cursor.execute(
                    "INSERT INTO equipo_integrantes (equipo_id, usuario_id) VALUES (%s,%s)",
                    (equipo_id, usuario_id)
                )

        # --- INSERTAR CARRERAS ASOCIADAS ---
        for carrera_nombre in carreras_seleccionadas:
            cursor.execute("SELECT id FROM carreras WHERE nombre=%s", (carrera_nombre,))
            carrera_row = cursor.fetchone()
            if carrera_row:
                carrera_id = carrera_row['id']
                cantidad = int(request.form.get(f'cantidad_{carrera_nombre}', 0))
                cursor.execute(
                    "INSERT INTO equipo_carreras (equipo_id, carrera_id, cantidad) VALUES (%s,%s,%s)",
                    (equipo_id, carrera_id, cantidad)
                )

        mysql.connection.commit()
        cursor.close()
        flash("¡Creaste tu equipo!", "success")
        return redirect(url_for('index'))

    # GET: traer carreras para el formulario
    cursor.execute("SELECT nombre FROM carreras")
    carreras = [row['nombre'] for row in cursor.fetchall()]
    cursor.close()
    return render_template("create_project.html", carreras=carreras)

# Unirse a proyecto (ahora respeta privacidad: público -> se une, privado -> crea solicitud)
@app.route('/unirse/<int:equipo_id>', methods=['GET', 'POST'])
def unirse(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión para unirte a un equipo", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    # Si ya pertenece a un equipo, no puede unirse
    cursor.execute('SELECT * FROM equipo_integrantes WHERE usuario_id = %s', (usuario['id'],))
    if cursor.fetchone():
        flash("Ya perteneces a un equipo y no puedes unirte a otro", "danger")
        cursor.close()
        return redirect(url_for('index'))

    # Obtener info del equipo
    cursor.execute('SELECT * FROM equipos WHERE id = %s', (equipo_id,))
    equipo = cursor.fetchone()
    if not equipo:
        flash("Equipo no encontrado", "danger")
        cursor.close()
        return redirect(url_for('index'))

    # Conteo de integrantes actuales
    cursor.execute('SELECT COUNT(*) AS total FROM equipo_integrantes WHERE equipo_id = %s', (equipo_id,))
    conteo = cursor.fetchone()['total']
    if conteo >= equipo['max_integrantes']:
        flash("El equipo ya está lleno", "warning")
        cursor.close()
        return redirect(url_for('index'))

    if equipo.get('privacidad') == 'publico':
        # Unirse directamente
        cursor.execute('INSERT INTO equipo_integrantes(equipo_id, usuario_id) VALUES (%s, %s)', (equipo_id, usuario['id']))
        mysql.connection.commit()
        cursor.close()
        flash("¡Te uniste al equipo!", "success")
        return redirect(url_for('index'))
    else:
        # Equipo privado -> crear solicitud si no existe
        cursor.execute('SELECT * FROM solicitudes_equipo WHERE usuario_id=%s AND equipo_id=%s AND estado="pendiente"', (usuario['id'], equipo_id))
        if cursor.fetchone():
            flash("Ya enviaste una solicitud y está pendiente", "info")
            cursor.close()
            return redirect(url_for('index'))

        cursor.execute('INSERT INTO solicitudes_equipo (usuario_id, equipo_id) VALUES (%s, %s)', (usuario['id'], equipo_id))
        mysql.connection.commit()
        cursor.close()
        flash("Solicitud enviada. El creador del equipo la revisará.", "success")
        return redirect(url_for('index'))

# Cancelar solicitud (el usuario que la envió)
@app.route('/cancelar_solicitud/<int:equipo_id>', methods=['POST', 'GET'])
def cancelar_solicitud(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM solicitudes_equipo WHERE usuario_id=%s AND equipo_id=%s AND estado="pendiente"', (usuario['id'], equipo_id))
    mysql.connection.commit()
    cursor.close()
    flash("Solicitud cancelada", "info")
    return redirect(url_for('index'))

# Ver solicitudes de un equipo (solo creador del equipo)
@app.route('/equipo/<int:equipo_id>/solicitudes')
def ver_solicitudes_equipo(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT creador_id, nombre_proyecto FROM equipos WHERE id=%s', (equipo_id,))
    equipo = cursor.fetchone()
    if not equipo:
        cursor.close()
        flash("Equipo no encontrado", "danger")
        return redirect(url_for('index'))

    # Solo el creador puede ver solicitudes
    if equipo['creador_id'] != usuario['id']:
        cursor.close()
        flash("No tienes permisos para ver las solicitudes de este equipo", "danger")
        return redirect(url_for('index'))

    cursor.execute('''
        SELECT s.id, s.usuario_id, s.fecha, u.nombre_completo, u.carrera, u.grado, u.grupo
        FROM solicitudes_equipo s
        JOIN usuarios u ON s.usuario_id = u.id
        WHERE s.equipo_id = %s AND s.estado = 'pendiente'
        ORDER BY s.fecha ASC
    ''', (equipo_id,))
    solicitudes = cursor.fetchall()
    cursor.close()
    return render_template('solicitudes_equipo.html', solicitudes=solicitudes, equipo_id=equipo_id, equipo_nombre=equipo['nombre_proyecto'])

# Aceptar solicitud (solo creador)
@app.route('/equipo/aceptar_solicitud/<int:solicitud_id>', methods=['POST'])
def aceptar_solicitud(solicitud_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM solicitudes_equipo WHERE id=%s', (solicitud_id,))
    solicitud = cursor.fetchone()
    if not solicitud:
        cursor.close()
        flash("Solicitud no encontrada", "danger")
        return redirect(url_for('index'))

    cursor.execute('SELECT * FROM equipos WHERE id=%s', (solicitud['equipo_id'],))
    equipo = cursor.fetchone()
    if equipo['creador_id'] != usuario['id']:
        cursor.close()
        flash("No tienes permisos para aceptar esta solicitud", "danger")
        return redirect(url_for('index'))

    # Verificar espacio
    cursor.execute('SELECT COUNT(*) AS total FROM equipo_integrantes WHERE equipo_id = %s', (equipo['id'],))
    total = cursor.fetchone()['total']
    if total >= equipo['max_integrantes']:
        cursor.execute('UPDATE solicitudes_equipo SET estado=%s WHERE id=%s', ('rechazada', solicitud_id))
        mysql.connection.commit()
        cursor.close()
        flash("No se puede aceptar: el equipo ya está lleno", "warning")
        return redirect(url_for('ver_solicitudes_equipo', equipo_id=equipo['id']))

    # Insertar en integrantes y actualizar solicitud a aceptada
    cursor.execute('INSERT INTO equipo_integrantes (equipo_id, usuario_id) VALUES (%s, %s)', (equipo['id'], solicitud['usuario_id']))
    cursor.execute('UPDATE solicitudes_equipo SET estado=%s WHERE id=%s', ('aceptada', solicitud_id))
    mysql.connection.commit()
    cursor.close()
    flash("Solicitud aceptada y usuario agregado al equipo", "success")
    return redirect(url_for('ver_solicitudes_equipo', equipo_id=equipo['id']))

# Rechazar solicitud (solo creador)
@app.route('/equipo/rechazar_solicitud/<int:solicitud_id>', methods=['POST'])
def rechazar_solicitud(solicitud_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM solicitudes_equipo WHERE id=%s', (solicitud_id,))
    solicitud = cursor.fetchone()
    if not solicitud:
        cursor.close()
        flash("Solicitud no encontrada", "danger")
        return redirect(url_for('index'))

    cursor.execute('SELECT * FROM equipos WHERE id=%s', (solicitud['equipo_id'],))
    equipo = cursor.fetchone()
    if equipo['creador_id'] != usuario['id']:
        cursor.close()
        flash("No tienes permisos para rechazar esta solicitud", "danger")
        return redirect(url_for('index'))

    cursor.execute('UPDATE solicitudes_equipo SET estado=%s WHERE id=%s', ('rechazada', solicitud_id))
    mysql.connection.commit()
    cursor.close()
    flash("Solicitud rechazada", "info")
    return redirect(url_for('ver_solicitudes_equipo', equipo_id=equipo['id']))

# Equipos disponibles (arreglado para que funcione)
@app.route('/equipos_disponibles')
def equipos_disponibles():
    if 'usuario' not in session:
        flash("Debes iniciar sesión para ver los equipos", "warning")
        return redirect(url_for('login'))
    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    # Traer equipos que necesitan la carrera del usuario (públicos y privados; join request separado)
    cursor.execute('''
        SELECT e.*, (SELECT COUNT(*) FROM equipo_integrantes ei WHERE ei.equipo_id = e.id) AS integrantes_actuales
        FROM equipos e
        JOIN equipo_carreras ec ON e.id = ec.equipo_id
        JOIN carreras c ON ec.carrera_id = c.id
        WHERE c.nombre = %s
    ''', (usuario['carrera'],))
    equipos = cursor.fetchall()

    # Filtrar como en index
    filtrados = []
    for eq in equipos:
        cursor.execute('SELECT 1 FROM equipo_integrantes WHERE equipo_id = %s AND usuario_id = %s', (eq['id'], usuario['id']))
        pertenece = cursor.fetchone()
        if eq['integrantes_actuales'] < eq['max_integrantes'] or pertenece:
            filtrados.append(eq)
    cursor.close()
    return render_template('equipos_disponibles.html', usuario=usuario, equipos=filtrados)

# Salir de equipo
@app.route('/salir/<int:equipo_id>')
def salir(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    
    # Eliminar al usuario del equipo
    cursor.execute(
        'DELETE FROM equipo_integrantes WHERE equipo_id = %s AND usuario_id = %s',
        (equipo_id, usuario['id'])
    )
    mysql.connection.commit()

    # Verificar si quedan integrantes en el equipo
    cursor.execute(
        'SELECT COUNT(*) AS total FROM equipo_integrantes WHERE equipo_id = %s',
        (equipo_id,)
    )
    resultado = cursor.fetchone()
    
    if resultado['total'] == 0:
        # Borrar equipo y sus carreras asociadas
        cursor.execute('DELETE FROM equipo_carreras WHERE equipo_id = %s', (equipo_id,))
        cursor.execute('DELETE FROM equipos WHERE id = %s', (equipo_id,))
        mysql.connection.commit()
        flash("El equipo quedo vacío y fue eliminado automáticamente", "info")
    else:
        flash("Has salido del equipo", "info")
    
    cursor.close()
    return redirect(url_for('index'))

# Ver perfil de usuario
@app.route('/perfil/<int:id>')
def perfil(id):
    origen = request.args.get('origen', 'index')  # por defecto 'index'
    
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT id, nombre_completo, carrera, grado, grupo, descripcion FROM usuarios WHERE id=%s", (id,))
    usuario_perfil = cursor.fetchone()
    cursor.close()

    if not usuario_perfil:
        flash("Usuario no encontrado", "danger")
        return redirect(url_for('index'))

    usuario_sesion = session.get('usuario')
    return render_template("perfil.html", usuario=usuario_sesion, perfil=usuario_perfil, origen=origen)



# Editar perfil (solo propio)
@app.route('/editar_perfil', methods=['GET', 'POST'])
def editar_perfil():
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    if request.method == 'POST':
        descripcion = request.form.get('descripcion', '')
        cursor.execute("UPDATE usuarios SET descripcion=%s WHERE id=%s", (descripcion, usuario['id']))
        mysql.connection.commit()
        cursor.close()

        # Actualizar la sesión
        session['usuario']['descripcion'] = descripcion
        flash("Perfil actualizado", "success")
        return redirect(url_for('perfil', id=usuario['id']))

    # GET: mostrar formulario con descripción actual
    cursor.execute("SELECT descripcion FROM usuarios WHERE id=%s", (usuario['id'],))
    descripcion = cursor.fetchone()['descripcion']
    cursor.close()
    return render_template("editar_perfil.html", descripcion=descripcion, usuario=usuario)


# ---------- RUTA NOTIFICACIONES (para la modal) ----------
@app.route("/notificaciones")
def notificaciones():
    if "usuario_id" not in session:
        return redirect(url_for("login"))

    usuario_id = session["usuario_id"]
    usuario = session["usuario"]

    cursor = mysql.connection.cursor()

    # Traer solicitudes recibidas (pendientes) si es admin
    cursor.execute("""
        SELECT s.id AS solicitud_id, u.id AS usuario_id, u.nombre_completo, u.carrera, u.grado, u.grupo, e.nombre_proyecto
        FROM solicitudes s
        JOIN usuarios u ON u.id = s.usuario_id
        JOIN equipos e ON e.id = s.equipo_id
        JOIN equipo_integrantes ei ON ei.equipo_id = e.id
        WHERE ei.usuario_id = %s AND ei.es_admin=TRUE AND s.estado='pendiente'
    """, (usuario_id,))
    recibidas = cursor.fetchall()

    # Solicitudes enviadas por el usuario
    cursor.execute("""
        SELECT s.id AS solicitud_id, s.estado, s.equipo_id, e.nombre_proyecto
        FROM solicitudes s
        JOIN equipos e ON e.id = s.equipo_id
        WHERE s.usuario_id=%s
    """, (usuario_id,))
    enviadas = cursor.fetchall()

    # Traer notificaciones pendientes
    cursor.execute("""
        SELECT *
        FROM notificaciones
        WHERE usuario_id=%s AND leido=FALSE
        ORDER BY fecha DESC
    """, (usuario_id,))
    notificaciones = cursor.fetchall()

    cursor.close()

    return render_template(
        "navbar.html",
        usuario=usuario,
        recibidas=recibidas,
        enviadas=enviadas,
        notificaciones=notificaciones
    )



@app.route("/notificaciones/marcar_leidas")
def marcar_notificaciones_leidas():
    if "usuario_id" not in session:
        return redirect(url_for("login"))

    usuario_id = session["usuario_id"]
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE notificaciones SET leido=TRUE WHERE usuario_id=%s", (usuario_id,))
    mysql.connection.commit()
    cursor.close()
    return '', 204


# ---------- ACEPTAR SOLICITUD ----------
@app.route("/aceptar_solicitud_modal/<int:id>/<int:usuario_id>")
def aceptar_solicitud_modal(id, usuario_id):
    if "usuario_id" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor()
    # Validar admin
    cursor.execute("""
        SELECT s.equipo_id
        FROM solicitudes s
        JOIN equipo_integrantes ei ON ei.equipo_id = s.equipo_id
        WHERE s.id = %s AND ei.usuario_id = %s AND ei.es_admin = TRUE
    """, (id, session["usuario_id"]))
    solicitud = cursor.fetchone()

    if solicitud:
        # Actualizar solicitud
        cursor.execute("UPDATE solicitudes SET estado='aceptada' WHERE id=%s", (id,))
        # Agregar al equipo
        cursor.execute(
            "INSERT INTO equipo_integrantes (equipo_id, usuario_id, es_admin) VALUES (%s, %s, FALSE)",
            (solicitud['equipo_id'], usuario_id)
        )
        # Crear notificación
        mensaje = "Tu solicitud fue aceptada"
        cursor.execute(
            'INSERT INTO notificaciones (usuario_id, mensaje, tipo) VALUES (%s, %s, "respuesta")',
            (usuario_id, mensaje)
        )

        mysql.connection.commit()
        flash("Solicitud aceptada correctamente", "success")
    else:
        flash("No tienes permiso para aceptar esta solicitud", "danger")

    cursor.close()
    return redirect(request.referrer or url_for("index"))




# ---------- RECHAZAR SOLICITUD ----------
@app.route("/rechazar_solicitud_admin/<int:id>/<int:usuario_id>")
def rechazar_solicitud_admin(id, usuario_id):
    if "usuario_id" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor()
    # Validar admin
    cursor.execute("""
        SELECT s.equipo_id
        FROM solicitudes s
        JOIN equipo_integrantes ei ON ei.equipo_id = s.equipo_id
        WHERE s.id = %s AND ei.usuario_id = %s AND ei.es_admin = TRUE
    """, (id, session["usuario_id"]))
    solicitud = cursor.fetchone()

    if solicitud:
        cursor.execute("UPDATE solicitudes SET estado='rechazada' WHERE id=%s", (id,))
        # Crear notificación
        mensaje = "Tu solicitud fue rechazada"
        cursor.execute(
            'INSERT INTO notificaciones (usuario_id, mensaje, tipo) VALUES (%s, %s, "respuesta")',
            (usuario_id, mensaje)
        )

        mysql.connection.commit()
        flash("Solicitud rechazada correctamente", "success")
    else:
        flash("No tienes permiso para rechazar esta solicitud", "danger")

    cursor.close()
    return redirect(request.referrer or url_for("index"))



# ---------- ENVIAR SOLICITUD ----------
@app.route('/enviar_solicitud/<int:equipo_id>')
def enviar_solicitud(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()

    # Verificar si ya envió solicitud
    cursor.execute(
        'SELECT * FROM solicitudes WHERE usuario_id = %s AND equipo_id = %s',
        (usuario['id'], equipo_id)
    )
    if cursor.fetchone():
        flash("Ya enviaste una solicitud a este equipo", "warning")
    else:
        cursor.execute(
            'INSERT INTO solicitudes (usuario_id, equipo_id, estado) VALUES (%s, %s, %s)',
            (usuario['id'], equipo_id, 'pendiente')
        )

        # Obtener admins del equipo
        cursor.execute(
            'SELECT usuario_id FROM equipo_integrantes WHERE equipo_id = %s AND es_admin=TRUE',
            (equipo_id,)
        )
        admins = cursor.fetchall()
        mensaje = f"{usuario['nombre_completo']} ha solicitado unirse a tu equipo"

        for admin in admins:
            cursor.execute(
                'INSERT INTO notificaciones (usuario_id, mensaje, tipo) VALUES (%s, %s, "solicitud")',
                (admin['usuario_id'], mensaje)
            )

        mysql.connection.commit()
        flash("Solicitud enviada correctamente", "success")

    cursor.close()
    return redirect(url_for('index'))



@app.context_processor
def inject_notificaciones():
    if 'usuario' in session:
        usuario_id = session['usuario']['id']
        cursor = mysql.connection.cursor()  # <- aquí
        # Contar solicitudes pendientes donde el usuario sea admin del equipo
        cursor.execute('''
            SELECT COUNT(*) AS total
            FROM solicitudes s
            JOIN equipos e ON s.equipo_id = e.id
            WHERE s.estado="pendiente" AND e.creador_id=%s
        ''', (usuario_id,))
        pendiente = cursor.fetchone()['total']
        cursor.close()
        return dict(notificaciones_pendientes=pendiente)
    return dict(notificaciones_pendientes=0)



if __name__ == '__main__':
    app.run(debug=True)
