$(document).ready(function() {

    var num_cams = 0;
    g_entities.entities.forEach( function (item, index, arr) {
      if(item.etype == "camera") num_cams++;
    });

    $("#world_count").html("<h2>" + g_worlds.worlds.length + "</h2>");
    $("#entities_count").html("<h2>" + g_entities.entities.length + "</h2>");
    $("#camera_count").html("<h2>" + num_cams + "</h2>");
    $("#systems_count").html("<h2>" + g_systems.systems.length + "</h2>");
});