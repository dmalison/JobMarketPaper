functions {
  
  void add_C_measurement_lp(
    int C_num, 
    int[] I_C_num, 
    int[] I_C_ind, 
    vector M_C, 
    vector mu_M,
    vector gamma_M,
    vector sigma_M,
    vector theta
  ) 
  {
    int pos = 1;
    for (m in 1:C_num){
      M_C[pos:(pos + I_C_num[m] - 1)] ~
        normal(
          mu_M[m] + gamma_M[m] * theta[I_C_ind[pos:(pos + I_C_num[m] - 1)]],
          sigma_M[m]
        );
      pos = pos + I_C_num[m];
    }
  }
}
data {
  
  /*** number of observations ***/
    
    int<lower = 1> N;     
    
    /*** measurements ***/
      
      /*
      *_num: Number of measurements
    I_*_num: Number of non-missing observations for each measurement
    I_*_ind: Indices of non-missing observations for each measurement
    M_*: measurements
    */
      
      int<lower = 1> C_4_num;
    int<lower = 1, upper = N> I_C_4_num[C_4_num];
    int<lower = 1, upper = N> I_C_4_ind[sum(I_C_4_num)];
    vector[sum(I_C_4_num)] M_C_4;
    
    /*** priors ***/
      
      vector[C_4_num] mu_M_C_4_mean;
    vector<lower = 0>[C_4_num] gamma_M_C_4_mean; 
    vector<lower = 0>[C_4_num] sigma_M_C_4_mean;
    
}
transformed data {
  
  // convert gamma mean and sd to alpha and beta parameters
  
  vector[C_4_num] mu_M_C_4_sigma = mu_M_C_4_mean/5;
  
  vector<lower = 0>[C_4_num] gamma_M_C_4_alpha = square(gamma_M_C_4_mean) ./ square(gamma_M_C_4_mean/2);
  vector<lower = 0>[C_4_num] gamma_M_C_4_beta  = gamma_M_C_4_mean ./ square(gamma_M_C_4_mean/2);
  
  vector<lower = 0>[C_4_num] sigma_M_C_4_alpha = square(sigma_M_C_4_mean) ./ square(sigma_M_C_4_mean/2);
  vector<lower = 0>[C_4_num] sigma_M_C_4_beta  = sigma_M_C_4_mean ./ square(sigma_M_C_4_mean/2);
  
}
parameters {
  
  vector[N] theta_C_4;
  
  vector[C_4_num] mu_M_C_4;
  vector<lower = 0>[C_4_num] gamma_M_C_4;
  vector<lower = 0>[C_4_num] sigma_M_C_4;
  
}
transformed parameters {
}
model {
  
  mu_M_C_4    ~ normal(mu_M_C_4_mean, mu_M_C_4_sigma);
  gamma_M_C_4 ~ gamma(gamma_M_C_4_alpha, gamma_M_C_4_beta);
  sigma_M_C_4 ~ gamma(sigma_M_C_4_alpha, sigma_M_C_4_beta);
  
  theta_C_4 ~ normal(0,1);
  
  add_C_measurement_lp(
    C_4_num,
    I_C_4_num,
    I_C_4_ind,
    M_C_4,
    mu_M_C_4,
    gamma_M_C_4,
    sigma_M_C_4,
    theta_C_4
  )
  
}
generated quantities {
}

