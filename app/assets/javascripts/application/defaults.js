$(document).ready(function() {

  // Enable dropdowns
  $('.dropdown-toggle').dropdown();

  // Enable tabs
  $('.nav-tabs a').hover(function(e) {
    e.preventDefault();
    $(this).tab('show');
  });

});
