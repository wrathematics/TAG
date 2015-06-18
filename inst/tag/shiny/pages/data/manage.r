output$data_manage <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        radioButtons(inputId="data_infile", label="Select File:", c("txt"="txt", "dir"="dir", "rda"="rda"), selected="txt", inline=TRUE),
        conditionalPanel(condition = "input.data_infile == 'state'",
          fileInput('uploadState', 'Load previous app state:', accept=".rda"),
          uiOutput("refreshOnUpload")
        ),
        selectizeInput("data_books", "Books", booklist_names)
      ),
    mainPanel(
      htmlOutput("data_transform_buttonaction")
      )
    )
  )
})


