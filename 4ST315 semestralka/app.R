library(shiny)

col_names <- c("Artist",
               "Country",
               "Album",
               "Yr",
               "Genre",
               "Style",
               "Release",
               "ListenDate",
               "Rating")

poslechy <- read.csv("https://raw.githubusercontent.com/vhyv/skola/master/4ST315%20semestralka/poslechy.csv", col.names = col_names,
                     dec = ",", sep = ";")


ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
   headerPanel(h1("Muzika")),
    hr(),
    h4("Seznam mnou odposlouchaných alb za poslední ~rok"),
    hr(),
 
    flowLayout(
        selectInput(inputId = "release", label = "Album release", choices= unique(poslechy$Release)),
        sliderInput(inputId = "rok", label = "Období", min = 1960, 
                    max = 2020, value = c(1990, 2010)),
        sliderInput(inputId = "rating", label = "Rating alba", min = 0, max = 10, value = c(6, 10))
            ),
    flowLayout(
        checkboxGroupInput(inputId = "zeme", label = 'Země původu', choices = unique(poslechy$Country), selected = unique(poslechy$Country)),
        checkboxGroupInput(inputId = "zanr", label = 'Žánr', choices = unique(poslechy$Genre), selected = unique(poslechy$Genre))
   )
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("tabulka",
                        dataTableOutput(outputId = "tabule"))
            )
        )
    )
)

server <- function(input, output) {
    df_subset <- reactive({
        a <- subset(poslechy, Release == input$release & Yr >= input$rok[1] & Yr <= input$rok[2] & Country %in% input$zeme
                    & Genre %in% input$zanr & Rating >= input$rating[1] & Rating <= input$rating[2])
        return(a)
    })
    output$tabule <- renderDataTable({df_subset()})
}

shinyApp(ui = ui, server = server)