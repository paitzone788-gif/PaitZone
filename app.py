from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from functools import wraps

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

    # Traer todos los equipos disponibles de la misma carrera que el usuario
    if usuario:
        cursor.execute('''
            SELECT e.* FROM equipos e
            JOIN equipo_carreras ec ON e.id = ec.equipo_id
            JOIN carreras c ON ec.carrera_id = c.id
            WHERE c.nombre = %s
        ''', (usuario['carrera'],))
    else:
        cursor.execute('SELECT * FROM equipos')
    
    equipos = cursor.fetchall()

    for equipo in equipos:
        cursor.execute('''
            SELECT u.id, u.nombre_completo, u.carrera 
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

    cursor.close()
    return render_template("project.html", equipos=equipos, usuario=usuario, mi_proyecto=mi_proyecto)

# ruta admin
@app.route('/admin')
@admin_required
def admin_panel():
    return render_template('admin.html')

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
    cursor.execute("DELETE FROM usuarios WHERE id=%s", (id,))
    mysql.connection.commit()
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
@app.route('/admin/agregar_usuario', methods=['GET','POST'])
@admin_required
def agregar_usuario():
    if request.method == 'POST':
        nombre = request.form['nombre']
        carrera = request.form['carrera']
        codigo = request.form['codigo']
        correo = request.form['correo']
        telefono = request.form['telefono']
        contrasena = request.form['contrasena']
        role = request.form.get('role', 'user')

        cursor = mysql.connection.cursor()
        cursor.execute('''INSERT INTO usuarios(nombre_completo, carrera, codigo, correo, telefono, contrasena, role)
                          VALUES (%s,%s,%s,%s,%s,%s,%s)''', 
                       (nombre, carrera, codigo, correo, telefono, contrasena, role))
        mysql.connection.commit()
        cursor.close()
        flash("Usuario agregado", "success")
        return redirect(url_for('admin_usuarios'))

    return render_template('agregar_usuario.html')


# Registro de usuario
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nombre = request.form['nombre']
        carrera = request.form['carrera']
        codigo = request.form['codigo']
        correo = request.form['correo']
        telefono = request.form['telefono']
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

        cursor.execute('''
            INSERT INTO usuarios(nombre_completo, carrera, codigo, correo, telefono, contrasena)
            VALUES (%s,%s,%s,%s,%s,%s)
        ''', (nombre, carrera, codigo, correo, telefono, password))
        mysql.connection.commit()
        cursor.close()
        flash("Registro exitoso, ahora inicia sesión", "success")
        return redirect(url_for('login'))

    return render_template("register.html")


# Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        codigo = request.form['codigo']
        password = request.form['password']

        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM usuarios WHERE codigo = %s AND contrasena = %s', (codigo, password))
        user = cursor.fetchone()
        cursor.close()

        if user:
            # Guardar en sesión incluyendo el role
            session['usuario'] = {
                'id': user['id'],
                'nombre_completo': user['nombre_completo'],
                'carrera': user['carrera'],
                'codigo': user['codigo'],
                'correo': user['correo'],
                'telefono': user.get('telefono'),
                'role': user.get('role', 'user')  # por si no tiene role definido
            }

            flash(f"Bienvenido, {user['nombre_completo']}", "success")

            # Redirigir según rol
            if session['usuario']['role'] == 'admin':
                return redirect(url_for('admin_panel'))  # ruta de admin
            else:
                return redirect(url_for('index'))  # usuario normal

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
        cursor.execute("INSERT INTO equipos(nombre_proyecto, descripcion, max_integrantes, creador_id) VALUES (%s,%s,%s,%s)",
                       (nombre, descripcion, max_integrantes, session['usuario']['id']))
        mysql.connection.commit()
        cursor.close()
        flash("Equipo agregado", "success")
        return redirect(url_for('admin_equipos'))

    # Para seleccionar carreras asociadas (opcional)
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

    # Integrantes del equipo
    cursor.execute('''
        SELECT u.nombre_completo AS nombre, u.carrera
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
        max_carreras = min(4, max_integrantes)
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

            # Verificar si el usuario ya está en el equipo
            cursor.execute(
                "SELECT * FROM equipo_integrantes WHERE equipo_id=%s AND usuario_id=(SELECT id FROM usuarios WHERE nombre_completo=%s LIMIT 1)",
                (equipo_id, integrante_nombre)
            )
            if not cursor.fetchone():
                cursor.execute(
                    "INSERT INTO equipo_integrantes (equipo_id, usuario_id) "
                    "SELECT %s, id FROM usuarios WHERE nombre_completo=%s LIMIT 1",
                    (equipo_id, integrante_nombre)
                )

        # Insertar las carreras asociadas
        for carrera_nombre in carreras_seleccionadas:
            cursor.execute("SELECT id FROM carreras WHERE nombre=%s", (carrera_nombre,))
            carrera_row = cursor.fetchone()
            if carrera_row:
                carrera_id = carrera_row['id']
                cursor.execute(
                    "INSERT INTO equipo_carreras (equipo_id, carrera_id) VALUES (%s,%s)",
                    (equipo_id, carrera_id)
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


# Salir de equipo
@app.route('/salir/<int:equipo_id>')
def salir(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM equipo_integrantes WHERE equipo_id = %s AND usuario_id = %s', (equipo_id, usuario['id']))
    mysql.connection.commit()
    cursor.close()
    flash("Has salido del equipo", "info")
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
