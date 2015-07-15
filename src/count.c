/* 
  Copyright (C) 2015 Drew Schmidt. All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
    * Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#define INT(x) INTEGER(x)[0]
#define CHARPT(x,i) ((char*)CHAR(STRING_ELT(x,i)))
#define LEN1INTVEC(Rname,value) \
  PROTECT(Rname = allocVector(INTSXP, 1)); \
  INTEGER(Rname)[0] = value

#define MIN(a,b) (a<b?a:b)

#include <R.h>
#include <Rinternals.h>

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>


SEXP R_wc(SEXP string, SEXP wordlen_max_, SEXP senlen_max_)
{
  int chars = 0, letters = 0, whitespace = 0, punctuation = 0, digits = 0;
  int words = 0, sentences = 0, lines = 0;
  const int wordlen_max = INT(wordlen_max_);
  const int senlen_max = INT(senlen_max_);
  char c, *str;
  bool multispace_correction;
  
  SEXP ret, ret_names;
  SEXP Rchars, Rletters, Rwhitespace, Rpunctuation, Rdigits;
  SEXP Rwords, Rsentences, Rlines;
  
  SEXP wordlens;
  PROTECT(wordlens = allocVector(INTSXP, wordlen_max));
  for (int i=0; i<wordlen_max; i++)
    INTEGER(wordlens)[i] = 0;
  
  SEXP senlens;
  PROTECT(senlens = allocVector(INTSXP, senlen_max));
  for (int i=0; i<senlen_max; i++)
    INTEGER(senlens)[i] = 0;
  
  const int lenstr = LENGTH(string);
  
  for (int j=0; j<lenstr; j++)
  {
    int i = 0;
    int wordlen_current =  0, senlen_current =  0;
    str = CHARPT(string, j);
    
    lines++;
    
    while ((c=str[i]) != '\0')
    {
      chars++;
      
      multispace_correction = false;
      
      // new word
      if (isspace(c))
      {
        if (c != '\n')
          whitespace++;
        else
          lines++;
        
        words++;
        INTEGER(wordlens)[MIN(wordlen_current, wordlen_max)-1]++;
        wordlen_current =  0;
        senlen_current++;
      }
      else
      {
        wordlen_current++;
        
        if (ispunct(c))
        {
          punctuation++;
          if (c=='.' || c==';' || c=='!' || c=='?')
          {
            sentences++;
            INTEGER(senlens)[MIN(senlen_current, senlen_max)-1]++;
            senlen_current =  0;
          }
        }
        else
        {
          if (isalpha(c))
            letters++;
          else if (isdigit(c))
            digits++;
        }
      }
      
      // skip multiple spaces
      do
      {
        if (isspace(c))
        {
          chars++;
          whitespace++;
          multispace_correction = true;
          i++;
        }
        else
          break;
      } while ((c=str[i]) != '\0');
      
      if (!multispace_correction)
        i++;
      else
      {
        chars--;
        if (c != '\n')
          whitespace--;
      }
    }
    
    // Count words that end lines
    if (i == 0) 
      continue;
    
    c = str[i-1];
    if (!isspace(c) && c!='-')
    {
      words++;
      INTEGER(wordlens)[MIN(wordlen_current, wordlen_max)-1]++;
    }
    else if (c=='-' && j<lenstr-1)
    {
      words--;
      INTEGER(wordlens)[MIN(wordlen_current, wordlen_max)-1]--;
      senlen_current--;
    }
  }
  
  LEN1INTVEC(Rchars, chars);
  LEN1INTVEC(Rletters, letters);
  LEN1INTVEC(Rwhitespace, whitespace);
  LEN1INTVEC(Rpunctuation, punctuation);
  LEN1INTVEC(Rdigits, digits);
  LEN1INTVEC(Rwords, words);
  LEN1INTVEC(Rsentences, sentences);
  LEN1INTVEC(Rlines, lines);
  
  PROTECT(ret = allocVector(VECSXP, 10));
  SET_VECTOR_ELT(ret, 0, Rchars);
  SET_VECTOR_ELT(ret, 1, Rletters);
  SET_VECTOR_ELT(ret, 2, Rwhitespace);
  SET_VECTOR_ELT(ret, 3, Rpunctuation);
  SET_VECTOR_ELT(ret, 4, Rdigits);
  SET_VECTOR_ELT(ret, 5, Rwords);
  SET_VECTOR_ELT(ret, 6, Rsentences);
  SET_VECTOR_ELT(ret, 7, Rlines);
  SET_VECTOR_ELT(ret, 8, wordlens);
  SET_VECTOR_ELT(ret, 9, senlens);
  
  PROTECT(ret_names = allocVector(STRSXP, 10));
  SET_STRING_ELT(ret_names, 0, mkChar("chars"));
  SET_STRING_ELT(ret_names, 1, mkChar("letters"));
  SET_STRING_ELT(ret_names, 2, mkChar("whitespace"));
  SET_STRING_ELT(ret_names, 3, mkChar("punctuation"));
  SET_STRING_ELT(ret_names, 4, mkChar("digits"));
  SET_STRING_ELT(ret_names, 5, mkChar("words"));
  SET_STRING_ELT(ret_names, 6, mkChar("sentences"));
  SET_STRING_ELT(ret_names, 7, mkChar("lines"));
  SET_STRING_ELT(ret_names, 8, mkChar("wordlens"));
  SET_STRING_ELT(ret_names, 9, mkChar("senlens"));
  setAttrib(ret, R_NamesSymbol, ret_names);
  
  UNPROTECT(12);
  return ret;
}


