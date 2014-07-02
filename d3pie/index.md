---
title       : rCharts and d3pie
author      : TimelyPortfolio
framework   : minimal
highlighter : prettify
hitheme     : twitter-bootstrap
mode        : selfcontained
github      : {user: timelyportfolio, repo: rChartsExtra, branch: gh-pages}
assets:
  css: 
    - "http://fonts.googleapis.com/css?family=PT+Sans"
    - "../assets/css/app.css"
    - "../assets/css/gh-buttons.css"
url: {lib: ../libraries}
---

## d3Pie with rCharts

<!-- AddThis Smart Layers BEGIN -->
<!-- Go to http://www.addthis.com/get/smart-layers to customize -->
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4fdfcfd4773d48d3"></script>
<script type="text/javascript">
  addthis.layers({
    'theme' : 'transparent',
    'share' : {
      'position' : 'left',
      'numPreferredServices' : 5
    }   
  });
</script>
<!-- AddThis Smart Layers END -->




```r
require(rCharts)
options(viewer = NULL) #turn off Rstudio viewer so each example can be seen
```


```r
dPie <- rCharts$new()
dPie$setLib("http://timelyportfolio.github.io/rChartsExtra/d3pie")
#do once to add assets with slidify
add_lib_assets(dPie$lib,cdn=T)
```

[1] "<script type='text/javascript' src=http://code.jquery.com/jquery-2.1.1.min.js></script>\n<script type='text/javascript' src=http://d3js.org/d3.v3.min.js></script>\n<script type='text/javascript' src=http://timelyportfolio.github.io/rChartsExtra/d3pie/js/d3pie.js></script>"


```r
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
```


```r
#to see how we would send a configuration in R without toJSON
#which is the most likely use case
#right now a big hairy nested list
#which violates Ramnath's rCharts design principles which avoids of nested list
#but requires no extra code or refClasses
str(dPie$params$chartspec)
```

List of 6
 $ header :List of 3
  ..$ title               :List of 3
  .. ..$ text    : chr "Lots of Programming Languages"
  .. ..$ fontSize: num 24
  .. ..$ font    : chr "open sans"
  ..$ subtitle            :List of 4
  .. ..$ text    : chr "A full pie chart to show off label collision detection and resolution."
  .. ..$ color   : chr "#999999"
  .. ..$ fontSize: num 12
  .. ..$ font    : chr "open sans"
  ..$ titleSubtitlePadding: num 9
 $ footer :List of 4
  ..$ color   : chr "#999999"
  ..$ fontSize: num 10
  ..$ font    : chr "open sans"
  ..$ location: chr "bottom-left"
 $ size   :List of 1
  ..$ canvasWidth: num 590
 $ labels :List of 6
  ..$ outer     :List of 1
  .. ..$ pieDistance: num 32
  ..$ inner     :List of 1
  .. ..$ hideWhenLessThanPercentage: num 3
  ..$ mainLabel :List of 1
  .. ..$ fontSize: num 11
  ..$ percentage:List of 2
  .. ..$ color        : chr "#ffffff"
  .. ..$ decimalPlaces: num 0
  ..$ value     :List of 2
  .. ..$ color   : chr "#adadad"
  .. ..$ fontSize: num 11
  ..$ lines     :List of 1
  .. ..$ enabled: logi TRUE
 $ effects:List of 1
  ..$ pullOutSegmentOnClick:List of 3
  .. ..$ effect: chr "linear"
  .. ..$ speed : num 400
  .. ..$ size  : num 8
 $ misc   :List of 1
  ..$ gradient:List of 2
  .. ..$ enabled   : logi TRUE
  .. ..$ percentage: num 100

```r
#as a simple example let's change the header title
dPie$params$chartspec$header$title = list(
  text = "d3Pie Example Recreated in R with rCharts",
  fontsize = 20,
  font = "open sans"
)
str(dPie$params$chartspec$header$title)
```

List of 3
 $ text    : chr "d3Pie Example Recreated in R with rCharts"
 $ fontsize: num 20
 $ font    : chr "open sans"


```r
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
```


```r
#now that we have data as a data.frame which a R user should know well
#show how to specify a data.frame as our data.source
dPie$addParams(chartspec = list(
  data = list(
    sortOrder = "value-desc",
    content = data
  )
))
dPie$show("inline")
```


