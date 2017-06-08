/* Automatically generated. Do not edit by hand. */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <stdlib.h>

extern SEXP R_find_closest_word(SEXP input, SEXP words);
extern SEXP R_levenshtein_dist(SEXP s, SEXP t);
extern SEXP R_wc(SEXP string, SEXP wordlen_max_, SEXP senlen_max_, SEXP syllen_max_);

static const R_CallMethodDef CallEntries[] = {
  {"R_find_closest_word", (DL_FUNC) &R_find_closest_word, 2},
  {"R_levenshtein_dist", (DL_FUNC) &R_levenshtein_dist, 2},
  {"R_wc", (DL_FUNC) &R_wc, 4},
  {NULL, NULL, 0}
};

void R_init_TAG(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
