$(document).ready(function() {
  
  $(".entities-set-enable").on('click', function(e) {
    let name = $(e.target).attr("data");
    let enabled = false;
    if(name == "enable") enabled = true;

    let index = $("#systems-title").attr("data");
    let system = g_systems.systems[index];
    let senddata = { enabled: enabled, system: system };

    // Probably should check status and data
    postData("/systems/enable", senddata, function(data, status) {
    });
  });

  updateData("/data/routes", function(routedata) {
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