# Conventions

Last Revised: June 23, 2015


This is a style guide and set of coding standards for authors and
contributors of the TAG project.  I am deliberately ignoring
**unimportant** conventions, such as the line on which an opening
brace starts, tabs/spcaes, etc.  You should try your hardest to
keep styles consistent and legible, but that is not the purpose of
this document.

Throughout, **many** assumptions have been made about, for example,
naming conventions and file structures.  If one were to deviate
from those assumptions, things will break.  The organization was
deliberately chosen to make things very simple to reason about
and modify, but it is sometimes very verbose.

Throughout, I'm assuming you're at least reasonably familiar with
R and Shiny.  If not, especially the latter, you should read up
on them.  Here are some suggestions for places to start:

R:
* [The Art of R Programming](http://www.amazon.com/Art-Programming-Statistical-Software-Design/dp/1593273843)
* [R Packages](http://r-pkgs.had.co.nz/)
* [Advanced R](http://adv-r.had.co.nz/)

Shiny:
* Basics: [Shiny Tutorial](http://shiny.rstudio.com/tutorial/)
* Examples: [Shiny Gallery](http://shiny.rstudio.com/gallery/)
* Advanced topics: [Shiny Articles](http://shiny.rstudio.com/articles/)
* [Reference Manual](http://cran.r-project.org/web/packages/shiny/shiny.pdf)




## Naming Rules



## Calling Functions

Except in the case of a function from `shiny` or `TAG` itself, you
should always specify the namespace of a function you are using.
So for example, if you want to use the `wordcloud()` function
from the `wordcloud` package, you should call
`wordcloud::wordcloud()`, **not** `wordcloud()`.

The justification for this requirement is that the package depends
on a **lot** of packages, and someone new to the codebase can
get up to speed much faster with explicit namespace usage.  This
is somewhat equivalent to not calling `using namespace` in C++;
based on the namespace import mechanics here, by default you can
think of R as having called `using package`.

You should also exercise some care in the importing of functions
from other packages, as it is possible to cause namespace
collissions that create undesireable behavior.



## Function Definitions

Whenever possible, you will want to put helper functions into the
`R/` subtree of the project.  This is because whatever code you
locally source for the app is not validated using any of R's
static analysis utilities.  However, this will require you either
properly document and export them (which you should do!), or
you call them using `:::`, which accesses non-exported functions
from a package.  So if you have no exported but need function `foo()`
from `R/foo.r`, you would call it via `TAG:::foo()`.

To document and export a function, you will need the roxygen2 package
installed.  TAG already has numerous examples about its usage.
To (re)generate documentation, run the `redocument` script at the
root of the project directory.

Note that the gateway, a shiny app, is essentially a user of the
TAG R package.



## State Management

#### Global Variables and Data



#### Local Variables and Data

Data local to each user should generally go in `localstate`, defined
in `inst/tag/server.r`.  These values will be reactive, and
they can be accessed as though `localstate` were a list.

At the time of writing, all analyses assume the existence of one
or more of the values:

* `localstate$corpus` --- a `tm` corpus object.
* `localstate$tdm` --- a `tm` term-documet-matrix object.
* `localstate$wordcount_table` --- a vector of counts of word frequencies from the corpus.

You can use the `must_have()` function to declare a dependency.  For
example, `must_have("corpus")` says that the current element requires
the existence of `localstate$corpus` (i.e., it requires the user
having imported or specified some data).

Beyond these fundamental values, sometimes an analysis creates an
object that is needed by other tabs.  Take for instance the Fit sub-tab
of the Analyse menu's LDA element.  When the user clicks the "Fit"
button, a new object is added to `localstate`, namely `lda_mdl`.

Whenever you create a new object for `localstate` that other tabs
depend on, you should add the appropriate logic to the 
`must_have()` function located in `R/validate.r` and then add
the appropriate `must_have()` call to your new tabs.



## Help Files

Help files go in `inst/tag/shiny/help/` and are then separated by subdirectory
according to their tab on the main TAG interface.  So the Analyse tab
has its help files go in the `inst/tag/shiny/help/analyse` folder.

Files are named according to the rule `subtab_element.md`.  So in the
analysis tab, for the LDA set of analysis elements, the Fit sub-tab
help file must be named `lda_fit.md`.



## Dynamically Generated/Modified Files

At the time of writing, the following files are the only ones
outisde of those handled or modified by the `roxygen2` package
(`NAMESPACE`, `DESCRIPTION`, and `man/*`) which are dynamically
generated or modified are:

* `inst/tag/shiny/pages/about.md`
* `README.md`

Each of these files is updated by `redocument`.  Whenever possible
(it is not in `README.md`), you should document in a comment at
the top of any file dynamically modified what is updated.  Further,
you should make the generation/modification a side-effect of
running `redocument`.


