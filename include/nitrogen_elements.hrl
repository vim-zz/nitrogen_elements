
-include_lib("nitrogen/include/wf.inc").

%% Elements
-record(force_reload_on_back_button, {?ELEMENT_BASE(element_force_reload_on_back_button)}).
-record(image_x, {?ELEMENT_BASE(element_image_x), image, alt, width, height, usemap}).
-record(textarea_x, {?ELEMENT_BASE(element_textarea_x), text="", html_encode=true, rows=2, columns=20}).
-record(link_x, {?ELEMENT_BASE(element_link_x), text="", title="", body="", html_encode=true, url="javascript:", postback}).
-record(tabs, {?ELEMENT_BASE(element_tabs), tabs=[], options=[], tag}).
-record(tab, {id=wf:temp_id(), title="No Title", body=[], tag, url}).
-record(menu, {?ELEMENT_BASE(element_menu), text="", body=[]}).
-record(lightbox_transparent, {?ELEMENT_BASE(element_lightbox_transparent), body="" }).

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
