-module(element_image_map).
-compile(export_all).

-include("nitrogen_elements.hrl").
% -record(image_map, {?ELEMENT_BASE(element_image_map), name, body=[]}).

reflect() -> record_info(fields, image_map).

render(ControlID, Record) ->
	Content = wf:render(Record#image_map.body),
	wf_tags:emit_tag(map, Content, [
		{id, ControlID},
		{class, Record#image_map.class},
		{style, Record#image_map.style},
		{name, Record#image_map.name}
	]).
