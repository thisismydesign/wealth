//= require active_admin/base
//= require activeadmin_addons/all

//= require chartkick
//= require Chart.bundle

// Ability to hide values
document.addEventListener('DOMContentLoaded', () => {
  const menuItem = document.getElementById('hide_values');
  let toggle = localStorage.getItem('hideValues') === 'true';

  const setValuesVisibility = (hide) => {
    document.querySelector('#hide_values a').textContent = `Hide values: ${hide ? 'true' : 'false'}`;
    const valuesToHide = document.querySelectorAll('.secret');
    valuesToHide.forEach(value => {
      if (hide) {
        value.classList.add('hidden-value');
      } else {
        value.classList.remove('hidden-value');
      }
    });
  };

  setValuesVisibility(toggle);

  if (menuItem) {
    menuItem.addEventListener('click', (event) => {
      event.preventDefault();
      toggle = !toggle;
      localStorage.setItem('hideValues', toggle);
      setValuesVisibility(toggle);
    });
  }
});
