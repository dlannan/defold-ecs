$("#system-information").hide();

$(document).ready(function() {

  html_systems = "";
  g_systems.systems.forEach( function(item, index ) {
    html_systems = html_systems + '<a class="dropdown-item" data="'+ index + '">'+ item.name +'</a>';
  });

  $("#systems-select").html(html_systems);

  $(".systems-set-enable").on('click', function(e) {
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

  if(g_allsystems_enabled == true) {
    $('#allsystems-enable').prop('checked',true); 
    $('#allsystems-disable').prop('checked',false); 
  }else{
    $('#allsystems-enable').prop('checked',false); 
    $('#allsystems-disable').prop('checked',true); 
  }  

  $(".allsystems-set-enable").on('click', function(e) {
    let name = $(e.target).attr("data");
    g_allsystems_enabled = false;
    if(name == "enable") g_allsystems_enabled = true;

    let systems = g_systems.systems;
    for( var i=0; i<systems.length; i++) {
      let senddata = { enabled: g_allsystems_enabled, system: systems[i] };
      // Probably should check status and data
      postData("/systems/enable", senddata, function(data, status) {
      });
    }
  });  

  $(".dropdown-item").on('click', function (e) {

    $("#system-information").show();

    updateData("/data/systems", function(systemsdata)
    {
      g_systems = systemsdata;
      let index = $(e.target).attr("data");
      let system = g_systems.systems[index];

      if(system.active == true) {
        $('#system-enable').prop('checked',true); 
        $('#system-disable').prop('checked',false); 
      }else{
        $('#system-enable').prop('checked',false); 
        $('#system-disable').prop('checked',true); 
      }      

      $("#systems-entities").html(system.entity_count);
      $("#systems-filters").html(system.filters.length);
      $("#systems-calls").html(system.calls);
      $("#systems-title").html('System Select: <b>' + e.target.innerHTML  + '</b>');
      $("#systems-title").attr("data", index);
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
});