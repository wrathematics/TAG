### Modified from Vincent Nijs' Radiant:  https://github.com/vnijs/radiant

render_helpfile <- function(title, file)
{
  body <- markdown::markdownToHTML(file, fragment.only=TRUE, options=c(""))
  link <- paste0(title, "_help")
  thisyear <- format(Sys.Date(), "%Y")
  
  html <- sprintf("
    <div class='modal fade' id='%s' tabindex='-1' role='dialog' aria-labelledby='%s_label' aria-hidden='true'>
      <div class='modal-dialog'>
        <div class='modal-content'>
          <div class='modal-header'>
            <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
            <h4 class='modal-title' id='%s_label'>%s</h4>
          </div>
          <div class='modal-body'>%s<br>
            &copy; Drew Schmidt and Mike Black %s.  All documentation is released under a <a rel='license' href='http://creativecommons.org/licenses/by-sa/4.0/' target='_blank'><img alt='Creative Commons License' style='border-width:0' src='images/cc.png'></a>
          </div>
        </div>
      </div>
    </div>
    <i title='Help' class='glyphicon glyphicon-question-sign' data-toggle='modal' data-target='#%s'></i>
     ", link, link, link, title, body, link, thisyear)
  
  html <- enc2utf8(html)
  HTML(html)
}

