-module(element_force_reload_on_back_button).
-compile(export_all).

-include_lib("lib/nitrogen/include/wf.inc").
-record(force_reload_on_back_button, {?ELEMENT_BASE(element_force_reload_on_back_button)}).

reflect() -> record_info(fields, force_reload_on_back_button).

% desc: put this element if you need the page to reload whenever the user
% used the back button in order to return to the page. mostly needed on
% dinamic created pages

% in plain html/java this will look like this:
% function body_onload() {
%     if(document.getElementById("force_reload") != null) {
%         if(force_reload.value != "initialvalue") {
%             window.location = document.location.href;
%         } else {
%             force_reload.value = "newvalue"
%         }
%     }
% }
% <body onload=body_onload()>
% <input id="force_reload" type="hidden" value="initialvalue"/>

% i used jquery which better than using the body onload method
render(ControlID, _Record) ->
	JS = "$(function() {
		if(obj('" ++ ControlID ++ "').value != 'initialvalue')
			window.location = document.location.href;
		else
			obj('" ++ ControlID ++ "').value = 'newvalue';
	});",
	Hidden = #hidden{id=ControlID, text="initialvalue"},
	wf:wire(ControlID, JS),
	element_hidden:render(ControlID, Hidden).
