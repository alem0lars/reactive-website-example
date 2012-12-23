//= require application/_yinyang

//= require application/_resource_selectors
//= require application/_resource_libs
// { Resources views libraries
//= require builds/_show
//= require steps/_show
//= require actions/_show
// }


$(document).ready(function() {

  builds_show.init();

});

$(document).bind('resourceviewloaded', function(e, res_type, first_time) {

  // TODO: check if resource is >= of builds
  // Render the appropriate resource view
  var res_lib = resource_libs.lookup('{1}_show'.assign(res_type));
  if (first_time) {
    res_lib.init();
  } else {
    res_lib.redraw();
  }

});
