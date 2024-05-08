library(shiny)
library(plotly)
library(readr)
install.packages("shiny")
# Define UI
ui <- fluidPage(
  titlePanel("Google Play Store Categories"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("generate_button", "Generate Pie Chart")
    ),
    
    mainPanel(
      plotlyOutput("pie_chart"),
      downloadButton("download_chart", "Download Pie Chart")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Read the dataset
  data <- read.csv("E:/R/googleplaystore.csv")
  
  # Function to generate pie chart
  generatePieChart <- eventReactive(input$generate_button, {
    category_data <- table(data$Rating)
    pie_chart <- plot_ly(labels = names(category_data), values = category_data, type = "pie", textinfo = "percent+label", hole = 0.4)
    return(pie_chart)
  })
  
  # Render the pie chart
  output$pie_chart <- renderPlotly({
    generatePieChart()
  })
  
  # Allow user to download the pie chart as HTML
  output$download_chart <- downloadHandler(
    filename = function() {
      "pie_chart.html"
    },
    content = function(file) {
      htmlwidgets::saveWidget(generatePieChart(), file)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)