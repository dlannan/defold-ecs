components {
  id: "lights"
  component: "/lumiere/effects/lights/lights.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/builtins/assets/meshes/quad_2x2.dae\"\n"
  "skeleton: \"\"\n"
  "animations: \"\"\n"
  "default_animation: \"\"\n"
  "name: \"unnamed\"\n"
  "materials {\n"
  "  name: \"default\"\n"
  "  material: \"/lumiere/effects/lights/apply_lights.material\"\n"
  "  textures {\n"
  "    sampler: \"input_tex\"\n"
  "    texture: \"/lumiere/transparent.png\"\n"
  "  }\n"
  "  textures {\n"
  "    sampler: \"lights_tex\"\n"
  "    texture: \"/lumiere/transparent.png\"\n"
  "  }\n"
  "}\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
