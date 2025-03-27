shader_type canvas_item;

uniform vec4 mix_color = vec4(0.1, 0.1, 0.1, 1.0); // The color of the vignette (darkening effect)
uniform float effect_strength = 0.0; //1000000.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);

    color.rgb = mix(color.rgb, mix_color.rgb, effect_strength);
    // Output the final color
    COLOR = color;
}
