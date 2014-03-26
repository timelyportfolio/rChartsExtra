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

## CatCorrJS with rCharts

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

[CatCorrJS](http://deanmalmgren.github.io/catcorrjs/) is a library that combines  `d3.js` and `crossfilter.js` to make it easy to visualize relationships between categorical variables (e.g., results from a survey). This is an attempt to integrate it with rCharts.


The basic idea of the rCharts function integrating this library is to accept two csv files as inputs, one with the questions, and the other with the responses, and return an interactive visualization.

### Inputs

The [question file](https://github.com/rcharts/howitworks/blob/gh-pages/catcorrjs/data/questions.csv) consists of three columns, representing `type` of question, the `text` content of the question and semicolon separated `choices`. The [response file](https://github.com/rcharts/howitworks/blob/gh-pages/catcorrjs/data/responses.csv) is exported from Google Forms.


### Visualization

The `catCorrPlot` function reads the two csv files with questions and responses, processes the data to create a json payload that is accepted by the [CatCorrJS](http://deanmalmgren.github.io/catcorrjs/) library, and finally uses the `rCharts` base class to produce an interactive visualization.


    catCorrPlot <- function(questions_doc, responses_doc){
      require(rCharts)
      responses = read.csv(responses_doc)
      responses = toJSONArray(setNames(
         responses[,-1], 1:(NCOL(responses) - 1)
      ), json = F)
      
      questions = read.csv(questions_doc, stringsAsFactors = F)
      questions = lapply(1:NROW(questions), function(i){
        qi = as.list(questions[i,])
        qi$choices = strsplit(qi$choices, ";")[[1]]
        qi$number = i
        qi
      })
      questions = toJSONArray(questions, json = F)
      
      r1 <- rCharts$new()
      r1$setLib('http://rcharts.github.io/howitworks/catcorrjs/catcorrjs')
      r1$set(questions = questions, responses = responses)
      r1
    }
    


We can now use this function to create an interactive visualization of the survey


    r1 <- catCorrPlot("data/questions.csv", "data/responses.csv")


<iframe src='./catCorrPlot.html' seamless></iframe>

### ToDos.

As an extension, I am working on a prototype, that would simplify workflow considerably by allowing a user to author a survey in RMarkdown, automagically create a google form based on it, and view the results as a dynamic interactive visualization.


### Acknowledgements

All the heavy-lifting in creating this visualization is the work of [Dean Malmgren](http://about.me/dean.malmgren) and his awesome [CatCorrJS](http://deanmalmgren.github.io/catcorrjs/). [rCharts](http://rcharts.io) merely provides a wrapper to integrate this library into an #rstats workflow.



<div id='disqus_thread'></div>

<style>
iframe {
  height: 1300px;
}
</style>





