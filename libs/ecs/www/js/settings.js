$(document).ready(function() {
  
  updateData("routes", function(routedata) {
    var html_routes = "";
    for (let [key, item] of Object.entries(routedata.routes))   {
      item.forEach( function(rt, index, arr) {
        html_routes = html_routes + '<div class="alert bg-dark alert-dark text-white" role="alert">';
        html_routes = html_routes + '<text><b>' + key + ": </b></text><code>" + rt + '</code>';
        html_routes = html_routes + '</div>';
      });
    };

    $("#server-routes").html(html_routes);
  })
});