#delimit ;
************************************************************************;
* Paso 1.3: Selección del Estrato de Referencia
************************************************************************;

* Alimentos fuera del hogar: imputación del costo por decil  *                   ;
         
recode gas_ddh_t  gas_fdh_t (.=0);
gen gas_tot= gas_ddh_t + gas_fdh_t;
sort ictpc;
xtile decil=ictpc [w=factor], nq(10);
tab decil [w=factor];

#delimit;
forvalues i = 1/10 { ;
sum gas_ddh_t [w=factor] if decil==`i'  ;
local gt_d`i' = r(sum) ;
sum caloria_dh_t [w=factor] if decil==`i' ;
local cc_d`i' = r(sum) ;
local k`i' = `cc_d`i''/`gt_d`i'' ;
di in red " k`i' ";
} ;

scalar k_d1 = `k1'/`k1' ;
scalar k_d2 = `k1'/`k2' ;
scalar k_d3 = `k1'/`k3' ;
scalar k_d4 = `k1'/`k4' ;
scalar k_d5 = `k1'/`k5' ;
scalar k_d6 = `k1'/`k6' ;
scalar k_d7 = `k1'/`k7' ;
scalar k_d8 = `k1'/`k8' ;
scalar k_d9 = `k1'/`k9' ;
scalar k_d10 = `k1'/`k10' ;
di in red "06";
scalar list ;


di in red "Costo por calorías consumidas fuera del hogar por decil 
de ingreso corriente" ;

gen cto_Conev_06= k_d10	if decil==	10	;
replace cto_Conev_06	=	k_d9	if decil==	9	;
replace cto_Conev_06	=	k_d8 if decil==	8	;
replace cto_Conev_06	=	k_d7 if decil==	7	;
replace cto_Conev_06	=	k_d6	if decil==	6	;
replace cto_Conev_06	=	k_d5	if decil==	5	;
replace cto_Conev_06	=	k_d4	if decil==	4	;
replace cto_Conev_06	=	k_d3	if decil==	3	;
replace cto_Conev_06	=	k_d2	if decil==	2	;
replace cto_Conev_06	=	k_d1	if decil==	1	;
tabstat cto_Conev_06, by(decil);

di in red "Calorías consumidas fuera del hogar" ; 
gen caloria_fh_t = (gas_fdh_t/(cto_Conev_06*costo_cal)) ;
recode caloria_fh_*  (.=0) ;

di in red "Calorias y nutrientes per capita" ;
gen tpc_caloria = (caloria_dh_t + caloria_fh_t)/tam_hog ;

di in red "Coeficiente de Adecuación Energética (CA)" ;
sort folio ;

merge folio using "$bases\requerimientos_rururb.dta" ;
tab _merge ;
keep if _merge==3 ;
drop _merge ;

gen ca_caloria = (caloria_dh_t + caloria_fh_t)/req_cal_rururb ;
 recode ca_caloria (0=.);
sum ca_caloria;

di in red "Se eliminan los valores atípicos de adecuación calórica";
drop if ca_caloria>4;


*Gráficar el coeficiente de adecuación;

histogram ca_caloria [w=factor], kdens
title("Distribución del coeficiente de adecuación energética", color(gs1) size(medium))
note("Fuente: estimaciones del CONEVAL con base en la ENIGH 2006", color(gs5) size(medium) pos(5))
xtitle("Coeficiente de adecuación energética", color(gs2) size(medium))
ylabel(0 .2 .4 .6 .8 1,     gmax angle(horizontal))
ytitle("Densidad", color(gs2) size(medium)) ;

di in red "Percentiles nacional, rural y urbano de ingreso corriente per-cápita";
sort ictpc;
xtile percentil_nac=ictpc   [w=factor], nq(100); 
sort ictpc;
xtile percentil_urb=ictpc   if rururb==0 [w=factor], nq(100);
sort ictpc;
xtile percentil_rur=ictpc   if rururb==1 [w=factor], nq(100);


di in red "Gráfica del Coef. de Adecuación por quintiles móviles de ingreso" ;

di in red "Nacional";
forvalues j = 1/81 { ;
qui sum ca_caloria [w=factor] if (percentil_nac>=(`j'+ 1) & percentil_nac<=(`j'+ 20)) ;
scalar ca`j'_nac = r(mean) ;
	             } ;
gen y1_nac= . ;
gen x1_nac=_n ;

forvalues k = 1/81{ ;
local obs_nac= `k'+ 1 ;
replace y1_nac= ca`k'_nac in `obs_nac' ;
	            } ;


di in red "Rural";
forvalues j = 1/81 { ;
qui sum ca_caloria [w=factor] if (percentil_rur>=(`j'+ 1) & percentil_rur<=(`j'+ 20)) & rururb==1 ;
scalar ca`j'_rur = r(mean) ;
	             } ;
gen y1_rur= . ;
gen x1_rur=_n ;

forvalues k = 1/81{ ;
local obs_rur= `k'+ 1 ;
replace y1_rur= ca`k'_rur in `obs_rur' ;
	            } ;

				
di in red "Urbano";
forvalues j = 1/81 { ;
qui sum ca_caloria [w=factor] if (percentil_urb>=(`j'+ 1) & percentil_urb<=(`j'+ 20)) & rururb==0 ;
scalar ca`j'_urb= r(mean) ;
	             } ;
gen y1_urb= . ;
gen x1_urb=_n ;

forvalues k = 1/81{ ;
local obs_urb= `k'+ 1 ;
replace y1_urb= ca`k'_urb in `obs_urb' ;
	            } ;


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

scalar list;

* Niveles de los Estratos Poblacionales de Referencia;

di in red "Nacional llega en 45, Rural en 32 y Urbano en 41";


save "$EPR_CanastaDTA", replace;

