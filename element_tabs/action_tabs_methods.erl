% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Andreas Stenius
% See MIT-LICENSE for licensing information.

-module(action_tabs_methods).
-include("wf.inc").
-compile(export_all).

render_action(_TriggerPath, TargetPath, Record) ->
    Script = case element(1, Record) of
		 tab_destroy -> "'destroy'";
		 tab_disable ->
		     "'disable'" ++
			 case Record#tab_disable.tab of
			     -1 -> "";
			     Idx -> wf:f(", ~w", [Idx])
			 end;
		 tab_enable ->
		     "'enable'" ++
			 case Record#tab_enable.tab of
			     -1 -> "";
			     Idx -> wf:f(", ~w", [Idx])
			 end;
		 tab_option ->
		     wf:f("'option', '~s', ~s",
			  [Record#tab_option.key,
			   value_to_js(Record#tab_option.value)]);
		 tab_add ->
		     wf:f("'add', '~s', '~s'",
			  [Record#tab_add.url, Record#tab_add.label])
			 ++
			 case Record#tab_add.index of
			     undefined -> "";
			     Idx -> wf:f(", ~w", [Idx])
			 end;
		 tab_remove ->
		     wf:f("'remove', ~w", [Record#tab_remove.tab]);
		 tab_select ->
		     wf:f("'select', ~w", [Record#tab_select.tab]);
		 tab_load -> wf:f("'load', ~w", [Record#tab_load.tab]);
		 tab_url ->
		     wf:f("'url', ~w, '~s'",
			  [Record#tab_url.tab, Record#tab_url.url]);
		 tab_abort -> "'abort'";
		 tab_rotate ->
		     wf:f("'rotate', ~w, ~s",
			  [Record#tab_rotate.ms, Record#tab_rotate.continuing])
	     end,
    [wf:me_var(),
     wf:f("jQuery(obj('~s')).tabs(~s);",
	  [wf:to_js_id(TargetPath), Script])].

value_to_js(Value) when is_list(Value) ->
    wf:f("'~s'", [wf_utils:js_escape(Value)]);
value_to_js(Value) when Value == true; Value == false ->
    wf:f("~s", [Value]);
value_to_js(Value) when is_atom(Value) ->
    wf:f("'~s'", [Value]);
value_to_js(Value) -> wf:f("~p", [Value]).

