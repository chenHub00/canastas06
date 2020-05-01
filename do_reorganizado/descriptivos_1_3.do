* comparacion descriptivos


/*
#delimit ;
histogram ca_caloria [w=factor], kdens
title("Distribución del coeficiente de adecuación energética", color(gs1) size(medium))
note("Fuente: estimaciones del CONEVAL con base en la ENIGH 2006", color(gs5) size(medium) pos(5))
xtitle("Coeficiente de adecuación energética", color(gs2) size(medium))
ylabel(0 .2 .4 .6 .8 1,     gmax angle(horizontal))
ytitle("Densidad", color(gs2) size(medium)) ;

graph save Graph "C:\Users\vicen\Documents\Canastas\do_replica_local\distr_coef_adeq.gph"


tw (line y1_nac x1_nac in 2/82, lwidth(medthick) color(blue))
(line y1_rur x1_rur in 2/82, lwidth(medthick) color(green))
(line y1_urb x1_urb in 2/82, lwidth(medthick) color(orange)),

title("Coeficiente de adecuación por quintil móvil", color(gs1) size(small))
subtitle("Nacional, Rural y Urbano", color(gs5) size(vsmall))
note("Fuente: estimaciones del CONEVAL con base en la ENIGH 2006", color(gs5) size(vsmall) pos(5))
xtitle("Quintiles móviles", color(gs2) size(small)) 
ytitle("Coeficiente de adecuación", color(gs2) size(small))
yline(1, lcolor(red) lpattern(longdash_dot) lwidth(medium))  
xlabel(1 11 21 31 41 51 61 71 81) 
ylabel(0.8 1 1.2 1.2) 
legend(label(1 Nacional) label(2 Rural) label(3 Urbano));

graph save Graph "C:\Users\vicen\Documents\Canastas\do_replica_local\coef_adeq.gph"

*/
cd C:\Users\vicen\Documents\Canastas\

use "$temp\EPR_Canasta_06.dta",clear

su req_cal_rururb
histogram req_cal_rururb

graph save Graph "C:\Users\vicen\Documents\Canastas\comparacion\do_replica_16\req_cal_rururb16.gph"

graph save Graph "C:\Users\vicen\Documents\Canastas\comparacion\req_cal_rururb.gph"

gen lictpc = log(ictpc)
qnorm lictpc


#delimit ;
di in red "Nacional";
forvalues j = 1/81 { ;
sum ca_caloria [w=factor] if (percentil_nac>=(`j'+ 1) & percentil_nac<=(`j'+ 20)) ;
scalar ca`j'_nac = r(mean) ;
	             } ;
#delimit cr



su y1_rur 

hist ca_caloria 

su costo_cal [w=factor] 
su ictpc [w=factor]  
su ingcor [w=factor] 
ta tam_hog [w=factor] 

su gas_tot [w=factor] 
su gas_ddh_t [w=factor] 
su gas_fdh_t [w=factor] 

sum gas_ddh_t [w=factor] 
sum caloria_dh_t [w=factor]

sum caloria_fh_t [w=factor] 
sum gas_fdh_t [w=factor] 
sum costo_cal [w=factor] 

gen tpc_caloria = (caloria_dh_t + caloria_fh_t)/tot_integ;


gen ca_caloria = (caloria_dh_t + caloria_fh_t)/req_cal_rururb ;
sum ca_caloria;


