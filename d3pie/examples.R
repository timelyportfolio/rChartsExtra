require(rCharts)
options(viewer = NULL) #turn off Rstudio viewer so each example can be seen

dPie <- rCharts$new()
dPie$setLib(".")
#copied from the d3pie example

dPie$addParams(chartspec = rjson::fromJSON('{  
"header": {
  "title": {
    "text": "Lots of Programming Languages",
    "fontSize": 24,
    "font": "open sans"
  },
  "subtitle": {
    "text": "A full pie chart to show off label collision detection and resolution.",
    "color": "#999999",
    "fontSize": 12,
    "font": "open sans"
  },
  "titleSubtitlePadding": 9
},
"footer": {
  "color": "#999999",
  "fontSize": 10,
  "font": "open sans",
  "location": "bottom-left"
},
"size": {
  "canvasWidth": 590
},
"labels": {
  "outer": {
    "pieDistance": 32
  },
  "inner": {
    "hideWhenLessThanPercentage": 3
  },
  "mainLabel": {
    "fontSize": 11
  },
  "percentage": {
    "color": "#ffffff",
    "decimalPlaces": 0
  },
  "value": {
    "color": "#adadad",
    "fontSize": 11
  },
  "lines": {
    "enabled": true
  }
},
"effects": {
  "pullOutSegmentOnClick": {
    "effect": "linear",
    "speed": 400,
    "size": 8
  }
},
"misc": {
  "gradient": {
    "enabled": true,
    "percentage": 100
  }
}
}'
))

#to see how we would send a configuration in R without toJSON
#which is the most likely use case
#right now a big hairy nested list
#which violates Ramnath's rCharts avoidance of nested list
#but requires no extra code or refClasses
str(dPie$params$chartspec)
#as a simple example let's change the header title
dPie$params$chartspec$header$title = list(
  text = "d3Pie Example Recreated in R with rCharts",
  fontsize = 20,
  font = "open sans"
)
str(dPie$params$chartspec$header$title)

#make the data content list a data.frame and try it out
#data.frame will be the most likely data source
#use rCharts to_json to convert data.frame into expected d3pie format
#if desired and probable in future, build a refClass for d3pie
#to_json(dPie$params$chartspec$data$content,orient="records")
data <- do.call(
  rbind,
  lapply(
    rjson::fromJSON('[
{
  "label": "JavaScript",
  "value": 264131,
  "color": "#2484c1"
},
{
  "label": "Ruby",
  "value": 218812,
  "color": "#0c6197"
},
{
  "label": "Java",
  "value": 157618,
  "color": "#4daa4b"
},
{
  "label": "PHP",
  "value": 114384,
  "color": "#90c469"
},
{
  "label": "Python",
  "value": 95002,
  "color": "#daca61"
},
{
  "label": "C+",
  "value": 78327,
  "color": "#e4a14b"
},
{
  "label": "C",
  "value": 67706,
  "color": "#e98125"
},
{
  "label": "Objective-C",
  "value": 36344,
  "color": "#cb2121"
},
{
  "label": "Shell",
  "value": 28561,
  "color": "#830909"
},
{
  "label": "Cobol",
  "value": 24131,
  "color": "#923e99"
},
{
  "label": "C#",
  "value": 100,
  "color": "#ae83d5"
},
{
  "label": "Coldfusion",
  "value": 68,
  "color": "#bf273e"
},
{
  "label": "Fortran",
  "value": 218812,
  "color": "#ce2aeb"
},
{
  "label": "Coffeescript",
  "value": 157618,
  "color": "#bca44a"
},
{
  "label": "Node",
  "value": 114384,
  "color": "#618d1b"
},
{
  "label": "Basic",
  "value": 95002,
  "color": "#1ee67b"
},
{
  "label": "Cola",
  "value": 36344,
  "color": "#b0ec44"
},
{
  "label": "Perl",
  "value": 32170,
  "color": "#a4a0c9"
},
{
  "label": "Dart",
  "value": 28561,
  "color": "#322849"
},
{
  "label": "Go",
  "value": 264131,
  "color": "#86f71a"
},
{
  "label": "Groovy",
  "value": 218812,
  "color": "#d1c87f"
},
{
  "label": "Processing",
  "value": 157618,
  "color": "#7d9058"
},
{
  "label": "Smalltalk",
  "value": 114384,
  "color": "#44b9b0"
},
{
  "label": "Scala",
  "value": 95002,
  "color": "#7c37c0"
},
{
  "label": "Visual Basic",
  "value": 78327,
  "color": "#cc9fb1"
},
{
  "label": "Scheme",
  "value": 67706,
  "color": "#e65414"
},
{
  "label": "Rust",
  "value": 36344,
  "color": "#8b6834"
},
{
  "label": "FoxPro",
  "value": 32170,
  "color": "#248838"
}
]'),
    data.frame
  )
)

#now that we have data as a data.frame which a R user should know well
#show how to specify a data.frame as our data.source
dPie$addParams(chartspec = list(
  data = list(
    sortOrder = "value-desc",
    content = data
  )
))
dPie

#now show how d3Pie responds if no color
#hard to tell but the colors are different
dPie$params$chartspec$data <- list(
    sortOrder = "value-desc",
    content = data[,-3]
  )
)
dPie

#now change so that the color is calculated in R
#?topo.colors
dPie$params$chartspec$data$content <- data.frame(
    data[order(data$value,decreasing=T),-3],  #data minus the color column
    color = substr(topo.colors(nrow(data)),0,7) #our new colors using R topo.colors
)
dPie

#sort from d3pie is slightly different so let R sort
#since values for smalltalk = node = php
dPie$params$chartspec$data$sortOrder <- NULL
dPie

