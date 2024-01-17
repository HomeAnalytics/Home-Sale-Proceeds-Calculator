#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyjs)


ui <- fluidPage(
  theme = shinytheme("yeti"),
  tags$head(
    tags$style(HTML("
      .container-fluid {
        text-align: center;
      }
      .input-field {
        margin-bottom: 10px;
      }
      .result-panel {
        margin-top: 20px;
      }
      .question-mark {
        cursor: help;
        text-decoration: underline;
        color: #31708f;
      }
    "))
  ),
  useShinyjs(),
  
  fluidRow(
    column(12, align = "center", 
           tags$h1("Home Sale Proceeds Calculator"),
           tags$p("Calculate your home sale proceeds with this handy calculator.")
    )
  ),
  
  fluidRow(
    column(12, align = "center",
           div(class = "input-field", numericInput("sell_price", "Selling Price ($)", value = 300000, min = 0)),
           div(class = "input-field", numericInput("loan_amount", "Outstanding Loan Amount ($)", value = 150000, min = 0)),
           div(class = "input-field", sliderInput("commission_rate", "Realtor Commission Rate (%)", value = 5, min = 0, max = 10)),
           div(class = "input-field", numericInput("prorated_tax", "Prorated Property Tax ($)", value = 2500, min = 0)),
           div(class = "helper-text", helpText("Estimated property tax for the part of the year you stayed in the property.")),
           div(class = "input-field", numericInput("attorney_fees", "Attorney Fees ($)", value = 1200, min = 0)),
           div(class = "input-field", numericInput("title_insurance_rpr", "Title Insurance or RPR ($)", value = 800, min = 0)),
           div(class = "helper-text", helpText("RPRs are more expensive and time-consuming.")),
           div(class = "input-field", numericInput("other_costs", "Other Costs ($)", value = 500, min = 0)),
           div(class = "helper-text", helpText("Additional costs such as home upgrades, mortgage penalty, etc."))
    )
  ),
  
  fluidRow(
    column(12, align = "center",
           actionButton("calculate_button", "Calculate", class = "btn-primary")
    )
  ),
  
  fluidRow(
    column(12, align = "center",
           wellPanel(
             textOutput("commission_output"),
             textOutput("net_proceeds_output")
           ),
           class = "result-panel"
    )
  )
)

server <- function(input, output) {
  observeEvent(input$calculate_button, {
    calculate_and_show_results()
  })
  
  calculate_and_show_results <- function() {
    commission <- input$sell_price * (input$commission_rate / 100)
    closing_costs <- input$prorated_tax + input$attorney_fees + input$title_insurance_rpr + input$other_costs
    net_proceeds <- input$sell_price - commission - input$loan_amount - closing_costs
    
    output$commission_output <- renderText({
      paste("Realtor Commission: $", format(commission, big.mark = ","))
    })
    
    output$net_proceeds_output <- renderText({
      paste("Net Sale Proceeds: $", format(net_proceeds, big.mark = ","))
    })
  }
}

shinyApp(ui, server)

