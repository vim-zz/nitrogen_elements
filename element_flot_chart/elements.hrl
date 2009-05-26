-record(flot_chart, {?ELEMENT_BASE(element_flot_chart), width, height, title
    , minx, maxx, miny, maxy, xticks, yticks
    , modex, modey, modex2, modey2
    , minx2, maxx2, miny2, maxy2, x2ticks, y2ticks
    , values, lines=true, points=true, bar=false, selectmode="xy"
    , placeholder, legend
    , hover, click, select}).