<div id = 'chart22ec6566577f' class = 'rChart d3pie'></div>
<script>
function drawchart22ec6566577f(){ 
  var params = {
 "dom": "chart22ec6566577f",
"width":    800,
"height":    400,
"chartspec": {
 "header": {
 "title": {
 "text": "d3Pie Example Recreated in R with rCharts",
"fontsize":     20,
"font": "open sans" 
},
"subtitle": {
 "text": "A full pie chart to show off label collision detection and resolution.",
"color": "#999999",
"fontSize":     12,
"font": "open sans" 
},
"titleSubtitlePadding":      9 
},
"footer": {
 "color": "#999999",
"fontSize":     10,
"font": "open sans",
"location": "bottom-left" 
},
"size": {
 "canvasWidth":    590 
},
"labels": {
 "outer": {
 "pieDistance":     32 
},
"inner": {
 "hideWhenLessThanPercentage":      3 
},
"mainLabel": {
 "fontSize":     11 
},
"percentage": {
 "color": "#ffffff",
"decimalPlaces":      0 
},
"value": {
 "color": "#adadad",
"fontSize":     11 
},
"lines": {
 "enabled": true 
} 
},
"effects": {
 "pullOutSegmentOnClick": {
 "effect": "linear",
"speed":    400,
"size":      8 
} 
},
"misc": {
 "gradient": {
 "enabled": true,
"percentage":    100 
} 
},
"data": {
 "sortOrder": "value-desc",
"content": {
 "label": [ "JavaScript", "Ruby", "Java", "PHP", "Python", "C+", "C", "Objective-C", "Shell", "Cobol", "C#", "Coldfusion", "Fortran", "Coffeescript", "Node", "Basic", "Cola", "Perl", "Dart", "Go", "Groovy", "Processing", "Smalltalk", "Scala", "Visual Basic", "Scheme", "Rust", "FoxPro" ],
"value": [ 2.6413e+05, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  78327,  67706,  36344,  28561,  24131,    100,     68, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  36344,  32170,  28561, 2.6413e+05, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  78327,  67706,  36344,  32170 ],
"color": [ "#2484c1", "#0c6197", "#4daa4b", "#90c469", "#daca61", "#e4a14b", "#e98125", "#cb2121", "#830909", "#923e99", "#ae83d5", "#bf273e", "#ce2aeb", "#bca44a", "#618d1b", "#1ee67b", "#b0ec44", "#a4a0c9", "#322849", "#86f71a", "#d1c87f", "#7d9058", "#44b9b0", "#7c37c0", "#cc9fb1", "#e65414", "#8b6834", "#248838" ] 
} 
} 
},
"id": "chart22ec6566577f" 
};
  
  //rCharts defaults to send toJSON as columns
  //instead of the expected records for d3pie
  //do the transform the hard way for now
  function columnsToRecords(data){
    var tempdata;
    //avoid lodash for now
    datakeys = Object.keys(data)
    tempdata = data[datakeys[1]].map(function(d,i){
      var tempobj = {}
      datakeys.forEach(function(key){
        tempobj[key] = data[key][i]
      })
      return tempobj
    })
    return tempdata;
  }
  
  params.chartspec.data.content = columnsToRecords(params.chartspec.data.content);
  
  var pie = new d3pie("#" + params.id, params.chartspec);
  return pie;
};

var chart22ec6566577f = drawchart22ec6566577f();
</script>


```r
#now show how d3Pie responds if no color
#hard to tell but the colors are different
dPie$params$chartspec$data <- list(
    sortOrder = "value-desc",
    content = data[,-3]
)

dPie$show("inline")
```


