
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("The Dunning-Kruger effect"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 2,
                  max = 10,
                  value = 4),
      sliderInput("up_bias",
                  "General overestimation:",
                  min = -30,
                  max = 30,
                  value = 7.5,
                  step = .5),
      sliderInput("cor",
                  "Correlation of self-estimated score and true score:",
                  min = -1,
                  max = 1,
                  value = .3,
                  step = .05)
    ),
    

    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p><a href='https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect'>The Dunning-Kruger effect</a> is the name of the phenomenon that persons low in a skill at some task tend to greatly overestimate their own skill level, while those actually high in the skill tend to underestimate themselves. <a href='http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2702783/'>This has been repeatedly found empirically</a>. In this visualization, we will see that the phenomenon is fairly easily explained as being due to two things: 1) a general overestimation of one's own skill (performance, ability, etc.) and 2) a positive, but imperfect correlation between self-estimated skill and actual skill.</p>",
           "<p>In the first tab, you see a scatter plot of self-estimated ability on an IQ type test (mean = 100, sd = 15) and the actual score of each person. Notice that there is a medium-sized, positive relationship of r = .3 similar to those found in actual studies (<a href='http://scottbarrykaufman.com/wp-content/uploads/2012/01/How-Smart-Do-You-Think-You-Are.pdf'>.33 in this meta-analysis</a>). Note also that there is a general overestimation, by default 7.5 points, which is a .5 d. You can control how adept persons are at self-estimation and their general overestimation using the sliders to the left.</p>",
           "<p>In the second tab, you see the same data, but now it has been cut into groups. If you left the sliders at their default values, then you now see something that looks like the typical <a href='Dunning_Kruger.jpg'>Dunning-Kruger pattern</a>. The third tab shows the bar plot with centile values instead of raw scores.</p>"),
      tabsetPanel(
        tabPanel("Scatter plot",
          plotOutput("scatterplot")
        ),
        tabPanel("Bar plot",
          plotOutput("barplot")
        ),
        tabPanel("Bar plot /w centiles",
                 plotOutput("barplot_centile")
                 )
      ),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/Dunning_Kruger'>Github</a>.")
    )
  )
))
