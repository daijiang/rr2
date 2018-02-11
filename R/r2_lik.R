#' Calculate R2.lik
#'
#' Calculate R2.lik for LMM, GLMM, PGLM, and PGLMMs.
#' @param mod a regression model with the following class: 'lmerMod', 'glmerMod', 'phylolm', and 'phyloglm'
#' @param mod.r reduced model, if not provided, will use corresponding models with intercept as the only predictor
#' @return R2.lik
#' @export
#'
R2.lik <- function(mod = NULL, mod.r = NULL) {

	if(!is.element(class(mod)[1], c("lm","glm","lmerMod","glmerMod","phylolm","phyloglm"))) {
		stop("mod must be class one of classes lm, glm, lmerMod, glmerMod, phylolm, phyloglm.")
	}

	if(class(mod)[1] == "lm"){
		if(!is.object(mod.r)){
			Y <- model.frame(mod)[,1]
			mod.r <- lm(Y ~ 1)
		}
		if(!is.element(class(mod.r)[1], c("lm"))){
			stop("mod.r must be class lm.")
		}
		return(R2.lik.lm(mod, mod.r)[1])
	}

	if(class(mod)[1] == "glm"){
		if(!is.object(mod.r)){
			Y <- model.frame(mod)[,1]
			mod.r <- glm(Y ~ 1, family = family(mod)[[1]])
		}
		if(!is.element(class(mod.r)[1], c("glm"))){
			stop("mod.r must be class glm.")
		}
		return(R2.lik.glm(mod, mod.r)[1])
	}

    if (class(mod)[1] == "lmerMod") {
        if (!is.object(mod.r)) {
            Y <- model.frame(mod)[, 1]
            mod.r <- lm(Y ~ 1)
        }
        if (!is.element(class(mod.r)[1], c("lmerMod", "lm"))) {
            stop("mod.r must be class lmerMod or lm.")
        }
        if (lme4::isREML(mod)) {
            mod <- update(mod, REML = F)
            warning("mod updated with REML = F")
        }
        if (class(mod.r)[1] == "lmerMod" && lme4::isREML(mod.r)) {
            mod.r <- update(mod.r, REML = F)
            warning("mod.r updated with REML = F")
        }
        return(R2.lik.lmerMod(mod, mod.r)[1])
    }

    if (class(mod)[1] == "glmerMod") {
        if (!is.object(mod.r)) {
            Y <- model.frame(mod)[, 1]
            mod.r <- glm(Y ~ 1, family = family(mod)[[1]])
        }
        if (!is.element(class(mod.r)[1], c("glmerMod", "glm"))) {
            stop("mod.r must be class glmerMod or glm.")
        }
        return(R2.lik.glmerMod(mod, mod.r)[1])
    }

    if (class(mod)[1] == "phylolm") {
        if (!is.object(mod.r)) {
            Y <- mod$y
            mod.r <- lm(Y ~ 1)
        }
        if (!is.element(class(mod.r)[1], c("phylolm", "lm"))) {
            stop("mod.r must be class phylolm or lm.")
        }
        return(R2.lik.phylolm(mod, mod.r))
    }

    if (class(mod)[1] == "phyloglm") {
        if (!is.object(mod.r)) {
            Y <- mod$y
            mod.r <- glm(Y ~ 1, family = "binomial")
        }
        if (!is.element(class(mod.r)[1], c("phyloglm", "glm"))) {
            stop("mod.r must be class phyloglm or glm.")
        }
        return(R2.lik.phyloglm(mod, mod.r)[1])
    }
}

R2.lik.lm <- function(mod = NULL, mod.r = NULL) {
    
    X <- mod$X
    n <- dim(X)[1]
    
    R2.lik <- 1 - exp(-2/n * (logLik(mod)[[1]] - logLik(mod.r)[[1]]))
    return(R2.lik)
}

R2.lik.glm <- function(mod = NULL, mod.r = NULL) {
    
    X <- mod$X
    n <- dim(X)[1]
    
    R2.lik <- 1 - exp(-2/n * (logLik(mod)[[1]] - logLik(mod.r)[[1]]))
    return(R2.lik)
}

R2.lik.lmerMod <- function(mod = NULL, mod.r = NULL) {

    X <- model.matrix(mod)
    n <- dim(X)[1]

    R2.lik <- 1 - exp(-2/n * (logLik(mod) - logLik(mod.r)))
    return(R2.lik)
}

R2.lik.glmerMod <- function(mod = NULL, mod.r = NULL) {

    X <- model.matrix(mod)
    n <- dim(X)[1]

    R2.lik <- (1 - exp(-2/n * (logLik(mod) - logLik(mod.r))))/(1 - exp(2/n * logLik(mod.r)))
    return(R2.lik)
}

R2.lik.phylolm <- function(mod = NULL, mod.r = NULL) {

    X <- mod$X
    n <- dim(X)[1]

    R2.lik <- 1 - exp(-2/n * (logLik(mod)[[1]] - logLik(mod.r)[[1]]))
    return(R2.lik)
}

R2.lik.phyloglm <- function(mod = NULL, mod.r = NULL) {

    Y <- mod$y
    n <- dim(mod$X)[1]
    X <- mod$X

    alpha.cutoff <- 40
    if (mod$alpha < alpha.cutoff) {
        LL <- mod$logLik
    } else {
        LL <- logLik(glm(Y ~ 0 + X, family = "binomial"))
    }
    if (class(mod.r)[1] == "phyloglm") {
        if (mod.r$alpha < alpha.cutoff) {
            LL.r <- mod.r$logLik
        } else {
            X.r <- mod.r$X
            LL.r <- logLik(glm(Y ~ 0 + X.r, family = "binomial"))
        }
    } else {
        LL.r <- logLik(mod.r)
    }

    R2.lik <- (1 - exp(-2/n * (LL - LL.r)))/(1 - exp(2/n * LL.r))

    return(R2.lik)
}