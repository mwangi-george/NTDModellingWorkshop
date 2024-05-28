#########################################
## default parameters
########################################
par <-      c(R0=2,                 # basic reproduction number
              R0_weight = 0.5,        # R0 host -> snails
              N1N2 = 1/10,            # host-to-snail population density
              mu0 = 1/50,             # human mortality rate (1/mu0 = average human lifespan)
              mu1= 1/5,               # adult worm mortality rate (1/mu1 =average schistosome lifespan)
              mu2= 1/(1/12),          # snail mortality rate (1/mu2= average infectious snail lifespan)
              k= 0.5,                 # overdispersion adult worms among hosts
              rho = 0.5,              # sex ratio (proportion female)
              coverage= 0.50,         # population treatment coverage
              efficacy= 0.94,         # efficacy of PZQ
              start.tx=1,             # treatment start time
              n.tx=5,                # number of treatments
              freq.tx=1,              # frequency of treatments
              dt=1/12,                # integration time step (fixed)
              dtout=1/12,             # output every dtout of a year
              stop.t=100,             # simulation stop time
              a= exp(3.24),           # maximum egg output from 1 female (Neves et al 2021)
              b=0.25,                    # density-dependent constraint on fecundity (Neves et al 2021)
              z=50,                   # threshold egg density for heavy infection
              dotx=0)                 # toggle treatments on/off