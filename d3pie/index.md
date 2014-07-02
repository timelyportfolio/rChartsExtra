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

## d3Pie + rCharts

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



The design and visualization world generally dislikes pie charts.  However, there still exists a real demand for pie charts.  Not that I would ever use a pie chart, but I was delighted to see the announcement of this very robust d3 pie library [`d3pie`](http://d3pie.org).  It is so beautiful that it tempts me to violate my self-imposed ban on pie charts.

### Get a rChart Shell for Our Delicious Pies

Eventually I would like to build a R `refClass` for [`d3pie`](http://d3pie.org), but for now I wanted to show how we could use [`d3pie`](http://d3pie.org) in R with [`rCharts`](http://rcharts.io).  Most of this should be considered experimental as I work through how best to support the [numerous options and features](http://d3pie.org/#docs) of [`d3pie`](http://d3pie.org).


```r
dPie <- rCharts$new()
dPie$setLib("http://timelyportfolio.github.io/rChartsExtra/d3pie")
#do once to add assets with slidify
cat(add_lib_assets(dPie$lib,cdn=T))
```

<script type='text/javascript' src=http://code.jquery.com/jquery-2.1.1.min.js></script>
<script type='text/javascript' src=http://d3js.org/d3.v3.min.js></script>
<script type='text/javascript' src=http://timelyportfolio.github.io/rChartsExtra/d3pie/js/d3pie.js></script>

### Fill Our Pie

One easy way to fill our pie is to recreate the [d3pie example](http://d3pie.org/#generator-start) and even get the exact JSON from the example with `fromJSON`.  This will most likely not be the way a R user would populate the options and data of a d3pie, but seeing this method might help us better understand the rCharts binding.


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

### Violate a Design Principle of rCharts

**Please note that these examples use a big hairy nested list which violates the author of rCharts Ramnath's design principles.**  However, this requires no extra code or refClasses, so these ugly nested lists are a nice way to experiment with d3pie.  Just look at one, and you will probably quickly understand why Ramnath avoids them.


```r
cat(
  paste0(
    capture.output(
      Hmisc:::list.tree(
        dPie$params$chartspec
        ,maxlen=40
      )
    )
    ,separator="<br>"
  )
)
```

 dPie$params$chartspec = list 6 (8136 bytes)<br> .  header = list 3<br> . .  title = list 3<br> . . .  text = character 1= Lots of Programming Languages <br> . . .  fontSize = double 1= 24<br> . . .  font = character 1= open sans <br> . .  subtitle = list 4<br> . . .  text = character 1= A full pie chart to show off label colli <br> . . .  color = character 1= #999999 <br> . . .  fontSize = double 1= 12<br> . . .  font = character 1= open sans <br> . .  titleSubtitlePadding = double 1= 9<br> .  footer = list 4<br> . .  color = character 1= #999999 <br> . .  fontSize = double 1= 10<br> . .  font = character 1= open sans <br> . .  location = character 1= bottom-left <br> .  size = list 1<br> . .  canvasWidth = double 1= 590<br> .  labels = list 6<br> . .  outer = list 1<br> . . .  pieDistance = double 1= 32<br> . .  inner = list 1<br> . . .  hideWhenLessThanPercentage = double 1= 3<br> . .  mainLabel = list 1<br> . . .  fontSize = double 1= 11<br> . .  percentage = list 2<br> . . .  color = character 1= #ffffff <br> . . .  decimalPlaces = double 1= 0<br> . .  value = list 2<br> . . .  color = character 1= #adadad <br> . . .  fontSize = double 1= 11<br> . .  lines = list 1<br> . . .  enabled = logical 1= TRUE<br> .  effects = list 1<br> . .  pullOutSegmentOnClick = list 3<br> . . .  effect = character 1= linear <br> . . .  speed = double 1= 400<br> . . .  size = double 1= 8<br> .  misc = list 1<br> . .  gradient = list 2<br> . . .  enabled = logical 1= TRUE<br> . . .  percentage = double 1= 100<br>

```r
#as a simple example let's change the header title
dPie$params$chartspec$header$title = list(
  text = "d3Pie Example Recreated in R with rCharts",
  fontsize = 20,
  font = "open sans"
)
cat(
  paste0(
    capture.output(
      Hmisc:::list.tree(
        dPie$params$chartspec$header$title
        ,maxlen=40
      )
    )
    ,separator="<br>"
  )
)
```

 dPie$params$chartspec$header$title = list 3 (696 bytes)<br> .  text = character 1= d3Pie Example Recreated in R with rChart <br> .  fontsize = double 1= 20<br> .  font = character 1= open sans <br>


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
dPie$params$dom = knitr:::opts_current$get("label")
dPie$print()
```


<div id = 'example1' class = 'rChart d3pie'></div>
<script>
function drawexample1(){ 
  var params = {
 "dom": "example1",
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
"id": "example1" 
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
  
  var pie = new d3pie("#" + params.dom, params.chartspec);
  return pie;
};

var example1 = drawexample1();
</script>


```r
#now show how d3Pie responds if no color
#hard to tell but the colors are different
dPie$params$chartspec$data <- list(
    sortOrder = "value-desc",
    content = data[,-3]
)

dPie$params$dom = knitr:::opts_current$get("label")
dPie$print()
```


<div id = 'example2' class = 'rChart d3pie'></div>
<script>
function drawexample2(){ 
  var params = {
 "dom": "example2",
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
"id": "example2" 
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
  
  var pie = new d3pie("#" + params.dom, params.chartspec);
  return pie;
};

var example2 = drawexample2();
</script>


```r
#now change so that the color is calculated in R
#?topo.colors
dPie$params$chartspec$data$content <- data.frame(
    data[order(data$value,decreasing=T),-3],  #data minus the color column
    color = substr(topo.colors(nrow(data)),0,7) #our new colors using R topo.colors
)
dPie$params$dom = knitr:::opts_current$get("label")
dPie$print()
```


<div id = 'example3' class = 'rChart d3pie'></div>
<script>
function drawexample3(){ 
  var params = {
 "dom": "example3",
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
"id": "example3" 
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
  
  var pie = new d3pie("#" + params.dom, params.chartspec);
  return pie;
};

var example3 = drawexample3();
</script>


```r
#sort from d3pie is slightly different so let R sort
#since values for smalltalk = node = php
dPie$params$chartspec$data$sortOrder <- NULL
dPie$params$dom = knitr:::opts_current$get("label")
dPie$print()
```


<div id = 'example4' class = 'rChart d3pie'></div>
<script>
function drawexample4(){ 
  var params = {
 "dom": "example4",
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
"id": "example4" 
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
  
  var pie = new d3pie("#" + params.dom, params.chartspec);
  return pie;
};

var example4 = drawexample4();
</script>
