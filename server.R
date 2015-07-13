
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

#libs
library(shiny)
library(psych)
library(ggplot2)
library(plyr)
library(stringr)
library(reshape)

#settings
n = 10000
test_mean = 100
test_sd = 15

shinyServer(function(input, output) {
  
  reac_d = reactive({
    #replicable results
    set.seed(123)
    
    #determine noise beta
    noise_beta = sqrt(1 - input$cor^2)
    
    #data generation block
    {
    true_score = rnorm(n)
    est_score = true_score * input$cor + rnorm(n) * noise_beta
    }
    
    #rescale
    true_score = true_score * test_sd + test_mean
    est_score = est_score * test_sd + test_mean + input$up_bias
    
    #df
    d = data.frame(true_score,
                   est_score)
    
    #assign to groups
    br_points = quantile(d$true_score, probs = seq(0, 1, length = input$bins + 1))
    d$group = cut(d$true_score, breaks = br_points, include.lowest = T, labels = F)
    
    #return
    return(d)
    
  })
  
  reac_d2 = reactive({
    #fetch data
    d = reac_d()
    
    #ecdf
    f = ecdf(d$true_score)
    d$p_true_score = f(d$true_score) * 100
    d$p_est_score = f(d$est_score) * 100
    
    #mean est by group
    d2 = ddply(d, .variables = .(group), summarize,
               mean_est = mean(est_score),
               mean_true = mean(true_score),
               mean_est_p = mean(p_est_score),
               mean_true_p = mean(p_true_score))
    
    return(d2)
  })

  output$scatterplot <- renderPlot({
    #fetch data
    d = reac_d()
    d2 = reac_d2()
  
    #plot
    g = ggplot(d, aes(est_score, true_score)) +
      geom_point(alpha = .5) +
      geom_smooth(method = "lm", se = F) +
      xlab("Self-estimated score") + ylab("Actual score") +
      scale_x_continuous(breaks = seq(0, 200, 5)) +
      scale_y_continuous(breaks = seq(0, 200, 5)) +
      theme_bw()
    
    return(g)

  })
  
  output$lineplot = renderPlot({
    #fetch data
    d2 = reac_d2()
    
    #long form
    d2_long = melt(d2[1:3], id.vars = "group")
    
    #plot
    g2 = ggplot(d2_long, aes(group, value, color = variable)) +
      geom_line(size = 1) +
      scale_color_manual("Score", values = c("#f8f05d", "#7a7aff"), labels = c("Self-estimated", "True")) +
      xlab("N-tile") + ylab("Actual score, raw") +
      scale_y_continuous(breaks = seq(0, 200, 5)) +
      theme_bw()
    
    return(g2)
  })
  
  output$lineplot_centile = renderPlot({
    #fetch data
    d2 = reac_d2()
    
    #long form
    d2_long = melt(d2[c(1,4:5)], id.vars = "group")
    
    #plot
    g3 = ggplot(d2_long, aes(group, value, color = variable)) +
      geom_line(size = 1) +
      scale_color_manual("Score", values = c("#f8f05d", "#7a7aff"), labels = c("Self-estimated", "True")) +
      xlab("N-tile") + ylab("Actual score, centile") +
      scale_y_continuous(breaks = seq(0, 200, 5)) +
      theme_bw()
    
    return(g3)
  })

})
