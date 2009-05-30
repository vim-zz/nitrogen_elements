-module(element_image_x).
-compile(export_all).

-include_lib("lib/nitrogen/include/wf.inc").
-record(image_x, {?ELEMENT_BASE(element_image_x), image, alt, width, height, usemap}).

% desc: this enhance the basic image element, mostly for using 'usemap' tag
% it also allow adding inline width/height to the iamge


reflect() -> record_info(fields, image_x).

render(ControlID, Record) ->
	Attributes = [
		{id, ControlID},
		{class, [image, Record#image_x.class]},
		{style, Record#image_x.style},
		{src, Record#image_x.image},
		{usemap, Record#image_x.usemap}
	],
	
	OptionalArgs = [fun add_alt/2, fun add_width/2, fun add_height/2],
	FinalAttributes = lists:foldl(fun(F, X) -> F(Record, X) end, Attributes, OptionalArgs),
	wf_tags:emit_tag(img, FinalAttributes).



add_alt(Record, Attributes) ->
	case Record#image_x.alt of
		undefined -> Attributes;
		Val -> [{alt, Val}|Attributes]
	end.

add_width(Record, Attributes) ->
	case Record#image_x.width of
		undefined -> Attributes;
		Val -> [{width, Val}|Attributes]
	end.
	
add_height(Record, Attributes) ->
	case Record#image_x.height of
		undefined -> Attributes;
		Val -> [{height, Val}|Attributes]
	end.	
