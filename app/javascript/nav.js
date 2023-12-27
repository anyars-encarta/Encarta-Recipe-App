// JS for Hamburger Menu
$(document).ready(function() {
  const hamburger = document.querySelector('.hamburger');
  const navMenu = document.querySelector('.menu-links');

  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navMenu.classList.toggle('active');
  });

  document.querySelectorAll('.nav-link').forEach((n) => n.addEventListener('click', () => {
    hamburger.classList.remove('active');
    navMenu.classList.remove('active');
  }));
});
