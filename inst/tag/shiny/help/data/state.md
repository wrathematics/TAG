## State Management

#### Background

This feature allows you to take a 'snapshot' of the internal TAG
state (data, models, etc.) for later re-use.  Presently, this saves:
* The data 'as is'.  Specifically, if you import data and perform
transformations and filtering, then saving and loading state will
preserve those filterings and transformations.
* LDA models fits.

Other features, such as plots or summaries under the 'Explore' tab,
will have to be re-calculated.



#### Usage

To save, simply click the 'Save' button.

To load state, click the 'Browse' button.

To clear state, meaning empty all data and models, click the 'Clear'
button.
