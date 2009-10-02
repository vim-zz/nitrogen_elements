% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

%% This element is only needed until the title attribute is supported by nitrogens #link

-module (element_link_x).
-compile(export_all).

-include ("nitrogen_elements.hrl").

reflect() -> record_info(fields, link).

render(ControlID, Record) -> 
	case Record#link_x.postback of
		undefined -> ok;
		Postback -> wf:wire(ControlID, #event { type=click, postback=Postback })
	end,
	
	Content = [
		wf:html_encode(Record#link_x.text, Record#link_x.html_encode),
		wf:render(Record#link_x.body)
	],
	
	wf_tags:emit_tag(a, Content, [
		{id, ControlID},
		{href, Record#link_x.url},
		{class, [link, Record#link_x.class]},
		{style, Record#link_x.style},
		{title, wf:html_encode(Record#link_x.title, Record#link_x.html_encode)}
	]).
