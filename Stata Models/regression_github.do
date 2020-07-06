clear all
set more off

cd "C:\dir"
import delimited "C:\dir\chicagodatabase1705.csv"



gen assault_sig_drop = assault<0 & assault_sig==1
gen robbery_sig_drop = robbery<0 & robbery_sig==1
gen burglary_sig_drop = burglary<0 & burglary_sig==1
gen narcotics_sig_drop = narcotics<0 & narcotics_sig==1
gen n_violent_19div100=n_violent_19/100
gen covid_rate_x1000 = covid_cases_rate10k*10


*** firth crime context

firthlogit burglary_sig_drop burglary_2019 n_violent_19 neighborhood_safety__1618 has_police, or
estimates store m1, title(Burglary)
firthlogit assault_sig_drop assault_2019 n_violent_19 neighborhood_safety__1618 has_police, or
estimates store m2, title(Assault)
firthlogit narcotics_sig_drop narcotics_2019 n_violent_19 neighborhood_safety__1618 has_police, or
estimates store m3, title(Narcotics)
firthlogit robbery_sig_drop robbery_2019 n_violent_19 neighborhood_safety__1618 has_police, or
estimates store m4, title(Robbery)

estout m1 m2 m3 m4, eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   nobase ///
   stats(N chi2 p, fmt(0 3))

esttab m1 m2 m3 m4  using "C:\dir\crime_models1705_2.rtf", eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   nobase ///
   stats(N chi2 p, fmt(0 3))   
*** firth socio-economic context 
firthlogit burglary_sig_drop crowded_housing__1216 vacant_housing__1216 income_diversity_1418  x_poverty_2018 total_population1000, or
estimates store m5, title(Burglary)
firthlogit assault_sig_drop crowded_housing__1216 vacant_housing__1216 income_diversity_1418  x_poverty_2018 total_population1000, or
estimates store m6, title(Assault)
firthlogit narcotics_sig_drop crowded_housing__1216 vacant_housing__1216 income_diversity_1418  x_poverty_2018 total_population1000, or
estimates store m7, title(Narcotics)
firthlogit robbery_sig_drop crowded_housing__1216 vacant_housing__1216 income_diversity_1418  x_poverty_2018 total_population1000, or
estimates store m8, title(Robbery)

estout m5 m6 m7 m8, eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   nobase ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   stats(N chi2 p, fmt(0 3))
esttab m5 m6 m7 m8  using "C:\dir\social_models1705.rtf", eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   nobase ///
   stats(N chi2 p, fmt(0 3))   
   
*** firth health and demographic
firthlogit burglary_sig_drop x65__2018 x_017 overall_health_status__1618 covid_cases_rate10k, or
estimates store m9, title(Burglary)
firthlogit assault_sig_drop x65__2018 x_017 overall_health_status__1618 covid_cases_rate10k, or
estimates store m10, title(Assault)
firthlogit narcotics_sig_drop x65__2018 x_017 overall_health_status__1618 covid_cases_rate10k, or
estimates store m11, title(Narcotics)
firthlogit robbery_sig_drop x65__2018 x_017 overall_health_status__1618 covid_cases_rate10k, or
estimates store m12, title(Robbery)

estout m9 m10 m11 m12, eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   nobase ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   stats(N chi2 p, fmt(0 3))
   
esttab m9 m10 m11 m12  using "C:\Users\dir\health_models1705_2.rtf", eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   nobase ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   stats(N chi2 p, fmt(0 3)) 
   
   
* joint effects
firthlogit burglary_sig_drop assault_sig_drop narcotics_sig_drop robbery_sig_drop, or
estimates store m13, title(Burglary)
firthlogit assault_sig_drop burglary_sig_drop narcotics_sig_drop robbery_sig_drop, or
estimates store m14, title(Assault)
firthlogit narcotics_sig_drop assault_sig_drop burglary_sig_drop robbery_sig_drop, or
estimates store m15, title(Narcotics)
firthlogit robbery_sig_drop assault_sig_drop burglary_sig_drop narcotics_sig_drop, or
estimates store m16, title(Robbery)

estout m13 m14 m15 m16, eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   nobase ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   stat( N chi2 p, fmt(0 3))

esttab m13 m14 m15 m16  using "C:\Users\dir\joint_models1705.rtf", eform cells(b(star fmt(3)) se(par fmt(3)))  ///
   legend label varlabels(_cons constant)           ///
   nobase ///
   starlevels(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
   stat( N chi2 p, fmt(0 3))
