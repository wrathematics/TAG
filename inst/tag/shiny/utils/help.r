### Modified from Vincent Nijs' Radiant:  https://github.com/vnijs/radiant

render_helpfile <- function(title, file)
{
  file <- paste0("shiny/help/", file)
  
  body <- markdown::markdownToHTML(file, fragment.only=TRUE, options=c(""))
  link <- paste0(gsub(title, pattern=" ", replacement=""), "_help")
  thisyear <- format(Sys.Date(), "%Y")
  
  html <- sprintf("
    <hr>
    <div class='modal fade' id='%s' tabindex='-1' role='dialog' aria-labelledby='%s_label' aria-hidden='true'>
      <div class='modal-dialog'>
        <div class='modal-content'>
          <div class='modal-header'>
            <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
            <h4 class='modal-title' id='%s_label'>%s</h4>
          </div>
          <div class='modal-body'>%s
          <br><br>
            <font size='1'>
            &copy;%s Drew Schmidt and Mike Black.
            All documentation is released under a
              <a rel='license' href='http://creativecommons.org/licenses/by-sa/4.0/' target='_blank'>Creative Commons License</a>.
              <img alt='' style='border-width:0' height=20px src='./img/cc.png'>
            </font>
          </div>
        </div>
      </div>
    </div>
    <div title='Help' data-toggle='modal' data-target='#%s'>
      <i>Click for help</i>
      <div title='Help' class='glyphicon glyphicon-question-sign'></div>
    </div>
     ", link, link, link, title, body, thisyear, link)
  
  html <- enc2utf8(html)
  HTML(html)
}




# This is way more genearl than we need now; originally the help
# menu's radio buttons were checkboxes, but it was kind of dumb soooo
render_helpfile_inplace <- function(title, files)
{
  files <- paste0("shiny/help/", files)
  
  raw <- paste("#", title_case(title), "\n\n")
  for (file in files)
  {
    raw <- c(raw, "", readLines(file))
  }
  
  body <- markdown::markdownToHTML(text=raw, fragment.only=TRUE, options=c(""))
  
  link <- paste0(gsub(title, pattern=" ", replacement=""), "_help")
  thisyear <- format(Sys.Date(), "%Y")
  
  html <- sprintf("%s
    <br><br>
    <font size='1'>
      &copy;%s Drew Schmidt and Mike Black.
      All documentation is released under a
      <a rel='license' href='http://creativecommons.org/licenses/by-sa/4.0/' target='_blank'>Creative Commons License</a>.
      <img alt='' style='border-width:0' height=20px src='./img/cc.png'>
    </font>
     ", body, thisyear, link)
  
  html <- enc2utf8(html)
  HTML(html)
}



title_case <- function(x) gsub(x, pattern="(^|[[:space:]])([[:alpha:]])", replacement="\\1\\U\\2", perl=TRUE)



from_md_to_display <- function(terms)
{
  terms <- gsub(terms, pattern="_", replacement=" ")
  terms <- gsub(terms, pattern=".md", replacement="")
  terms <- title_case(terms)
  
  ### special cases that have to be dealt with :(
  terms <- gsub(terms, pattern="Lda ", replacement="LDA ")
  
  terms
}



from_display_to_md <- function(terms)
{
  terms <- tolower(terms)
  terms <- gsub(terms, pattern=" ",  replacement="_")
  paste0(terms, ".md")
}






