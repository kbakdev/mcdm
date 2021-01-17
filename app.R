library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyjs)
library(shinycssloaders)
library(tidyverse)
library(DT)
library(formattable)
library(MCDM)

source("./helpers/MetaRanking_custom.R")

ui <- tagList(
  useShinyjs(),
  inlineCSS(
    "
    #loading-content {
    position: absolute;
    background: #EEEEEE;
    opacity: 0.9;
    z-index: 100;
    left: 0;
    right: 0;
    height: 100%;
    text-align: center;
    }
    "
  ),
  div(
    id = "loading-content",
    h2("Loading...")
  ),
  hidden(
    div(
      id = "app-content",
      navbarPage(
        "Multiple Criteria Decision Making",
        theme = shinytheme("yeti"),
        tabPanel(
          "Dane",
          icon = icon("database"),
          sidebarLayout(
            sidebarPanel(
              radioButtons(
                "source",
                "Wybierz źródło danych",
                choices = c(
                  "Przykładowy zbiór danych" = "example",
                  "Prześlij zbiór danych" = "upload"
                )
              ),
              conditionalPanel(
                condition = "input.source == 'example'",
                helpText("To jest sfabrykowany zbiór danych")
              ),
              conditionalPanel(
                condition = "input.source == 'upload'",
                fileInput(
                  "upload_data",
                  "Prześlij swoje dane",
                  multiple = FALSE,
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv"
                  )
                ),
                helpText("Plik powinien mieć format .csv")
              ),
              actionButton(
                "use",
                "Użyj zbioru danych"
              ),
              conditionalPanel(
                condition = "input.use",
                br(),
                pickerInput(
                  "alternative",
                  "Wybierz kolumnę zawierającą alternatywy",
                  choices = NULL
                ),
                pickerInput(
                  "attribute_max",
                  "Atrybuty „Im wyższy, tym lepszy”",
                  choices = NULL,
                  multiple = TRUE,
                  options = list(
                    "live-search" = TRUE,
                    "actions-box" = TRUE
                  )
                ),
                pickerInput(
                  "attribute_min",
                  "Atrybuty „Im niższy, tym lepszy”",
                  choices = NULL,
                  multiple = TRUE,
                  options = list(
                    "live-search" = TRUE,
                    "actions-box" = TRUE
                  )
                ),
                actionButton(
                  "arrange",
                  "Uporządkuj zbiór danych"
                )
              )
            ),
            mainPanel(
              withSpinner(DT::dataTableOutput("tab_dataset"), type = 5, color = "#34495e")
            )
          )
        ),
        tabPanel(
          "Analiza",
          icon = icon("line-chart"),
          sidebarLayout(
            sidebarPanel(
              uiOutput("setting_panel"),
              pickerInput(
                "method",
                "Metoda",
                choices = c(
                  "Multi-MOORA" = "MMOORA",
                  "TOPSIS Linear" = "TOPSISLinear",
                  "TOPSIS Vector" = "TOPSISVector",
                  "VIKOR" = "VIKOR",
                  "WASPAS" = "WASPAS",
                  "Meta Ranking" = "MetaRanking"
                ),
                selected = "TOPSISVector"
              ),
              conditionalPanel(
                condition = "input.method == 'VIKOR'",
                sliderInput(
                  "v",
                  "Wartość 'v' (domyślnie: 0,5)",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1
                )
              ),
              conditionalPanel(
                condition = "input.method == 'WASPAS'",
                sliderInput(
                  "lambda",
                  "Wartość 'lambda' (domyślnie: 0,5)",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1
                )
              ),
              conditionalPanel(
                condition = "input.method == 'MetaRanking'",
                sliderInput(
                  "v",
                  "Wartość 'v' (domyślnie: 0,5)",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1
                ),
                sliderInput(
                  "lambda",
                  "Wartość 'lambda' (domyślnie: 0,5)",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.1
                )
              ),
              actionButton(
                "apply",
                "Zastosuj"
              )
            ),
            mainPanel(
              withSpinner(DT::dataTableOutput("tab_res"), type = 5, color = "#34495e")
            )
          )
        ),
        tabPanel(
          "O aplikacji",
          icon = icon("support"),
          wellPanel(
            includeMarkdown("README.md")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  hide(id = "loading-content", anim = TRUE, animType = "fade")
  show("app-content")
  
  observe({
    if (input$source == "example") {
      enable("use")
    } else if (input$source == "upload" & !is.null(input$upload_data)) {
      enable("use")
    } else {
      disable("use")
    }
  })
  
  rawdata <- eventReactive(input$use, {
    if (input$source == "example") {
      read_csv("./data/spolki-zywnosciowe.csv")
    } else if (input$source == "upload") {
      read_csv(input$upload_data$datapath)
    }
  })
  
  observeEvent(input$use, {
    updatePickerInput(
      session = session,
      inputId = "alternative",
      choices = names(rawdata())
    )
    
    updatePickerInput(
      session = session,
      inputId = "attribute_max",
      choices = names(rawdata())
    )
    
    updatePickerInput(
      session = session,
      inputId = "attribute_min",
      choices = names(rawdata())
    )
  })
  
  observe({
    toggleState(id = "arrange", condition = !is.null(input$alternative) & {
      !is.null(input$attribute_max) | !is.null(input$attribute_min)
    })
  })
  
  observeEvent(input$arrange, {
    showModal(
      modalDialog(
        title = strong("Zestaw danych jest ustawiony"),
        "Proszę spojrzeć na zaaranżowany zbiór danych, czy jest już prawidłowo skonfigurowany?", 
        br(),
        "Jeśli tak, przejdź do zakładki „Analiza”! W przeciwnym razie możesz zmienić kolejność zbioru danych.",
        size = "m",
        easyClose = TRUE, 
        fade = TRUE
      )
    )
  })
  
  dataset <- eventReactive(input$arrange, {
    cost <- style(
      "background-color" = csscolor("darkred"),
      color = "white",
      display = "block",
      "border-radius" = "4px",
      "padding" = "0 4px"
    )
    
    benefit <- style(
      "background-color" = csscolor("seagreen"),
      color = "white",
      display = "block",
      "border-radius" = "4px",
      "padding" = "0 4px"
    )
    
    if (!is.null(input$attribute_max) & !is.null(input$attribute_min)) {
      res <- rawdata() %>%
        select(one_of(input$alternative, input$attribute_max, input$attribute_min)) %>% 
        formattable(
          list(area(col = isolate(input$attribute_max)) ~ formatter("span", style = benefit),
               area(col = isolate(input$attribute_min)) ~ formatter("span", style = cost))
        )
    } else if  (is.null(input$attribute_min)) {
      res <- rawdata() %>%
        select(one_of(input$alternative, input$attribute_max, input$attribute_min)) %>% 
        formattable(
          list(area(col = isolate(input$attribute_max)) ~ formatter("span", style = benefit))
        )
    } else if (is.null(input$attribute_max)) {
      res <- rawdata() %>%
        select(one_of(input$alternative, input$attribute_max, input$attribute_min)) %>% 
        formattable(
          list(area(col = isolate(input$attribute_min)) ~ formatter("span", style = cost))
        )
    }
    return(res)
  })
  
  output$tab_dataset <- DT::renderDataTable({
    dataset() %>%
      as.datatable(
        rownames = FALSE,
        caption = "Kolumny w kolorze zielonym określają atrybuty, które są pożądane przy dużych wartościach, natomiast kolumny w kolorze czerwonym określają atrybuty, które są niepożądane przy dużych wartościach.",
        style = "bootstrap",
        extensions = c("Scroller", "Buttons"),
        options = list(
          dom = "Brt",
          autoWidth = FALSE,
          scrollX = TRUE,
          deferRender = TRUE,
          scrollY = 300,
          scroller = TRUE,
          buttons =
            list(
              list(
                extend = "Kopiuj"
              ),
              list(
                extend = "collection",
                buttons = c("csv", "excel"),
                text = "Pobierz"
              )
            )
        )
      )
  },
  server = FALSE
  )
  
  observeEvent(input$arrange, {
    output$setting_panel <- renderUI({
      tagList(
        map(
          c(input$attribute_max, input$attribute_min),
          ~ numericInput(
            inputId = paste0("weight_", .x), label = paste("Waga dla", .x),
            min = 0, max = 1, value = 1 / length(c(input$attribute_max, input$attribute_min))
          )
        ),
        helpText("Suma wag powinna wynosić 1")
      )
    })
  })
  
  observe({
    toggleState(
      id = "apply",
      condition = !is.null(dataset())
    )
  })
  
  res <- eventReactive(input$apply, {
    if (input$method == "MetaRanking") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        MetaRanking_custom(weights = w, cb =  cb, v = input$v, lambda = input$lambda) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "TOPSIS Vector" = TOPSISVector,
               "TOPSIS Linear" = TOPSISLinear,
               "Ranking meta (suma)" = MetaRanking_Sum,
               "Meta Ranking (zbiorczy)" = MetaRanking_Aggreg) %>%
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2)))
      
    } else if (input$method == "MMOORA") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        MMOORA(w, cb) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "System współczynników" = RatioSystem,
               "Ranking (system współczynników)" = Ranking,
               "Punkt odniesienia" = ReferencePoint,
               "Ranking (punkt odniesienia)" = Ranking.1,
               "Forma multiplikatywna" = MultiplicativeForm,
               "Ranking (forma multiplikatywna)" = Ranking.2,
               "Ogólny ranking (Multi MOORA)" = MultiMooraRanking) %>% 
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2)))
    } else if (input$method == "RIM") {
      
    } else if (input$method == "TOPSISLinear") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        TOPSISLinear(w, cb) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "Indeks R" = R) %>%
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2)))
    } else if (input$method == "TOPSISVector") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        TOPSISVector(w, cb) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "Indeks R" = R) %>%
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2)))
    } else if (input$method == "VIKOR") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        VIKOR(w, cb, v = input$v) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "Indeks S" = S,
               "Indeks R" = R,
               "Indeks Q" = Q) %>%
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2)))
    } else if (input$method == "WASPAS") {
      cb <- c(
        rep("max", length(input$attribute_max)),
        rep("min", length(input$attribute_min))
      )
      
      w <- map_dbl(
        c(input$attribute_max, input$attribute_min),
        ~ input[[paste0("weight_", .x)]]
      )
      
      res <- dataset() %>%
        as.data.frame() %>%
        `rownames<-`(.[, input$alternative]) %>%
        select_if(is.numeric) %>%
        as.matrix() %>%
        WASPAS(w, cb, lambda = input$lambda) %>%
        as_tibble() %>%
        rename(Alternative = Alternatives,
               "Wynik WSM" = WSM,
               "Wynik WPM" = WPM,
               "Indeks Q" = Q) %>%
        mutate(Alternative = pull(dataset()[, input$alternative])) %>% 
        mutate_if(is_double, .funs = funs(round(., 2))) 
    }
    return(res)
  })
  
  output$tab_res <- DT::renderDataTable({
    res() %>%
      datatable(
        rownames = FALSE,
        style = "bootstrap",
        extensions = c("Scroller", "Buttons"),
        options = list(
          dom = "Brt",
          autoWidth = FALSE,
          scrollX = TRUE,
          deferRender = TRUE,
          scrollY = 300,
          scroller = TRUE,
          buttons =
            list(
              list(
                extend = "copy"
              ),
              list(
                extend = "collection",
                buttons = c("csv", "excel"),
                text = "Download"
              )
            )
        )
      )
  },
  server = FALSE
  )
}

shinyApp(ui = ui, server = server)