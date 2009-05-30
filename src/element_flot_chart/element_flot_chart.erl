-module(element_flot_chart).
-compile(export_all).

-include_lib("nitrogen/include/wf.inc").
-include("elements.hrl").

reflect() -> record_info(fields, flot_chart).

rec() -> #flot_chart{}.

render(ControlId, Record) ->
    %% handle multiple datasets
    Data = Record#flot_chart.values
    , DataSet = data_as_js(Data)
    %% description of the graph
    , _Title = Record#flot_chart.title
    , Width = Record#flot_chart.width
    , Height = Record#flot_chart.height
    % TODO(jwall): dual axis support
    , Lines = Record#flot_chart.lines
    , Points = Record#flot_chart.points
    , Bar = Record#flot_chart.bar
    , SelectMode = Record#flot_chart.selectmode
    %% IDs for the elements
    , TargetId = case Record#flot_chart.placeholder of
        undefined ->
            wf:temp_id();
        PlaceHolder ->
            PlaceHolder
    end
    , PlotId = case Record#flot_chart.id of
        undefined ->
            wf:temp_id();
        Id ->
            Id
    end
    , LegendId = case Record#flot_chart.legend of
        undefined ->
            wf:temp_id();
        Legend ->
            Legend
    end
    , GraphId = wf:temp_id()
    , ToolTipId = wf:temp_id()
    %% TODO(jwall): support date formatting for timeseries data
    %% TODO(jwall): colors
    , Script = wf:f("var " ++ PlotId ++ ";"
        ++ "$(function() { ~n"
        ++ "var d = ~s;~n" % DataSet
        ++ PlotId ++ " = $.plot($('#' + ~p), d, ~n{" % TargetId
        ++ xaxis(Record) ++ ",~n" 
        ++ yaxis(Record) ++ ",~n"
        ++ x2axis(Record) ++ ",~n" 
        ++ y2axis(Record) ++ ",~n"
        % insert optional y2axis here
        ++ "lines: {show: ~p},~n" % Lines
        ++ "points: {show: ~p},~n" % Points
        ++ "bars: {show: ~p},~n" % Bar
        ++ "selection: {mode: ~p},~n" % SelectMode
        ++ "grid: {hoverable: true, clickable: true},~n"
        %% Legend
        ++ "legend: { container: $('#' + ~p) } " % LegendId
        ++ "});~n"
        %% tooltip code
        ++ "function showTooltip(x, y, contents) {~n"
        ++ " $('<div id=~p>' + contents + '</div>').css( {~n" % ToolTipId
        ++ "     position: 'absolute',~n"
        ++ "     display: 'none',~n"
        ++ "     top: y + 5,~n"
        ++ "     left: x + 5,~n"
        ++ "     border: '1px solid #fdd',~n"
        ++ "     padding: '2px',~n"
        ++ "     'background-color': '#fee',~n"
        ++ "     opacity: 0.80~n"
        ++ " }).appendTo('body').fadeIn(200);~n"
        ++ "}~n"
        % now bind to the plothover event
        ++ "var previousPoint = null;~n"
        ++ "$('#' + ~p).bind('plothover', function(event, pos, item) {~n" % TargetId
        ++ " $('#x').text(pos.x.toFixed(2));~n"
        ++ " $('#y').text(pos.y.toFixed(2));~n"
        ++ " if (item) {~n"
        ++ "  if(previousPoint != item.datapoint) {~n"
        ++ "   previousPoint = item.datapoint;~n"
        ++ "   $('#' + ~p).remove();~n" % ToolTipId
        ++ "   var x = item.datapoint[0].toFixed(2),~n"
        ++ "       y = item.datapoint[1].toFixed(2);~n"
        ++ "   showTooltip(item.pageX, item.pageY, y);~n"
        ++ "  } else {~n"
        ++ "   $('#' + ~p).remove();~n" % ToolTipId
        ++ "   previousPoint = null;~n"
        ++ "  }~n"
        ++ " }~n"
        ++ "})~n"
        %% TODO(jwall): select event custom?
        ++ "$('#' + ~p).bind('plotselected', function (event, ranges) {~n" % TargetId
        ++ " //alert(ranges.xaxis.from.toFixed(1) + ',' + ranges.yaxis.from.toFixed(1))~n"
        ++ " //alert(ranges.xaxis.to.toFixed(1) + ',' + ranges.yaxis.to.toFixed(1))~n"
        ++ "})~n"
        %% TODO(jwall): click event custom?
        ++ "$('#' + ~p).bind('plotclick', function (event, pos, item) {~n" % TargetId
        ++ " //alert(item.dataIndex + ' = ' + d[item.dataIndex]);~n"
        ++ "})~n"
        ++ "});~n"
        , [DataSet, TargetId
            , Lines, Points, Bar, SelectMode, LegendId
            , ToolTipId, TargetId, ToolTipId, ToolTipId
            , TargetId, TargetId
        ])
    %% TODO(jwall): dataset manipulation
    %% TODO(jwall): zoom controls?
    %% TODO(jwall): pan buttons?
    , LegendPanel = #panel{id=LegendId}
    , Panel = #panel{id=TargetId, style=wf:f("width:~ppx;height:~ppx", [Width, Height])}
    , wf:wire(TargetId, #event{type='timer', delay=10
        , actions=#script{script=Script}})
    , element_singlerow:render(ControlId, #singlerow{id=GraphId, cells=[#tablecell{body=Panel}
        , #tablecell{body=LegendPanel}]})
.

data_as_js(T) when is_tuple(T) ->
    data_as_js([T]);
data_as_js(L) ->
    List = data_as_js_preparse(L)
    , "[" ++ string:join(List, ",") ++ "]"
.

data_as_js_preparse([]) ->
    [];
data_as_js_preparse([H | T]) when is_tuple(H) ->
   [ data_as_js_preparse(H) | data_as_js_preparse(T)];
data_as_js_preparse([H | T]) when is_list(H) ->
   [ data_as_js_preparse({"undefined", H}) | data_as_js_preparse(T)];
data_as_js_preparse({Label, Data}) when is_list(Data) ->
    wf:f("{ label: '~s', data: ~w}", [Label, Data]);
data_as_js_preparse({Label, Data, Opts}) 
    when is_list(Data) and is_list(Opts) ->
        OptString = create_options(Opts)
        , wf:f("{ label: '~s', data: ~w, ~s}", [Label, Data, OptString]);
data_as_js_preparse({Label, Data, {Axis, Num}}) 
    when is_list(Data) and is_atom(Axis) and is_integer(Num) ->
        wf:f("{ label: '~s', data: ~w, ~p: ~p}", [Label, Data, Axis, Num])
.

xaxis(Record) ->
    Min = Record#flot_chart.minx
    , Max = Record#flot_chart.maxx
    , Mode = Record#flot_chart.modex
    , Ticks = Record#flot_chart.xticks
    , create_option(xaxis, [opt(min, Min)
        , opt(max, Max), opt(ticks, Ticks)
        , opt(mode, Mode)])
.

yaxis(Record) ->
    Min = Record#flot_chart.miny
    , Max = Record#flot_chart.maxy
    , Mode = Record#flot_chart.modey
    , Ticks = Record#flot_chart.yticks
    , create_option(yaxis, [opt(min, Min)
        , opt(max, Max), opt(ticks, Ticks)
        , opt(mode, Mode)])
.

x2axis(Record) ->
    Min = Record#flot_chart.minx2
    , Max = Record#flot_chart.maxx2
    , Mode = Record#flot_chart.modex2
    , Ticks = Record#flot_chart.x2ticks
    , create_option(x2axis, [opt(min, Min)
        , opt(max, Max), opt(ticks, Ticks)
        , opt(mode, Mode)])
.

y2axis(Record) ->
    Min = Record#flot_chart.miny2
    , Max = Record#flot_chart.maxy2
    , Mode = Record#flot_chart.modey2
    , Ticks = Record#flot_chart.y2ticks
    , create_option(y2axis, [opt(min, Min)
        , opt(max, Max), opt(ticks, Ticks)
        , opt(mode, Mode)])
.

create_options(L) when is_list(L) ->
    lists:join(create_options_from_list(L), ",")
.

create_options_from_list([{Name, Items} | T]) ->
    [create_option(Name, Items) | create_options(T)]
.

create_option(Name, Items) when is_list(Items) ->
    Opts = string:join(create_opts(Items), ",")
    , lists:flatten([wf:f("~p: {~n", [Name])
     , Opts, "}~n"])
.

opt(Type, Value) ->
    {Type, Value}
.

create_opts([]) ->
    "";
create_opts([H |T]) ->
    [create_opt(H) | create_opts(T)]
.

create_opt({Type, undefined}) ->
    wf:f("~p: null", [Type]);
create_opt({mode, Value}) when Value == "time" ->
    wf:f("mode: ~p", [Value]);
create_opt({show, Value}) when is_boolean(Value)  ->
    wf:f("show: ~p", [Value]);
create_opt({min, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("min: ~p", [Value]);
create_opt({max, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("max: ~p", [Value]);
create_opt({autoscale, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("autoscaleWidth: ~p", [Value]);
create_opt({labelwidth, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("labelWidth: ~p", [Value]);
create_opt({labelheight, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("LabelHeight: ~p", [Value]);
create_opt({ticks, Value}) when is_integer(Value) or is_list(Value) ->
    wf:f("ticks: ~p", [Value]);
create_opt({ticksize, Value}) when is_integer(Value) or is_float(Value) ->
    wf:f("tickSize: ~p", [Value]);
create_opt({tickformatter, Value}) when is_list(Value) ->
    wf:f("tickFormatter: ~p", [Value]);
create_opt({tickdecimals, Value}) when is_integer(Value) ->
    wf:f("tickDecimals: ~p", [Value])
.

generate_ticks([[]]) ->
    [];
generate_ticks([H | T]) ->
    [generate_tick(0, H) | generate_ticks(1, T)]
.

generate_ticks(_, []) ->
    [];
generate_ticks(N, [H | T]) ->
    [generate_tick(N, H) | generate_ticks(N+1, T)]
.

generate_tick(N, Tick) ->
    [N, Tick]
.


