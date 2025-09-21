window.addEventListener('scroll', () => {
  const navbar = document.getElementById('mainNavbar');
  if (window.scrollY > 5) {
    navbar.classList.add('navbar-shrink');
  } else {
    navbar.classList.remove('navbar-shrink');
  }
});
