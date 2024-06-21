components {
  id: "colorgrade"
  component: "/lumiere/effects/colorgrade/colorgrade.script"
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
  "  material: \"/lumiere/effects/colorgrade/colorgrade.material\"\n"
  "  textures {\n"
  "    sampler: \"original\"\n"
  "    texture: \"/lumiere/transparent.png\"\n"
  "  }\n"
  "  textures {\n"
  "    sampler: \"lut\"\n"
  "    texture: \"/lumiere/effects/colorgrade/lut16.png\"\n"
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
embedded_components {
  id: "lut"
  type: "sprite"
  data: "default_animation: \"lut16\"\n"
  "material: \"/lumiere/effects/colorgrade/colorgrade_lut.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/lumiere/effects/colorgrade/colorgrade_lut.atlas\"\n"
  "}\n"
  ""
  position {
    x: 128.0
    y: 8.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
