ig.doCeny = ->
  container = d3.select ig.containers.base
  data = d3.csv.parse ig.data.ceny, (row) ->
    row.benzin = parseFloat row.benzin
    row.diesel = parseFloat row.diesel
    [y,m,d] = row.datum.split '-' .map parseInt _, 10
    row.date = new Date!
      ..setTime 0
      ..setFullYear y
      ..setMonth m - 1
      ..setDate d
    row

  width = 610
  height = 600
  margin = top:0 right:19 bottom:20 left:50

  svg = container.append \svg
    ..attr \class \ceny
    ..attr \width width
    ..attr \height height

  width -= margin.left + margin.right
  height -= margin.top + margin.bottom

  drawing = svg.append \g
    ..attr \transform "translate(#{margin.left},#{margin.top})"

  xScale = d3.time.scale!
    ..domain [data.0.date, data[*-1].date]
    ..range [-1 width]
  yScale = d3.scale.linear!
    ..domain [22 39]
    ..range [height, 0]

  dieselLine = d3.svg.line!
    ..x -> xScale it.date
    ..y -> yScale it.diesel

  benzinLine = d3.svg.line!
    ..x -> xScale it.date
    ..y -> yScale it.benzin

  dieselPath = drawing.append \path .datum data
    ..attr \class "line diesel"
    ..attr \d dieselLine

  benzinPath = drawing.append \path .datum data
    ..attr \class "line benzin"
    ..attr \d benzinLine

  xAxis = d3.svg.axis!
    ..scale xScale
    ..orient \bottom
    ..tickSize 6, 1
    ..tickValues [2005 to 2015].map ->
      new Date!
        ..setTime 0
        ..setFullYear it
    ..tickFormat -> it.getFullYear!
  svg.append \g
    ..attr \class "axis x"
    ..attr \transform "translate(#{margin.left}, #{margin.top + height})"
    ..call xAxis

  yAxis = d3.svg.axis!
    ..scale yScale
    ..orient \left
    ..tickFormat -> it + " Kč"
    ..tickSize 6, 1
  svg.append \g
    ..attr \class "axis y"
    ..attr \transform "translate(#{margin.left}, #{margin.top})"
    ..call yAxis
