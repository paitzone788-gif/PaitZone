
    const checkboxes = document.querySelectorAll('.carrera-checkbox');
    const maxCarreras = 4;

    checkboxes.forEach(cb => {
        cb.addEventListener('change', () => {
            const checked = document.querySelectorAll('.carrera-checkbox:checked');
            if (checked.length > maxCarreras) {
                cb.checked = false; // desmarca el último
                alert(`Solo puedes seleccionar máximo ${maxCarreras} carreras.`);
            }
        });
    });





    //ventana flotante



    // Cerrar automáticamente los flashes después de 5 segundos
    window.addEventListener('DOMContentLoaded', (event) => {
        const alerts = document.querySelectorAll('#flash-messages .alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.classList.remove('show');
                alert.classList.add('hide');
            }, 5000);
        });
    });

