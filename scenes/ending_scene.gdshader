shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.07, 0.07, 0.07, 1.0); // Dark gray
uniform vec4 color2 : source_color = vec4(0.17, 0.24, 0.31, 1.0); // Dark blue

void fragment() {
    vec2 uv = UV;
    vec4 gradient = mix(color1, color2, uv.x * uv.y);
    COLOR = gradient;
}