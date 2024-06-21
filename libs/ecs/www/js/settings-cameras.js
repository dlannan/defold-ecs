function formatVec( param )  {
  let vec = "x:" + param.x + ", ";
  vec = vec + "y:" + param.y + ", ";
  vec = vec + "z:" + param.z;
  if(param.w) vec = vec + ", w:" + param.w;
  return vec;
}

function UpdateCameraProps( )
{
  if(g_cameras.cameras.length > 0) {

    let html_props = "";
    var cam = g_cameras.cameras[g_current_camera];
    console.log(cam);
    // By default set the first camera when starting (if there are any)
    for (let [key, item] of Object.entries(cam))   {
      if(key == "rot" || key == "pos") item = formatVec(item);
      html_props = html_props + '<tr>';
      html_props = html_props + '<td>' + key + '</td>';
      html_props = html_props + '<td>' + item + '</td>';
      html_props = html_props + '<td><a href="#!"><i class="ik ik-edit f-16 mr-15 text-green"></i></a></td>';
      html_props = html_props + '</tr>';
    }
    $("#camera-props table tbody").html(html_props);
  }
}

$(document).ready(function() {

  updateData("/data/world/cameras", function(cameras) {
    var html_cameras = "";
    g_cameras = cameras;
    
    cameras.cameras.forEach( function(cam, index, arr) {
      console.log(index);
      html_cameras = html_cameras + '<div class="row">';
      html_cameras = html_cameras + '<div class="col-auto text-right update-meta pr-0">';
      html_cameras = html_cameras + '<i class="ik ik-camera bg-blue update-icon"></i>';
      html_cameras = html_cameras + '</div>';
      html_cameras = html_cameras + '<div class="col pl-5">';
      html_cameras = html_cameras + '<div class="camera-select" data="'+ index + '"><a href="#!"><h6>' + cam.name + '</h6></a></div>';
      html_cameras = html_cameras + '</div>';
      html_cameras = html_cameras + '<div class="col-2 pl-5">';
      html_cameras = html_cameras + '<a href="#!" style="color: white;padding-top:6px;"><h4><i name="'+ cam.name + '" data="' + cam.go + '" class="ik ik-aperture camera-set"></i></h4></a>';
      html_cameras = html_cameras + '</div></div>';
    });
    
    $("#cameras-list").html(html_cameras);
    UpdateCameraProps();
  });

  $(".camera-select").on("click", function(e) {
    console.log(this);
    let index = $(this).attr("data");
    g_current_camera = Number(index);
    UpdateCameraProps();
  });

  $(".camera-set").on("click", function(e) {
  
      let go = $(this).attr("data");
      let name = $(this).attr("name");
      postData("/world/camera/enable", { go: go, name: name }, function() {});
  });
});