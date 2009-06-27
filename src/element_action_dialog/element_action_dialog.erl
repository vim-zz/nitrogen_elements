%%%-------------------------------------------------------------------
%%% Copyright 2009 Ceti Forge
%%% 
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%% 
%%% http://www.apache.org/licenses/LICENSE-2.0
%%% 
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an "AS
%%% IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
%%% express or implied.  See the License for the specific language
%%% governing permissions and limitations under the License.  
%%%
%%%-------------------------------------------------------------------
%%% File    : action_dialog.erl
%%% Author  : Tom McNulty <tom.mcnulty@cetiforge.com>
%%%
%%% Description : JQuery UI Dialog
%%%
%%%-------------------------------------------------------------------
-module(action_dialog).
-export([render_action/3, event/1]).
-include("zinc_elements.hrl").

render_action(_TriggerPath, _TargetPath, Record) -> 
    Id = wf:temp_id(),
    Content = wf_utils:js_escape(wf:render(#panel{id = Id, body=Record#dialog.body})),

    %% Buttons are ordered in the order they appear.
    Buttons = create_buttons(Record#dialog.buttons, Id, []),
    Buttons1 = case Record#dialog.show_cancel of
		   true ->
		       ["\"Cancel\": function() {"
			"$(this).dialog('destroy').remove();}" | Buttons];
		   false ->
		       Buttons 
	       end,
    Buttons2 = string:join(Buttons1, ", "),

    wf:f("jQuery(\"~s\").dialog({"
	 "modal: true, "
	 "closeOnEscape: true, "
	 "show: 'scale', hide: 'scale', "
	 "resizable: false, "
	 "width: ~p, height: ~p, "
	 "buttons: {~s}});", 
	 [Content, Record#dialog.width, Record#dialog.height, Buttons2]).

create_buttons([], _Id, Buttons) ->
    Buttons;
create_buttons([{Title, Postback}|Rest], Id, Buttons) ->
    Event = action_event:make_postback({Id, Postback}, click, me, me, ?MODULE),
    Button = wf:f("\"~s\": function() {~s; return false;}", [Title, Event]),
    create_buttons(Rest, Id, [Button | Buttons]).

event({Id, Tag}) ->
    Module = wf:get_page_module(),
    case Module:dialog_event(Tag) of
	ok -> wf:wire(wf:f("jQuery(\"#~s\").dialog('destroy').remove();", [Id]));
	_ -> ok
    end.