<div id = 'chart22ec6566577f' class = 'rChart d3pie'></div>
<script>
function drawchart22ec6566577f(){ 
  var params = {
 "dom": "chart22ec6566577f",
"width":    800,
"height":    400,
"chartspec": {
 "header": {
 "title": {
 "text": "d3Pie Example Recreated in R with rCharts",
"fontsize":     20,
"font": "open sans" 
},
"subtitle": {
 "text": "A full pie chart to show off label collision detection and resolution.",
"color": "#999999",
"fontSize":     12,
"font": "open sans" 
},
"titleSubtitlePadding":      9 
},
"footer": {
 "color": "#999999",
"fontSize":     10,
"font": "open sans",
"location": "bottom-left" 
},
"size": {
 "canvasWidth":    590 
},
"labels": {
 "outer": {
 "pieDistance":     32 
},
"inner": {
 "hideWhenLessThanPercentage":      3 
},
"mainLabel": {
 "fontSize":     11 
},
"percentage": {
 "color": "#ffffff",
"decimalPlaces":      0 
},
"value": {
 "color": "#adadad",
"fontSize":     11 
},
"lines": {
 "enabled": true 
} 
},
"effects": {
 "pullOutSegmentOnClick": {
 "effect": "linear",
"speed":    400,
"size":      8 
} 
},
"misc": {
 "gradient": {
 "enabled": true,
"percentage":    100 
} 
},
"data": {
 "sortOrder": "value-desc",
"content": {
 "label": [ "JavaScript", "Ruby", "Java", "PHP", "Python", "C+", "C", "Objective-C", "Shell", "Cobol", "C#", "Coldfusion", "Fortran", "Coffeescript", "Node", "Basic", "Cola", "Perl", "Dart", "Go", "Groovy", "Processing", "Smalltalk", "Scala", "Visual Basic", "Scheme", "Rust", "FoxPro" ],
"value": [ 2.6413e+05, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  78327,  67706,  36344,  28561,  24131,    100,     68, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  36344,  32170,  28561, 2.6413e+05, 2.1881e+05, 1.5762e+05, 1.1438e+05,  95002,  78327,  67706,  36344,  32170 ] 
} 
} 
},
"id": "chart22ec6566577f" 
};
  
  //rCharts defaults to send toJSON as columns
  //instead of the expected records for d3pie
  //do the transform the hard way for now
  function columnsToRecords(data){
    var tempdata;
    //avoid lodash for now
    datakeys = Object.keys(data)
    tempdata = data[datakeys[1]].map(function(d,i){
      var tempobj = {}
      datakeys.forEach(function(key){
        tempobj[key] = data[key][i]
      })
      return tempobj
    })
    return tempdata;
  }
  
  params.chartspec.data.content = columnsToRecords(params.chartspec.data.content);
  
  var pie = new d3pie("#" + params.id, params.chartspec);
  return pie;
};

var chart22ec6566577f = drawchart22ec6566577f();
</script>


```r
#now change so that the color is calculated in R
#?topo.colors
dPie$params$chartspec$data$content <- data.frame(
    data[order(data$value,decreasing=T),-3],  #data minus the color column
    color = substr(topo.colors(nrow(data)),0,7) #our new colors using R topo.colors
)
dPie$show("inline")
```


<div id = 'chart22ec6566577f' class = 'rChart d3pie'></div>
<script>
function drawchart22ec6566577f(){ 
  var params = {
 "dom": "chart22ec6566577f",
"width":    800,
"height":    400,
"chartspec": {
 "header": {
 "title": {
 "text": "d3Pie Example Recreated in R with rCharts",
"fontsize":     20,
"font": "open sans" 
},
"subtitle": {
 "text": "A full pie chart to show off label collision detection and resolution.",
"color": "#999999",
"fontSize":     12,
"font": "open sans" 
},
"titleSubtitlePadding":      9 
},
"footer": {
 "color": "#999999",
"fontSize":     10,
"font": "open sans",
"location": "bottom-left" 
},
"size": {
 "canvasWidth":    590 
},
"labels": {
 "outer": {
 "pieDistance":     32 
},
"inner": {
 "hideWhenLessThanPercentage":      3 
},
"mainLabel": {
 "fontSize":     11 
},
"percentage": {
 "color": "#ffffff",
"decimalPlaces":      0 
},
"value": {
 "color": "#adadad",
"fontSize":     11 
},
"lines": {
 "enabled": true 
} 
},
"effects": {
 "pullOutSegmentOnClick": {
 "effect": "linear",
"speed":    400,
"size":      8 
} 
},
"misc": {
 "gradient": {
 "enabled": true,
"percentage":    100 
} 
},
"data": {
 "sortOrder": "value-desc",
"content": {
 "label": [ "JavaScript", "Go", "Ruby", "Fortran", "Groovy", "Java", "Coffeescript", "Processing", "PHP", "Node", "Smalltalk", "Python", "Basic", "Scala", "C+", "Visual Basic", "C", "Scheme", "Objective-C", "Cola", "Rust", "Perl", "FoxPro", "Shell", "Dart", "Cobol", "C#", "Coldfusion" ],
"value": [ 2.6413e+05, 2.6413e+05, 2.1881e+05, 2.1881e+05, 2.1881e+05, 1.5762e+05, 1.5762e+05, 1.5762e+05, 1.1438e+05, 1.1438e+05, 1.1438e+05,  95002,  95002,  95002,  78327,  78327,  67706,  67706,  36344,  36344,  36344,  32170,  32170,  28561,  28561,  24131,    100,     68 ],
"color": [ "#4C00FF", "#2A00FF", "#0800FF", "#0019FF", "#003CFF", "#005DFF", "#0080FF", "#00A2FF", "#00C3FF", "#00E5FF", "#00FF4D", "#00FF26", "#00FF00", "#26FF00", "#4DFF00", "#73FF00", "#99FF00", "#BFFF00", "#E6FF00", "#FFFF00", "#FFF316", "#FFEA2D", "#FFE343", "#FFDE59", "#FFDB70", "#FFDB86", "#FFDC9C", "#FFE0B3" ] 
} 
} 
},
"id": "chart22ec6566577f" 
};
  
  //rCharts defaults to send toJSON as columns
  //instead of the expected records for d3pie
  //do the transform the hard way for now
  function columnsToRecords(data){
    var tempdata;
    //avoid lodash for now
    datakeys = Object.keys(data)
    tempdata = data[datakeys[1]].map(function(d,i){
      var tempobj = {}
      datakeys.forEach(function(key){
        tempobj[key] = data[key][i]
      })
      return tempobj
    })
    return tempdata;
  }
  
  params.chartspec.data.content = columnsToRecords(params.chartspec.data.content);
  
  var pie = new d3pie("#" + params.id, params.chartspec);
  return pie;
};

