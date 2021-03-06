data {
  int Nobs; /* Number of observations */

  real logLobs[Nobs]; /* natural log of luminosity observed. */
  real sigma_logL[Nobs]; /* Uncertainty on each measurement. */

  real Tobs[Nobs]; /* Observed temperature. */
  real sigma_Tobs[Nobs]; /* Temperature uncertainty */
}

parameters {
  real<lower=0,upper=15> beta; /* Power-law slope L = T^beta */
  real<lower=0> sigma_scatter;
  real<lower=0.8, upper=3>Ttrue[Nobs];  /* True temperature */
  real logLtrue[Nobs];
}

transformed parameters {
  real Ltrue[Nobs];

  Ltrue = exp(logLtrue);
}

model {
  /* Uniform prior on beta between limits. */
  /* Uniform prior on temperature between limits. */
  /* Broad, Cauchy prior on sigma_scatter, with scale 0.1 */
  sigma_scatter ~ cauchy(0, 0.1);

  /* Scatter in the relation: */
  for (i in 1:Nobs) {
    logLtrue[i] ~ normal(beta*log(Ttrue[i]), sigma_scatter);
  }

  Tobs ~ normal(Ttrue, sigma_Tobs);
  logLobs ~ normal(logLtrue, sigma_logL);
}
