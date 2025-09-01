from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from functools import wraps
from werkzeug.security import generate_password_hash
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

# Página de inicio -> muestra equipos
@app.route('/')
def index():
    cursor = mysql.connection.cursor()
    usuario = session.get('usuario')

    if usuario:
        # Solo equipos que necesiten la carrera del usuario
        cursor.execute('''
            SELECT DISTINCT e.*, 
                   (SELECT COUNT(*) FROM equipo_integrantes ei WHERE ei.equipo_id = e.id) AS integrantes_actuales
            FROM equipos e
            JOIN equipo_carreras ec ON e.id = ec.equipo_id
            JOIN carreras c ON ec.carrera_id = c.id
            WHERE c.nombre = %s
        ''', (usuario['carrera'],))
    else:
        # Visitante ve todos
        cursor.execute('''
            SELECT e.*, 
                   (SELECT COUNT(*) FROM equipo_integrantes ei WHERE ei.equipo_id = e.id) AS integrantes_actuales
            FROM equipos e
        ''')

    equipos = cursor.fetchall()

    # Filtrar equipos que no estén llenos (o que ya tenga el usuario dentro)
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

    # Agregar integrantes y carreras necesarias a cada equipo
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

    # Verificar si el usuario ya tiene un proyecto
    mi_proyecto = None
    if usuario:
        cursor.execute('''
            SELECT e.* FROM equipos e
            JOIN equipo_integrantes ei ON e.id = ei.equipo_id
            WHERE ei.usuario_id = %s
            LIMIT 1
        ''', (usuario['id'],))
        mi_proyecto = cursor.fetchone()

        if mi_proyecto:
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

    cursor.close()
    return render_template("project.html", equipos=equipos, usuario=usuario, mi_proyecto=mi_proyecto)





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

        # Insertar equipo
        cursor.execute(
            "INSERT INTO equipos(nombre_proyecto, descripcion, max_integrantes, creador_id) VALUES (%s,%s,%s,%s)",
            (nombre, descripcion, max_integrantes, session['usuario']['id'])
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

    # Buscar proyecto del usuario
    cursor.execute('''
        SELECT e.id, e.nombre_proyecto, e.descripcion, e.max_integrantes
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
        SELECT u.nombre_completo AS nombre_completo,
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
        integrantes_raw = request.form['integrantes']
        carreras_seleccionadas = request.form.getlist('carreras')

        # Limitar el número de carreras al máximo permitido
        max_carreras = min(4, len(carreras_seleccionadas))
        carreras_seleccionadas = carreras_seleccionadas[:max_carreras]

        # Crear el equipo
        cursor.execute(
            "INSERT INTO equipos (nombre_proyecto, descripcion, max_integrantes, creador_id) VALUES (%s,%s,%s,%s)",
            (nombre, descripcion, max_integrantes, usuario['id'])
        )
        equipo_id = cursor.lastrowid

        # Insertar al creador del equipo
        cursor.execute(
            "INSERT INTO equipo_integrantes (equipo_id, usuario_id) VALUES (%s, %s)",
            (equipo_id, usuario['id'])
        )

        # Insertar otros integrantes, evitando duplicados
        integrantes = [i.strip() for i in integrantes_raw.split(',') if i.strip()]
        for integrante_nombre in integrantes:
            if integrante_nombre == usuario['nombre_completo']:
                continue  # evitar duplicar al creador
            cursor.execute(
                "INSERT INTO equipo_integrantes (equipo_id, usuario_id) "
                "SELECT %s, id FROM usuarios WHERE nombre_completo=%s LIMIT 1",
                (equipo_id, integrante_nombre)
            )

        # Insertar las carreras asociadas con cantidad
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

    # Traer todas las carreras para el formulario
    cursor.execute("SELECT nombre FROM carreras")
    carreras = [row['nombre'] for row in cursor.fetchall()]
    cursor.close()
    return render_template("create_project.html", carreras=carreras)




# Unirse a proyecto
@app.route('/unirse/<int:equipo_id>')
def unirse(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión para unirte a un equipo", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM equipo_integrantes WHERE usuario_id = %s', (usuario['id'],))
    if cursor.fetchone():
        flash("Ya perteneces a un equipo y no puedes unirte a otro", "danger")
        cursor.close()
        return redirect(url_for('index'))

    cursor.execute('INSERT INTO equipo_integrantes(equipo_id, usuario_id) VALUES (%s, %s)', (equipo_id, usuario['id']))
    mysql.connection.commit()
    cursor.close()
    flash("¡Te uniste a un equipo!", "success")
    return redirect(url_for('index'))


# Equipos disponibles
@app.route('/equipos_disponibles')
def equipos_disponibles():
    if 'usuario' not in session:
        flash("Debes iniciar sesión para ver los equipos", "warning")
        return redirect(url_for('login'))
    usuario = session['usuario']
    # Aquí va tu lógica para filtrar equipos según la carrera del usuario
    # ...
    return render_template('equipos_disponibles.html', usuario=usuario, equipos=equipos)

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


if __name__ == '__main__':
    app.run(debug=True)
