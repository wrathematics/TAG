output$summarize_corpus <- renderUI({
  must_have("corpus")
  
  summary <- wc(sapply(localstate$corpus, function(i) i$content), input$summarize_corpus_maxwordlen)
  localstate$sum_wordlens <- summary$wordlens
  
  html <- paste("
    <table>
      <tr>
        <td>Characters:</td>
        <td>", summary$chars, "</td>
      </tr>
      <tr>
        <td>Letters:</td>
        <td>", summary$letters, "</td>
      </tr>
      <tr>
        <td>Digits:</td>
        <td>", summary$digits, "</td>
      </tr>
      <tr>
        <td>Punctuation:</td>
        <td>", summary$punctuation, "</td>
      </tr>
      <tr>
        <td>Whitespace:</td>
        <td>", summary$whitespace, "</td>
      </tr>
      <tr>
        <td>Lines:</td>
        <td>", summary$lines, "</td>
      </tr>
      <tr>
        <td>Words:</td>
        <td>", summary$words, "</td>
      </tr>
      <tr>
        <td>Distinct words:</td>
        <td>", tm::nTerms(localstate$tdm), "</td>
      </tr>
      <tr>
        <td>Sentences:</td>
        <td>", summary$sentences, "</td>
      </tr>
      <tr>
        <td>Documents:</td>
        <td>", tm::nDocs(localstate$tdm), "</td>
      </tr>
      <tr>
        <td>Memory Usage:</td>
        <td>", memuse::swap.prefix(memuse::swap.names(memuse::object.size(localstate$corpus))), "</td>
      </tr>
    </table> 
  ")
  verticalLayout(
    HTML(html),
    render_helpfile("Corpus Summary", "summarize/basic_summary.md")
  )
})


output$summarize_corpus_wordlengths <- renderPlot({
  must_have("corpus")
  
  df <- data.frame(length=1:length(localstate$sum_word), characters=localstate$sum_word)
  df <- df[df$characters > 0, ]
  df$characters <- 100*df$characters/sum(df$characters)
  ggplot(data=df, aes(length, characters)) + 
    geom_bar(stat="identity") + 
    scale_x_continuous(breaks=df$length) +
    xlab("Characters") +
    ylab("Percentage of Corpus") +
    ggtitle("Distribution of Words by Character Length") + 
    theme_bw()
})




output$summarize_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        h5("Term Frequency"),
        checkboxInput("basic_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
        textInput("summarize_termsearchbox", ""),
        render_helpfile("Term Search", "summarize/basic_termsearch.md")
      ),
      mainPanel(
        uiOutput("tabs_search")
      )
    )
  )
})



output$tabs_search <- renderUI({
  must_have("wordcount_table")
  
  if (input$summarize_termsearchbox == "")
    return("")
  
  term <- input$summarize_termsearchbox
  
  if (input$basic_termsearch_checkbox_findclosest)
    term <- find_closest_word(term, names(localstate$wordcount_table))$word
  
  freq <- localstate$wordcount_table[term]
  
  if (is.na(freq))
    HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.).  See the Data--Transform tab.")
  else
    paste0("\"", term, "\" occurs ", freq, " times in the corpus.")
})

