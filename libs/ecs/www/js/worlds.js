$("#system-information").hide();

$(document).ready(function() {

  console.log(g_worlds);
  html_worlds = "";
  g_worlds.worlds.forEach( function(item, index ) {
    html_worlds = html_worlds + '<a class="dropdown-item" data="'+ index + '">'+ item.name +'</a>';
  });

  $("#worlds-select").html(html_worlds);

  $(".dropdown-item").on('click', function (e) {

    $("#system-information").show();

    updateData("/data/world/current", function(worlddata)
    {
      g_current_world = worlddata.world;
console.log(g_current_world);
      $("#worlds-entities").html(g_current_world.entity_count);
      $("#worlds-filters").html(g_current_world.systems.length);
      $("#worlds-cameras").html(g_current_world.camera_count);
      $("#worlds-title").html('World Select: <b>' + e.target.innerHTML  + '</b>');
      $("#worlds-card-title").html('<h3>Filter System: <b>' + e.target.innerHTML  + '</b></h3>');
    }); 
  });
});