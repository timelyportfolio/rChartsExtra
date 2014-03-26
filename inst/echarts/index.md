---
title       : rCharts
author      : Ramnath Vaidyanathan
framework   : minimal
highlighter : prettify
hitheme     : twitter-bootstrap
mode        : selfcontained
github      : {user: rcharts, repo: howitworks, branch: gh-pages}
widgets     : [disqus, ganalytics]
assets:
  css: 
    - "http://fonts.googleapis.com/css?family=PT+Sans"
    - "../assets/css/app.css"
    - "../assets/css/gh-buttons.css"
url: {lib: ../libraries}
---

## eCharts with rCharts

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

[rCharts](http://rcharts.io) aspires to be a meta-framework, that allows users to plug in arbitrary javascript visualization libraries with minimal effort. The main advantage of integrating with rCharts is the standardized plotting interface and accompanying support functions that allow charts to be published as standalone charts or as a part of an interactive document or web application.

Recently, I came to know about [echarts](http://ecomfe.github.io/echarts/), an interesting visualization library with an extensive set of features built by [Lin Feng](https://github.com/kener) at [baidu](http://www.baidu.com). Now, the documentation of [echarts](http://ecomfe.github.io/echarts/) is in Chinese, but fortunately Google Translate does a pretty good job of translating it into English.

I thought it would be interesting for me to share with you, how I went about the task of integrating [echarts](http://ecomfe.github.io/echarts/).

### Getting Started

The first step is to understand the structure of the html based on an example. I found an excellent example as seen [here](echarts/index.html). As discussed in my [post](http://rcharts.io/howitworks), I went about creating a folder structure for echarts.

```
echarts
  config.yml
  js
    echarts-map.js
    echarts.js
    esl.js
  layouts
    chart.html
```

I copied the [example code](echarts/index.html) to [chart.html](http://github.com/rcharts/howitworks/blob/gh-pages/echarts/echarts/layouts/chart.html) and stripped the layout off all the data, which will be provided by R.
    

### Data

One of the main reasons it is hard working with different javascript visualization libraries is because they all seem to choose different data structures for the chart payload. Standardizing some aspects of the data structure can go a long way in providing a unified interface for chart specification. 

Since rCharts already has a standardized interface for specifying a chart, we need to translate it to the data structure used by echarts. Shown below is a simple `ePlot` function that does the grunt work in translating the data, and creating a simple chart.




```r
ePlot <- function(x, y, data, group, type, colors, ...){
  require(rCharts); require(plyr)
  if (!missing(group)){
    series = setNames(dlply(data, group, function(d){
      list(
        name = d[[group]][1],
        type = type,
        data = d[[y]],
        ...
      )
    }), NULL) 
  }
  xAxis = list(
    type = 'category',
    data = unique(data[[x]])
  )
  legend = list(
    data = unique(data[[group]])
  )
  if (!missing(colors)){
    series = lapply(seq_along(series), function(i){
       series[[i]]$itemStyle = list(normal = list(color = colors[i]))
       return(series[[i]])
    })
  }

  r1 <- rCharts$new()
  r1$setLib('echarts')
  r1$set(series = series, xAxis = xAxis, legend = legend)
  r1
}
```



### Demo

Now that we have a plotting function in place, we can experiment with creating different types of charts. In order to run this code, you will need to download this repository and navigate to the `echarts` folder so that the `setLib` method in `ePlot` points to the correct location of the library files.

#### Line Chart

Let us start with a simple line chart, using the `USPersonalExpenditure` dataset.


```r
library(reshape2); library(knitr); library(rCharts)
options(RCHART_WIDTH = 575, RCHART_HEIGHT = 400)
usp <- setNames(melt(USPersonalExpenditure), c('category', 'year', 'exp'))
r1 <- ePlot('year', 'exp', data = usp, group = 'category', type = 'line')
r1$save('line_chart.html', static = F)
```


<iframe src='line_chart.html' seamless></iframe>

#### Area Chart

We can draw an area chart by passing some extra arguments to the line chart plot.


```r
r2 <- ePlot('year', 'exp', data = usp, group = 'category', 
  type = 'line', smooth = TRUE, 
  itemStyle = list(normal = list(areaStyle = list(type = 'default')))
)

r2$save('area_chart.html', static = F)
```


<iframe src='area_chart.html' seamless></iframe>


#### Bar Chart

Let us now draw a bar chart. We will turn on some cool features in echarts using the `set` method.


```r
hair_eye_male = subset(as.data.frame(HairEyeColor), Sex == "Male")
r3 <- ePlot('Hair', 'Freq', data = hair_eye_male, group = 'Eye', 
  type = 'bar', colors = c('brown', 'blue', 'yellow', 'green'))
r3$set(tooltip = list(trigger = 'axis'))
r3$set(toolbox = list(
  show = TRUE, 
  feature = list(
    mark = TRUE,
    saveAsImage = TRUE
  ))
)
r3$save('bar_chart.html', static = F)
```


<iframe src='bar_chart.html' seamless></iframe>

#### Candlestick Chart

We can draw a candlestick chart using `echarts`. Let us first fetch the data required using the `quantmod` package


```r
library(quantmod)
getSymbols("GS")
x = candleChart(GS,multi.col=TRUE,theme='white', plot = F) 
data_ = as.matrix(x@xdata)
```


We can now draw a candlestick chart


```r
require(rCharts)
r1 <- rCharts$new()
r1$setLib('echarts')
r1$set(series = list(list(
  name = 'GS',
  data = toJSONArray2(data_[,1:4], names = F, json = F),
  type = 'k'
)))
r1$set(xAxis = list(list(
 type  = 'category',
 data = gsub("-", "/", rownames(data_))
)))
r1$set(yAxis = list(list(
  type = 'value',
  scale = TRUE
)))
r1$set(tooltip = list(
  trigger = 'axis'  
))
r1$set(dataZoom = list(
  show = TRUE,
  realtime = TRUE,
  start = 0,
  end = 50 
))
r1
r1$save('candlestick_chart.html', static = F)
```


<iframe src='candlestick_chart.html' seamless height=500 style='margin-bottom:60px;'></iframe>



### Next Steps

[echarts](http://ecomfe.github.io/echarts/) supports a really extensive feature set and needs further exploration. There are some differences in the data structure for some charts, and that would mean writing more transformation functions to ensure that the end-user does not require to be aware of these idiosyncracies. 

### Acknowledgements

I would like to thank [Lin Feng](https://github.com/kener) for creating a brilliant visualization library. I would also like to acknowledge [Taiyun](https://github.com/taiyun) and his implementation of [echarts](https://github.com/taiyun/recharts). 

<div id='disqus_thread'></div>

<style>
iframe {
  height: 400px;
  width: 600px;
}
</style>





