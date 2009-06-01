% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Andreas Stenius
% See MIT-LICENSE for licensing information.

-module (element_tabs).
-include ("nitrogen_elements.hrl").
-compile(export_all).

reflect() -> record_info(fields, tabs).

render(ControlID, Record) -> 
    PickledPostBackInfo = case Record#tabs.tag of
			      undefined -> "false";
			      Tag ->
				  [wf:wire(wf:f(
					    "Nitrogen.$tab(obj('~s'), '~s')",
					     [R#tab.id, wf_utils:pickle(R#tab.tag)]))
				   || R <- [#tab{ id=ControlID, tag=Record#tabs.tag }
					    |Record#tabs.tabs], R#tab.tag /= undefined],
				  
				  wf:f("'~s'",
				       [action_event:make_postback_info(
					  Tag, tabsevent,
					  ControlID, ControlID,
					  ?MODULE)
				       ])
			  end,
    
    Options = action_jquery_effect:options_to_js(
		Record#tabs.options),
    
    Script = wf:f("Nitrogen.$tabs(obj('~s'), ~s, ~s)",
		  [ControlID, Options, PickledPostBackInfo]),

    wf:wire(Script),
    
    Terms = #panel{
      class = "tabs " ++ wf:to_list(Record#tabs.class),
      style = Record#tabs.style,
      body = [
	      #list{ body=[
			   #listitem{ body=tab_link(Tab) }
			   || Tab <- Record#tabs.tabs ] },
	      [#panel{ id = Tab#tab.id,
		       class = "tab",
		       body = Tab#tab.body } 
	       || Tab <- Record#tabs.tabs]
	     ]
     },
    
    element_panel:render(ControlID, Terms).

event(TabsTag) ->
    [EventStr] = wf:q(event),
    [IndexStr] = wf:q(tab_index),
    [TabItem] = wf:q(tab_tag),
    Event = list_to_atom(EventStr),
    Index = list_to_integer(IndexStr),
    TabTag = wf:depickle(TabItem),
    Module = wf_platform:get_page_module(),
    Module:tabs_event(Event, TabsTag, TabTag, Index).

html_id(Id) ->
    case wf_path:is_temp_element(Id) of
	true ->
	    wf_path:to_html_id(Id);
	false ->
	    wf_path:push_path(Id),
	    HtmlId = wf_path:to_html_id(wf_path:get_path()),
	    wf_path:pop_path(),
	    HtmlId
    end.

tab_link(#tab{ url=undefined, id=Id, title=Title }) ->
    #link{ url="#" ++ html_id(Id), body=Title };
tab_link(#tab{ url=Url, id=Id, title=Title }) ->
    %% only needed until nitrogens #link supports the title attribute
    #link_x{ url=Url, title=html_id(Id), body=Title }.
