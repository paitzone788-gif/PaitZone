from flask import Flask, render_template, request, redirect, url_for, flash, session

app = Flask(__name__)
app.secret_key = "supersecretkey"

usuarios = []
proyectos = []  # Aquí se guardan los proyectos creados

@app.route('/')
def index():
    usuario = session.get('usuario')
    carrera_usuario = usuario['carrera'] if usuario else None
    codigo_usuario = usuario['codigo'] if usuario else None

    # Equipos a mostrar según la carrera
    equipos_filtrados = []
    for e in proyectos:
        if carrera_usuario in e['carreras_necesarias']:
            equipos_filtrados.append(e)

    return render_template("project.html", equipos=equipos_filtrados, usuario=usuario)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        datos = {
            "nombre": request.form['nombre'],
            "codigo": request.form['codigo'],
            "carrera": request.form['carrera'],
            "correo": request.form['correo'],
            "telefono": request.form['telefono'],
            "password": request.form['password']
        }

        if any(u['codigo'] == datos['codigo'] for u in usuarios):
            flash("El código ya está registrado", "danger")
            return redirect(url_for('register'))

        usuarios.append(datos)
        flash("Registro exitoso", "success")
        return redirect(url_for('login'))

    return render_template("register.html")

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        codigo = request.form['codigo']
        password = request.form['password']

        user = next((u for u in usuarios if u['codigo'] == codigo and u['password'] == password), None)
        if user:
            session['usuario'] = user
            flash(f"Bienvenido, {user['nombre']}", "success")
            return redirect(url_for('index'))
        else:
            flash("Código o contraseña incorrectos", "danger")
            return redirect(url_for('login'))

    return render_template("login.html")

@app.route('/logout')
def logout():
    session.pop('usuario', None)
    flash("Sesión cerrada", "info")
    return redirect(url_for('index'))

@app.route('/unirse/<int:equipo_id>')
def unirse(equipo_id):
    if 'usuario' not in session:
        flash("Debes iniciar sesión para unirte a un equipo", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']
    codigo_usuario = usuario['codigo']

    # Verificar si ya pertenece a algún proyecto
    for proyecto in proyectos:
        if any(i['codigo'] == codigo_usuario for i in proyecto['integrantes']):
            flash("Ya perteneces a un proyecto y no puedes unirte a otro", "danger")
            return redirect(url_for('index'))

    # Buscar el proyecto
    proyecto = next((p for p in proyectos if p['id'] == equipo_id), None)
    if proyecto:
        if len(proyecto['integrantes']) >= proyecto['max_integrantes']:
            flash("Este equipo ya está completo", "warning")
        else:
            proyecto['integrantes'].append(usuario)
            flash("Te has unido al equipo exitosamente", "success")
    else:
        flash("Equipo no encontrado", "danger")

    return redirect(url_for('index'))

@app.route('/create_project', methods=['GET', 'POST'])
def create_project():
    if 'usuario' not in session:
        flash("Debes iniciar sesión para crear un proyecto", "warning")
        return redirect(url_for('login'))

    usuario = session['usuario']

    # Verificar si ya pertenece a un proyecto
    for p in proyectos:
        if any(i['codigo'] == usuario['codigo'] for i in p['integrantes']):
            flash("Ya perteneces a un proyecto. No puedes crear otro.", "danger")
            return redirect(url_for('index'))

    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        max_integrantes = int(request.form['max_integrantes'])
        carreras_necesarias = request.form.getlist('carreras')

        nuevo_proyecto = {
            'id': len(proyectos) + 1,
            'nombre': nombre,
            'descripcion': descripcion,
            'max_integrantes': max_integrantes,
            'integrantes': [usuario],
            'carreras_necesarias': carreras_necesarias
        }

        proyectos.append(nuevo_proyecto)
        flash('Proyecto creado con éxito', 'success')
        return redirect(url_for('index'))

    carreras_disponibles = ['TPIN', 'BTGO', 'CARRERA3', 'CARRERA4']
    return render_template('create_project.html', carreras=carreras_disponibles)

if __name__ == '__main__':
    app.run(debug=True)
