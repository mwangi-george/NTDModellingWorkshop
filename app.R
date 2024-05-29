library(shiny)
library(deSolve)
library(tidyverse)
library(highcharter)
library(bs4Dash)
library(waiter)
library(thematic)
# Load parameters from 'par.R'
source("par.R")
source("funcs.R")


# Define UI
# ui <- fluidPage(
#   titlePanel("Schistosomiasis Model Simulation"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("init", "Initial Worm Burden:", 1, min = 0.1, step = 0.1),
#       numericInput("dotx", "Toggle Treatments (0=off, 1=on):", 0, min = 0, max = 1),
#       numericInput("stop.t", "Simulation Stop Time (years):", 10, min = 1),
#       numericInput("start.tx", "Treatment Start Time (years):", 1, min = 0),
#       numericInput("n.tx", "Number of Treatments:", 5, min = 1),
#       numericInput("freq.tx", "Frequency of Treatments (years):", 1, min = 0.1, step = 0.1),
#       numericInput("coverage", "Treatment Coverage:", 0.5, min = 0, max = 1, step = 0.1),
#       numericInput("efficacy", "Treatment Efficacy:", 0.94, min = 0, max = 1, step = 0.01),
#       actionButton("run", "Run Simulation")
#     ),
#     mainPanel(
#       plotOutput("plotW"),
#       highchartOutput("plotE"),
#       plotOutput("plotP"),
#       plotOutput("plotRe")
#     )
#   )
# )

source("ui_components.R")
ui <- dashboardPage(
  # preloader = list(html = tagList(spin_1(), "Getting data, please wait..."), color = "navy"),
  header = header,
  sidebar = sidebar,
  controlbar = controlbar,
  body = body,
  # footer = footer,
  skin = "light",
  dark = FALSE,
  help = TRUE,
  fullscreen = TRUE,
  scrollToTop = TRUE
)

# Define server logic
server <- function(input, output) {
  observeEvent(input$run, {
    par["dotx"] <- input$dotx
    par["stop.t"] <- input$stop.t
    par["start.tx"] <- input$start.tx
    par["n.tx"] <- input$n.tx
    par["freq.tx"] <- input$freq.tx
    par["coverage"] <- input$coverage
    par["efficacy"] <- input$efficacy
    
    equib <- runmod(init = input$init, par = par)
    
    output$plotW <- renderPlot({
      ggplot(equib, aes(x = time, y = W)) +
        geom_line() +
        labs(title = "Worm Burden Over Time", x = "Time (years)", y = "Worm Burden") +
        theme_minimal()
    })
    
    # output$plotE <- renderPlot({
    #   ggplot(equib, aes(x = time, y = E)) +
    #     geom_line() +
    #     labs(title = "Egg Output Over Time", x = "Time (years)", y = "Egg Output") +
    #     theme_minimal()
    # })
    
    
    output$plotE <- renderHighchart({
      equib %>% 
        hchart(
          type = "line", 
          hcaes(x = time, y = round(E, 4)),
          name = "E",
          showInLegend = FALSE,
          dataLabels = list(enabled = FALSE, format = "{point.y}")
          ) %>% 
        hc_title(
          text = "Egg Output Over Time",
          align = "left", style = list(fontweight = "bold", fontsize = "17px")
        ) %>% 
        hc_exporting(enabled = TRUE) %>%
        hc_tooltip(
          crosshairs = TRUE,
          backgroundColor = "lightsalmon",
          shared = T, borderWidth = 0
        ) %>%
        # hc_legend(title = list(text = "Click to hide method"))  %>%
        hc_subtitle(
          text = str_c("Showing data for", sep = " "), align = "left",
          style = list(fontweight = "bold", fontsize = "15px")
        ) %>%
        hc_caption(
          text = "Made with Highcharts", align = "left"
        ) %>%
        hc_add_theme(hc_theme_538()) %>%
        hc_chart(zoomType = "x") %>%
        hc_xAxis(title = list(text = "Date")) %>%
        hc_yAxis(title = list(text = "E"), labels = list(enabled = TRUE)) %>%
        hc_legend(align = "center", verticalAlign = "bottom", layout = "horizontal") %>%
        # hc_rangeSelector(enabled = TRUE, selected = 6, verticalAlign = "bottom") %>%
        hc_plotOptions(series = list(lineWidth = input$graph_line_width))
      
    })
    
    output$plotP <- renderPlot({
      ggplot(equib, aes(x = time, y = p)) +
        geom_line() +
        labs(title = "Prevalence Over Time", x = "Time (years)", y = "Prevalence") +
        theme_minimal()
    })
    
    output$plotRe <- renderPlot({
      ggplot(equib, aes(x = time, y = Re)) +
        geom_line() +
        labs(title = "Effective Reproduction Number Over Time", x = "Time (years)", y = "Effective Reproduction Number") +
        theme_minimal()
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
