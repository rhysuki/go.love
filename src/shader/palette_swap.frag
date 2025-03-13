#pragma language glsl3

/*
Swaps specific colors with specific replacements.
*/

/*
A 2-pixel-tall image. The first row of pixels represents a set of colors that should
be replaced, and the second row has the colors each of them should respectively map to.


There's preloaded palettes on `assets/data/collections/images.lua`, to use like so:
`limit_colors_shader:send("palette", IMAGES.palette_swap_bubblegum_16_dark)`
*/
uniform Image palette;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 px = Texel(tex, texture_coords);
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