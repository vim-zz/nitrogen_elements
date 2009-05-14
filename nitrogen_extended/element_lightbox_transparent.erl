-module (element_lightbox_transparent).

-include_lib("eunit/include/eunit.hrl").
-include("dinamo_wf.hrl").
-include("dinamo.hrl").

-compile(export_all).

-record(lightbox_transparent, {?ELEMENT_BASE(element_lightbox_transparent), body="" }).

% desc: the same as basic lightbox, but with transparent background

reflect() -> record_info(fields, lightbox_transparent).

render(ControlID, Record) -> 
	Terms = #panel {
		class=lightbox,
		style="position: fixed; top: 0px; left: 0px; bottom: 0px; right: 0px;",
		body=[
			#panel{ 			
				class=lightbox_background, 
				style=
					"position: fixed; top: 0px; left: 0px; bottom: 0px; right: 0px;"
					" z-index: 98; background-color: #000;"
					" opacity: .70; " % FOR ALL OTHER BROWSERS AND DEVICES
					" filter: alpha(opacity=70); " % FOR IE7
			},
			#table { 
				style="position: fixed; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 99; overflow:auto;", 
				rows=#tablerow {
					cells=#tablecell{
						align=center, 
						valign=middle, 
						style="vertical-align: middle;", 
						body=Record#lightbox_transparent.body 
		}}}]
	},
	element_panel:render(ControlID, Terms).
