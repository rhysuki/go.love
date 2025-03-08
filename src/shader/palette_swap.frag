#pragma language glsl3

/*
Takes in an Image with 2 rows of pixels; a set of colors in the first
row, and the colors each of them should respectively map to in the second row.
See an example in assets/images/palettes/bubblegum_dark.png.
*/

uniform Image palette;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 px = Texel(tex, texture_coords);
	// vec4 out_color = px;
	int palette_width = textureSize(palette, 0).x;
	float palette_pixel_size = 1.0 / float(palette_width);

	for (int x = 0; x < palette_width; x++)
	{
		float x_coordinate = float(x) * palette_pixel_size + 0.00001;
		vec4 palette_color = Texel(palette, vec2(x_coordinate, 0.0));
		vec4 replacement_palette_color = Texel(palette, vec2(x_coordinate, 1.0));

		if (distance(px, palette_color) < 0.00001)
		{
			return replacement_palette_color;
		}
	}

	return px;
}