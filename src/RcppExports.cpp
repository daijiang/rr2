// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// loop_cpp
arma::vec loop_cpp(const arma::vec& R, const arma::mat& V);
RcppExport SEXP rr2_loop_cpp(SEXP RSEXP, SEXP VSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::vec& >::type R(RSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type V(VSEXP);
    rcpp_result_gen = Rcpp::wrap(loop_cpp(R, V));
    return rcpp_result_gen;
END_RCPP
}

RcppExport void logistreglikelihood(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
RcppExport void threepoint(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
RcppExport void transbranchlengths_IvesGarland2010(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);

static const R_CallMethodDef CallEntries[] = {
    {"rr2_loop_cpp", (DL_FUNC) &rr2_loop_cpp, 2},
    {"logistreglikelihood",                (DL_FUNC) &logistreglikelihood,                12},
    {"threepoint",                         (DL_FUNC) &threepoint,                         13},
    {"transbranchlengths_IvesGarland2010", (DL_FUNC) &transbranchlengths_IvesGarland2010, 12},
    {NULL, NULL, 0}
};

RcppExport void R_init_rr2(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
