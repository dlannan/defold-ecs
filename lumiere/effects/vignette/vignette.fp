varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 tint;
uniform lowp vec4 resolution;

//RADIUS of our vignette, where 0.5 results in a circle fitting the screen
const float RADIUS = 0.75;

//softness of our vignette, between 0.0 and 1.0
const float SOFTNESS = 0.45;

// https://www.shadertoy.com/view/4sXSWs
void main()
{
	vec2 uv = var_texcoord0.xy;

	lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

	//sample our texture
	vec4 texColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);

	//determine center
	vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);

	//OPTIONAL: correct for aspect ratio
	//position.x *= resolution.x / resolution.y;

	//determine the vector length from center
	float len = length(position);

	//our vignette effect, using smoothstep
	float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);

	//apply our vignette
	texColor.rgb = mix(texColor.rgb, tint_pm.rgb, 1.0-vignette);

	gl_FragColor = vec4(texColor.rgb, 1.0);	
}
