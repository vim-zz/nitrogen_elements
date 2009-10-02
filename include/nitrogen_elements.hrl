-ifndef(NITROGEN_ELEMENTS_HRL).
-define(NITROGEN_ELEMENTS_HRL, ok).

%% NOTE: set the include path bellow to your nitrogen installation location
-include("../nitrogen/include/wf.inc").

%% Elements
-record(force_reload_on_back_button, {?ELEMENT_BASE(element_force_reload_on_back_button)}).
-record(image_x, {?ELEMENT_BASE(element_image_x), image, alt, width, height, usemap}).
-record(textarea_x, {?ELEMENT_BASE(element_textarea_x), text="", html_encode=true, rows=2, columns=20}).
-record(link_x, {?ELEMENT_BASE(element_link_x), text="", title="", body="", html_encode=true, url="javascript:", postback}).
-record(tabs, {?ELEMENT_BASE(element_tabs), tabs=[], options=[], tag}).
-record(tab, {id=wf:temp_id(), title="No Title", body=[], tag, url}).
-record(menu, {?ELEMENT_BASE(element_menu), text="", body=[]}).
-record(lightbox_transparent, {?ELEMENT_BASE(element_lightbox_transparent), body="" }).
-record(notify, {?ELEMENT_BASE(element_notify), expire=false, msg}).
-record(flot_chart, {?ELEMENT_BASE(element_flot_chart), width, height, title,
	minx, maxx, miny, maxy, xticks, yticks,
	modex, modey, modex2, modey2,
	minx2, maxx2, miny2, maxy2, x2ticks, y2ticks,
	values, lines=true, points=true, bar=false, selectmode="xy",
	placeholder, legend, hover, click, select}).
-record(icon, {?ELEMENT_BASE(element_icon), kind, type, url="", body=[]}).
-record(image_map, {?ELEMENT_BASE(element_image_map), name, body=[]}).
-record(map_area, {?ELEMENT_BASE(element_map_area), shape, coords, href="", alt=""}).
		 
%% Actions
-record(tab_destroy, {?ACTION_BASE(action_tabs_methods)}).
-record(tab_disable, {?ACTION_BASE(action_tabs_methods), tab=-1}).
-record(tab_enable, {?ACTION_BASE(action_tabs_methods), tab=-1}).
-record(tab_option, {?ACTION_BASE(action_tabs_methods), key, value}).
-record(tab_add, {?ACTION_BASE(action_tabs_methods), url, label, index}).
-record(tab_remove, {?ACTION_BASE(action_tabs_methods), tab}).
-record(tab_select, {?ACTION_BASE(action_tabs_methods), tab}).
-record(tab_load, {?ACTION_BASE(action_tabs_methods), tab}).
-record(tab_url, {?ACTION_BASE(action_tabs_methods), tab, url}).
%-record(tab_length, {?ACTION_BASE(action_tabs_methods)}).
-record(tab_abort, {?ACTION_BASE(action_tabs_methods)}).
-record(tab_rotate, {?ACTION_BASE(action_tabs_methods), ms, continuing=false}).
-record(dialog, {?ACTION_BASE(action_dialog), body="", width="auto", height="auto", show_cancel=false ,buttons=[]}).

-endif.