
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
 setTimeout(() => {
  msg.style.transition = "all 1s ease";
  msg.style.opacity = "0";
  msg.style.transform = "translateY(-20px)";
  setTimeout(() => msg.remove(), 1000);
}, 3000);


