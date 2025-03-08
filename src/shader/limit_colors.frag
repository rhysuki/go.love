#pragma language glsl3

/*
Replaces every color with the best match from a limited palette.
https://forum.godotengine.org/t/limit-games-color-palette/3470/2.

Takes in a 1-pixel-tall color palette, like the ones you'd download off Lospec.
See an example in assets/images/palettes/bubblegum_16.png.

Uses an adjusted version of human perception color weights to retain as much detail
and contrast between colors as possible; tries to match Aseprite's image indexing
algorithm.
*/

uniform Image palette;
uniform float r_weight = 0.22;
uniform float g_weight = 0.4;
uniform float b_weight = 0.07;

vec4 weigh(vec4 color)
{
	return vec4(
		color.r * r_weight,
		color.g * g_weight,
		color.b * b_weight,
		color.a
	);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 px = Texel(tex, texture_coords);
	int palette_width = textureSize(palette, 0).x;
	vec4 closest_color = vec4(0.0);

	for (int x = 0; x < palette_width; x++)
	{
		float palette_pixel_size = 1.0 / float(palette_width);
		float x_coordinate = float(x) * palette_pixel_size;
		vec4 palette_color = Texel(palette, vec2(x_coordinate, 0.0));

		if (distance(weigh(px), weigh(palette_color)) < distance(weigh(px), weigh(closest_color)))
		{
			closest_color = palette_color;
		}
	}

    px.rgb = closest_color.rgb;
    return px;
}