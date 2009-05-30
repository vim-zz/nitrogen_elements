-module(element_notify).
-compile(export_all).

-include_lib("nitrogen/include/wf.inc").
-include("elements.hrl").

reflect() -> record_info(fields, notify).

render() ->
    wf:render(#panel{id=notification_area})
.

-define(HIDE(Type, Delay, Id), #event{type=Type, delay=Delay
    , actions=#hide{effect=blind, target=Id}}).

render(ControlId, R) when is_record(R, notify) ->
    Id = ControlId
    , case R#notify.expire of
        false ->
            undefined;
        N when is_integer(N) ->
            % we expire in this many seconds
            wf:wire(Id, ?HIDE('timer', N, Id));
        Err ->
            % log error and don't expire
            iterate_log:log_warning(wf:f("encountered unknown expire value: ~p"
                , [Err]))
            , undefined
    end
    , Link = #link{text="dismiss", actions=?HIDE(click, undefined, Id)}
    , InnerPanel = #panel{class="notify_inner", body=R#notify.msg}
    , Panel = #panel{id=Id
        , class=["notify ", R#notify.class]
        , body=#singlerow{ 
            cells=[#tablecell{align=left, body=InnerPanel}
                , #tablecell{align=right, body=Link}]}
    }
    , element_panel:render(Id, Panel)
.

msg(Content) ->
    wf:insert_bottom(notification_area, #notify{msg=Content})
.

msg(Content, Expire) ->
    wf:insert_bottom(notification_area, #notify{msg=Content, expire=Expire})
.
