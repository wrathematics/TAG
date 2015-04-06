### 'About' tab

output$main_about <- renderUI({
  HTML("
  <h1>TAG: Text Analysis Gateway</h1>
  <h3>Basic Text Analysis Tools Without the Programming</h3>
  
  <ul>
    <li>Author: &copy; Drew Schmidt and Mike Black</li>
    <li>Version: Version 0.1.0</li>
    <li>Date: TODO</li>
    <li>License: AGPLv3</li>
  </ul>
  
  <p>
  This interactive web app is a rough prototype for demonstrating
  a possible interface for basic text analysis, powered by
  <a href='http://www.rstudio.com/shiny/' target='_blank'>Shiny</a>.
  </p>
  
  <h3>License</h3>
  <p>
  This web app is open source, licensed under the 
  <a href='http://www.tldrlegal.com/l/AGPL3' target='_blank'>Affero Gnu Public License Version 3 (AGPLv3)</a>.
  This license requires attribution, the inclusion of copyright and license in 
  all copies of the software, stating changes to all modified code, and 
  the sharing of all source code. Details are in the LICENSE file.
  </p>
  
  <p>
  Code available on <a href='/to/do/' target='_blank'>GitHub</a>.
  </p>
")
})