var chart22ec6566577f = drawchart22ec6566577f();
</script>


```r
#sort from d3pie is slightly different so let R sort
#since values for smalltalk = node = php
dPie$params$chartspec$data$sortOrder <- NULL
dPie$show("inline")
```


<div id = 'chart22ec6566577f' class = 'rChart d3pie'></div>
<script>
function drawchart22ec6566577f(){ 
  var params = {
 "dom": "chart22ec6566577f",
"width":    800,
"height":    400,
"chartspec": {
 "header": {
 "title": {
 "text": "d3Pie Example Recreated in R with rCharts",
"fontsize":     20,
"font": "open sans" 
},
"subtitle": {
 "text": "A full pie chart to show off label collision detection and resolution.",
"color": "#999999",
"fontSize":     12,
"font": "open sans" 
},
"titleSubtitlePadding":      9 
},
"footer": {
 "color": "#999999",
"fontSize":     10,
"font": "open sans",
"location": "bottom-left" 
},
"size": {
 "canvasWidth":    590 
},
"labels": {
 "outer": {
 "pieDistance":     32 
},
"inner": {
 "hideWhenLessThanPercentage":      3 
},
"mainLabel": {
 "fontSize":     11 
},
"percentage": {
 "color": "#ffffff",
"decimalPlaces":      0 
},
"value": {
 "color": "#adadad",
"fontSize":     11 
},
"lines": {
 "enabled": true 
} 
},
"effects": {
 "pullOutSegmentOnClick": {
 "effect": "linear",
"speed":    400,
"size":      8 
} 
},
"misc": {
 "gradient": {
 "enabled": true,
"percentage":    100 
} 
},
"data": {
 "content": {
 "label": [ "JavaScript", "Go", "Ruby", "Fortran", "Groovy", "Java", "Coffeescript", "Processing", "PHP", "Node", "Smalltalk", "Python", "Basic", "Scala", "C+", "Visual Basic", "C", "Scheme", "Objective-C", "Cola", "Rust", "Perl", "FoxPro", "Shell", "Dart", "Cobol", "C#", "Coldfusion" ],
"value": [ 2.6413e+05, 2.6413e+05, 2.1881e+05, 2.1881e+05, 2.1881e+05, 1.5762e+05, 1.5762e+05, 1.5762e+05, 1.1438e+05, 1.1438e+05, 1.1438e+05,  95002,  95002,  95002,  78327,  78327,  67706,  67706,  36344,  36344,  36344,  32170,  32170,  28561,  28561,  24131,    100,     68 ],
"color": [ "#4C00FF", "#2A00FF", "#0800FF", "#0019FF", "#003CFF", "#005DFF", "#0080FF", "#00A2FF", "#00C3FF", "#00E5FF", "#00FF4D", "#00FF26", "#00FF00", "#26FF00", "#4DFF00", "#73FF00", "#99FF00", "#BFFF00", "#E6FF00", "#FFFF00", "#FFF316", "#FFEA2D", "#FFE343", "#FFDE59", "#FFDB70", "#FFDB86", "#FFDC9C", "#FFE0B3" ] 
} 
} 
},
"id": "chart22ec6566577f" 
};
  
  //rCharts defaults to send toJSON as columns
  //instead of the expected records for d3pie
  //do the transform the hard way for now
  function columnsToRecords(data){
    var tempdata;
    //avoid lodash for now
    datakeys = Object.keys(data)
    tempdata = data[datakeys[1]].map(function(d,i){
      var tempobj = {}
      datakeys.forEach(function(key){
        tempobj[key] = data[key][i]
      })
      return tempobj
    })
    return tempdata;
  }
  
  params.chartspec.data.content = columnsToRecords(params.chartspec.data.content);
  
  var pie = new d3pie("#" + params.id, params.chartspec);
  return pie;
};

var chart22ec6566577f = drawchart22ec6566577f();
</script>
