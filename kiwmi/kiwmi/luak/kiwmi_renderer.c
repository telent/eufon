/* Copyright (c), Niclas Meyer <niclas@countingsort.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at https://mozilla.org/MPL/2.0/.
 */

#include "luak/kiwmi_renderer.h"

#include <stdlib.h>
#include <string.h>

#include <lauxlib.h>
#include <wlr/render/wlr_renderer.h>
#include <wlr/types/wlr_output.h>
#include <wlr/util/log.h>

#include <drm/drm_fourcc.h>

#include "color.h"
#include "desktop/output.h"
#include "luak/lua_compat.h"
#include "luak/luak.h"

struct kiwmi_renderer {
    struct wlr_renderer *wlr_renderer;
    struct kiwmi_output *output;
};

static int
l_kiwmi_renderer_draw_rect(lua_State *L)
{
    struct kiwmi_renderer *renderer =
        (struct kiwmi_renderer *)luaL_checkudata(L, 1, "kiwmi_renderer");
    luaL_checktype(L, 2, LUA_TSTRING); // color
    luaL_checktype(L, 3, LUA_TNUMBER); // x
    luaL_checktype(L, 4, LUA_TNUMBER); // y
    luaL_checktype(L, 5, LUA_TNUMBER); // width
    luaL_checktype(L, 6, LUA_TNUMBER); // height

    struct wlr_renderer *wlr_renderer = renderer->wlr_renderer;
    struct kiwmi_output *output       = renderer->output;
    struct wlr_output *wlr_output     = output->wlr_output;

    float color[4];
    if (!color_parse(lua_tostring(L, 2), color)) {
        return luaL_argerror(L, 2, "not a valid color");
    }

    struct wlr_box box = {
        .x      = lua_tonumber(L, 3),
        .y      = lua_tonumber(L, 4),
        .width  = lua_tonumber(L, 5),
        .height = lua_tonumber(L, 6),
    };

    wlr_render_rect(wlr_renderer, &box, color, wlr_output->transform_matrix);

    return 0;
}

static int
l_kiwmi_renderer_draw_texture(lua_State *L)
{
    struct kiwmi_renderer *renderer =
        (struct kiwmi_renderer *) luaL_checkudata(L, 1, "kiwmi_renderer");
    struct wlr_texture *texture = (struct wlr_texture *) lua_touserdata(L, 2);

    float projection[9];

    for(int i=0; i<9; i++) {
	lua_pushnumber(L, i+1);
	lua_gettable(L, 3);
	projection[i] = lua_tointeger(L, -1);
    }

    luaL_checktype(L, 4, LUA_TNUMBER); /* x  */
    luaL_checktype(L, 5, LUA_TNUMBER); /* y  */
    luaL_checktype(L, 6, LUA_TNUMBER); // alpha

    struct wlr_renderer *wlr_renderer = renderer->wlr_renderer;

    wlr_render_texture(wlr_renderer, texture, projection,
		       lua_tonumber(L, 4),
		       lua_tonumber(L, 5),
		       lua_tonumber(L, 6));

    return 0;
}

static int
l_kiwmi_renderer_texture_from_pixels(lua_State *L)
{
    struct kiwmi_renderer *renderer =
        (struct kiwmi_renderer *)luaL_checkudata(L, 1, "kiwmi_renderer");

    struct wlr_renderer *wlr_renderer = renderer->wlr_renderer;
    struct wlr_texture * texture;

    luaL_checktype(L, 2, LUA_TNUMBER); // stride
    luaL_checktype(L, 3, LUA_TNUMBER); // width
    luaL_checktype(L, 4, LUA_TNUMBER); // height

    char *data =  lua_tostring(L, 5);

    texture = wlr_texture_from_pixels(wlr_renderer,
				      DRM_FORMAT_ARGB8888,
				      lua_tonumber(L, 2),
				      lua_tonumber(L, 3),
				      lua_tonumber(L, 4),
				      data);

    lua_pushlightuserdata(L, texture);

    return 1;
}

static const luaL_Reg kiwmi_renderer_methods[] = {
    {"draw_rect", l_kiwmi_renderer_draw_rect},
    {"draw_texture", l_kiwmi_renderer_draw_texture},
    {"texture_from_pixels", l_kiwmi_renderer_texture_from_pixels},
    {NULL, NULL},
};

int
luaK_kiwmi_renderer_new(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TLIGHTUSERDATA); // kiwmi_lua
    luaL_checktype(L, 2, LUA_TLIGHTUSERDATA); // wlr_renderer
    luaL_checktype(L, 3, LUA_TLIGHTUSERDATA); // wlr_output

    struct kiwmi_lua *UNUSED(lua)     = lua_touserdata(L, 1);
    struct wlr_renderer *wlr_renderer = lua_touserdata(L, 2);
    struct kiwmi_output *output       = lua_touserdata(L, 3);

    struct kiwmi_renderer *renderer_ud =
        lua_newuserdata(L, sizeof(*renderer_ud));
    luaL_getmetatable(L, "kiwmi_renderer");
    lua_setmetatable(L, -2);

    renderer_ud->wlr_renderer = wlr_renderer;
    renderer_ud->output       = output;

    return 1;
}

int
luaK_kiwmi_renderer_register(lua_State *L)
{
    luaL_newmetatable(L, "kiwmi_renderer");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaC_setfuncs(L, kiwmi_renderer_methods, 0);

    lua_pushcfunction(L, luaK_usertype_ref_equal);
    lua_setfield(L, -2, "__eq");

    return 0;
}
