-module(element_map_area).
-compile(export_all).

-include("nitrogen_elements.hrl").
% -record(map_area, {?ELEMENT_BASE(element_map_area), shape, coords, href="", alt=""}).


reflect() -> record_info(fields, map_area).

render(ControlID, Record) ->
	wf_tags:emit_tag(area, [
		{id, ControlID},
		{class, Record#map_area.class},
		{style, Record#map_area.style},
		{shape, Record#map_area.shape},
		{coords, Record#map_area.coords},
		{href, Record#map_area.href},
		{alt, Record#map_area.alt}
	]).
