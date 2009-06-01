-module (web_samples_tabs).
-ifdef(samples).

-include ("wf.inc").
-compile(export_all).

main() -> #template { file="./wwwroot/onecolumn.html", bindings=[
	{'Group', learn},
	{'Item', samples}
]}.

title() -> "Tabs Pane Example".
headline() -> "Tabs Pane Example".
right() -> linecount:render().

body() -> [
     #tabs{ tag=tabsTag,
	    options=[ {collapsible, true} ],
	    tabs=[
		  #tab{ tag=tabTag, title="Tab 1", body=["Tab one body..."] },
		  #tab{ title="Tab 2", body=#panel{ body=["Tab two body..."] }},
		  #tab{ title=[" ", #span{ text="<Tab 3>" }, " "], 
			body="Tab three body..." }
		  ]}
].
	
event(_) -> ok.

tabs_event(_Evt, _TabsTag, _TabTag, _Index) ->
    ok.

-endif.

