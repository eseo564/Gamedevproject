
shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.85, 0.0, 1.0);
uniform float glow_size : hint_range(1.0, 40.0) = 18.0;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.8;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    float outline = 0.0;

    vec2 pixel_size = TEXTURE_PIXEL_SIZE;

    for (int x = -20; x <= 20; x++) {
        for (int y = -20; y <= 20; y++) {
            vec2 offset_pixels = vec2(float(x), float(y));

            if (length(offset_pixels) <= glow_size) {
                vec2 sample_uv = UV + offset_pixels * pixel_size;

                if (sample_uv.x >= 0.0 && sample_uv.x <= 1.0 &&
                    sample_uv.y >= 0.0 && sample_uv.y <= 1.0) {
                    outline = max(outline, texture(TEXTURE, sample_uv).a);
                }
            }
        }
    }

    vec4 result = original;

    if (original.a < 0.1) {
        result.rgb = glow_color.rgb;
        result.a = outline * glow_strength;
    }

    COLOR = result;
}
