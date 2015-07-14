output$main_help <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        selectizeInput("help_topic", "Help Topic", helpdirs_display),
        conditionalPanel(
          condition=paste0("input.help_topic == '", helpdirs[1], "'"),
          radioButtons("helpdirs_1", title_case(helpdirs[1]), choices=from_md_to_display(helppages[helpdirs[1]][[1]]))
        ),
        conditionalPanel(
          condition=paste0("input.help_topic == '", helpdirs[2], "'"),
          radioButtons("helpdirs_2", title_case(helpdirs[2]), choices=from_md_to_display(helppages[helpdirs[2]][[1]]))
        ),
        conditionalPanel(
          condition=paste0("input.help_topic == '", helpdirs[3], "'"),
          radioButtons("helpdirs_3", title_case(helpdirs[3]), choices=from_md_to_display(helppages[helpdirs[3]][[1]]))
        )
      ),
      mainPanel(
        htmlOutput("help_")
      )
    )
  )
})


output$help_ <- renderUI({
  
  print(helpdirs)
print(helppages)

  if (input$help_topic == "")
    HTML(markdown::markdownToHTML("shiny/pages/help.md", fragment.only=TRUE, options=c("")))
  else if (input$help_topic == helpdirs[1])
    render_helpfile_inplace(helpdirs[1], paste0(helpdirs[1], "/", from_display_to_md(input$helpdirs_1)))
  else if (input$help_topic == helpdirs[2])
    render_helpfile_inplace(helpdirs[2], paste0(helpdirs[2], "/", from_display_to_md(input$helpdirs_2)))
  else if (input$help_topic == helpdirs[3])
    render_helpfile_inplace(helpdirs[3], paste0(helpdirs[3], "/", from_display_to_md(input$helpdirs_3)))
})


