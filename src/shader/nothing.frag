/*
Shader that doesn't do anything, to (hopefully) fix a really weird bug with push.
*/
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor * color;
}