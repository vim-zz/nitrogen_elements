-module(element_textarea_x).
-compile(export_all).

-include("nitrogen_elements.hrl").
%% -record(textarea_x, {?ELEMENT_BASE(element_textarea_x), text="", html_encode=true, rows=2, columns=20}).

% desc: enhance the basic textarea with inline cols/rows values

reflect() -> record_info(fields, textarea_x).

render(ControlID, Record) ->
	Content = wf:html_encode(Record#textarea_x.text, Record#textarea_x.html_encode),
	wf_tags:emit_tag(textarea, Content, [
		{id, ControlID},
		{name, ControlID},
		{class, [textarea, Record#textarea_x.class]},
		{style, Record#textarea_x.style},
		{rows, Record#textarea_x.rows},
		{columns, Record#textarea_x.columns}
	]).
