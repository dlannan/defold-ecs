$(document).ready(function() {

  html_systems = "";
  console.log(g_systems);
  g_systems.systems.forEach( function(item, index ) {
    html_systems = html_systems + '<a class="dropdown-item" data="'+ index + '">'+ item.name +'</a>';
  });

  $("#systems-select").html(html_systems);

  $(".dropdown-item").on('click', function (e) {
    let index = $(e.target).attr("data");
    let system = g_systems.systems[index];

    $("#systems-title").html('System Select: <b>' + e.target.innerHTML  + '</b>');
    $("#systems-card-title").html('<h3>Filter System: <b>' + e.target.innerHTML  + '</b></h3>');

    var system_filters = "";
    system.filters.forEach( function(sys, index, arr) {
      system_filters = system_filters + '<div class="alert bg-dark alert-dark text-white" role="alert">';
      system_filters = system_filters + '<code>' + sys + '</code>';
      system_filters = system_filters + '</div>';
    });  
    $("#system-filters").html(system_filters);
  });
});