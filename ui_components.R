
# Header definition
header <- dashboardHeader(
  disable = FALSE,
  status = "navy",
  fixed = FALSE,
  skin = "navy",
  a(
    "Schistosomiasis Model Simulation",
    href = "https://hiskenya.org/",
    target = "_blank",
    style = "color: #dc3545;"
  ) %>% h3() %>% div(),
  title = dashboardBrand(
    title = strong("Simulation Model") %>% h4(style = "font-size: 16px; color: #dc3545;"),
    color = "navy",
    opacity = 1
  )
)

sidebar <- dashboardSidebar(
  
  fixed = TRUE,
  skin = "light",
  status = "danger",
  id = "sidebar",
  width = 300,
  collapsed = FALSE,
  sidebarUserPanel(
    image = "https://adminlte.io/themes/v3/dist/img/AdminLTELogo.png",
    name = "Welcome Onboard!"
  ),
  sidebarMenu(
    id = "sidabar",
    flat = FALSE,
    compact = FALSE,
    childIndent = TRUE,
    menuItem("Home", tabName = "plots", icon = icon("chart-line"))
    
  )
  
)

controlbar <- dashboardControlbar(
  id = "controlbar",
  skin = "light",
  pinned = FALSE,
  overlay = TRUE,
  controlbarMenu(
    id = "controlbarMenu",
    type = "tabs",
    controlbarItem(
      "Inputs",
      # inputs goes here
      sliderInput("graph_line_width", "Toggle Line Width", min = 1, max = 7, value = 2, step = 1, width = "100%")
    ),
    controlbarItem(
      "Skin",
      skinSelector()
    )
  )
)

# Body tabs
plots_tab <- tabItem(
  tabName = "plots",
  fluidRow(
    box(
      title = "Filters",
      width = 3,
      height = 900,
      maximizable = TRUE,
      solidHeader = TRUE,
      status = "danger",
      numericInput("init", "Initial Worm Burden:", 1, min = 0.1, step = 0.1),
      numericInput("dotx", "Toggle Treatments (0=off, 1=on):", 0, min = 0, max = 1),
      numericInput("stop.t", "Simulation Stop Time (years):", 10, min = 1),
      numericInput("start.tx", "Treatment Start Time (years):", 1, min = 0),
      numericInput("n.tx", "Number of Treatments:", 5, min = 1),
      numericInput("freq.tx", "Frequency of Treatments (years):", 1, min = 0.1, step = 0.1),
      numericInput("coverage", "Treatment Coverage:", 0.5, min = 0, max = 1, step = 0.1),
      numericInput("efficacy", "Treatment Efficacy:", 0.94, min = 0, max = 1, step = 0.01),
      actionButton("run", "Run Simulation")
    ),
    tabBox(
      height = 900, title = "Tabs", elevation = 2, id = "trend_analysis_card",
      width = 9, collapsible = TRUE, closable = FALSE, type = "tabs", maximizable = TRUE,
      status = "danger", solidHeader = TRUE, selected = "Trend Analysis",
      sidebar = boxSidebar(),
      tabPanel(
        "Trend Analysis",
        icon = icon("1"),
        plotOutput("plotW"),
        highchartOutput("plotE"),
        plotOutput("plotP"),
        plotOutput("plotRe")
      )
    )
  )
)

# putting tabs together
body <- dashboardBody(
  tabItems(
    plots_tab
  )
)

