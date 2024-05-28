#########################################
## utility functions
########################################
funcs <- list(
  # mating probability
  matingf = function(W,k){

  alpha= W/(k+W)
  
  integrand <- function(theta)  
  {(1-cos(theta))/(((1+alpha*cos(theta))^(1+k)))}
  intsol <- integrate(integrand, lower=0, upper=2*pi)
  int <- intsol$value
  I= (((1-alpha)^(1+k))/(2*pi))
  I1= 1-I*int
  return(I1)

}, 
  # density-dependent reduction in worm fecundity
  densdep = function(W, k, b, rho){
  
  {
    max <- max(c(qnbinom(0.9999, size=k, mu=I(W*rho)),1), na.rm=T)
    
    probs <- dnbinom(seq(1,max), size = k, mu= I(W*rho))
    sumsol <- sum( (1:max)^(b-1)*probs ) / (1-(1+(W*rho)/k)^(-k))
    return(as.numeric(sumsol))
  }
  
}, 
 # model differential equations
  schistomod = function(t,y,par){
    with(as.list(c(y,par)),{
    
    # initialise numeric variable for derivative
    dy <- numeric(1)
    
    ## redefine y as worm burden, W
    W <- y
    
    ## calculate mating probability
    mmat <- funcs$matingf(W,k)
    
    ## calculate density-dependent fecundity
    dd <- funcs$densdep(W, k, b, rho)
    
    ## calculate egg output
    E <- rho*W*dd*a
    
    ## calculate prevalence of infection
    p <- (1-(1+(W)/k)^-k)
    
    ## calculate the proportion of infectious snails
    py <- mu1*R0^R0_weight*N1N2*W*mmat*dd/(mu1*R0^R0_weight*N1N2*W*mmat*dd+mu2)
    
    ## calculate effective reproduction number
    Re <- (R0/rho)*mmat*dd*(1-py) 
    
    ## ordinary differntial equation
    dy <- ((R0/rho)*mu2*W*mmat*dd) / ((R0^R0_weight)*N1N2*W*mmat*dd + mu2/mu1) - mu1*W
    
    return(list(dy,W=W, E=E, p=p, Re=Re, py=py))
    
  })
}, 
  # treatment event function
  eventfunc = function(t, y, par) {
  with(as.list(par, y), {
    t1 <- seq(start.tx, start.tx +
                (n.tx-1)*freq.tx, freq.tx)
    if (any(abs(t-t1) < dt)) {
      y <- y*(1-efficacy*coverage)
    } 
      else y
    return(y) 
   }
      
  )}
)

#############################################
## main wrapper function for running the model
#############################################
runmod <- function(init, par) {
  with(as.list(c(par)), {
  
    if (dotx==0) {
      t1 <- seq(0,stop.t,by=dt)
      
      out <- lsoda(y=init, times=t1, func=funcs$schistomod, parms=par)
      
    } else {
      
      stop.tx <- start.tx+(n.tx-1)*freq.tx  
      
      t1 <- seq(0,stop.t,by=dt)
      
      out <- lsoda(y=init, times=t1, func=funcs$schistomod, parms=par,
                       events = list(func=funcs$eventfunc, 
                                     time=seq(start.tx,stop.tx,freq.tx), parms=par, root=F))
    }
    
    out <- as.data.frame(out)
    out <- out[,-c(2)]
    
    every <- ceiling(dtout/dt)
    
    return( out[seq(1,nrow(out), every),] )
    
})
}


