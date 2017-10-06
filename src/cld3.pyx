from libcpp.vector cimport vector
from libcpp.string cimport string

from collections import namedtuple


cdef extern from "nnet_language_identifier.h" namespace "chrome_lang_id::NNetLanguageIdentifier":
    cdef struct Result:
        string language
        float probability
        bint is_reliable
        float proportion

cdef extern from "nnet_language_identifier.h" namespace "chrome_lang_id":
    cdef cppclass NNetLanguageIdentifier:
        NNetLanguageIdentifier(int min_num_bytes, int max_num_bytes);
        Result FindLanguage(string &text)
        vector[Result] FindTopNMostFreqLangs(string &text, int num_langs)


LanguagePrediction = namedtuple("LanguagePrediction",
                                ("language", "probability", "is_reliable",
                                 "proportion"))


def get_language(unicode text, int min_bytes=0, int max_bytes=1000):
    """ Get the most likely language for the given text.

    The prediction is based on the first N bytes where N is the minumum between
    the number of interchange valid UTF8 bytes and max_num_bytes_. If N is less
    than min_num_bytes_ long, then this function returns "unknown".
    """
    cdef NNetLanguageIdentifier *ident = new NNetLanguageIdentifier(
        min_bytes, max_bytes)
    cdef Result res = ident.FindLanguage(text.encode('utf8'))
    return LanguagePrediction(res.language.decode('utf8'), res.probability,
        res.is_reliable, res.proportion)


def get_frequent_languages(unicode text, int num_langs, int min_bytes=0,
                           int max_bytes=1000):
    """ Find the most frequent languages in the given text.

    Splits the input text (up to the first byte, if any, that is not
    interchange valid UTF8) into spans based on the script, predicts a language
    for each span, and returns a vector storing the top num_langs most frequent
    languages along with additional information (e.g., proportions). The number
    of bytes considered for each span is the minimum between the size of the
    span and max_num_bytes_. If more languages are requested than what is
    available in the input, then for those cases kUnknown is returned. Also, if
    the size of the span is less than min_num_bytes_ long, then the span is
    skipped. If the input text is too long, only the first
    kMaxNumInputBytesToConsider bytes are processed.
    """
    cdef NNetLanguageIdentifier *ident = new NNetLanguageIdentifier(
        min_bytes, max_bytes)
    cdef vector[Result] results = ident.FindTopNMostFreqLangs(
        text.encode('utf8'), num_langs)
    out = []
    for res in results:
        out.append(LanguagePrediction(
            res.language.decode('utf8'), res.probability, res.is_reliable,
            res.proportion))
    return out
