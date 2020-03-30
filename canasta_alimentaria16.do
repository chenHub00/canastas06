#delimit ;
clear ;
set mem 500m ;
set more off ;
scalar drop _all;
cap log close;


**************************************************************************;
*
*    PROGRAMA DE CÁLCULO PARA LA CONSTRUCCIÓN DE LAS LÍNEAS DE BIENESTAR;
*
**************************************************************************;

*Para cambiar estas ubicaciones, se modifican los siguientes
globals; 


capture close;
log using "$log\canastas2016.smcl", replace;


*El siguiente programa de cálculo cuenta con dos principales procesos:
* Paso 1: Construcción de la canasta básica alimentaria
* Paso 2: Construcción de la canasta básica no alimentaria
************************************************************************
*     
*      CONSTRUCCIÓN DE LA CANASTA BÁSICA ALIMENTARIA
*
************************************************************************

* Paso 1.1: Construcción de requerimientos energéticos por hogar *         
          
* Referencias: 
*	[1] CEPAL (2007) Principios y aplicación de las nuevas necesidades de energía según el 
*	Comité de Expertos FAO/OMS 2004. Estudios estadísticos y prospectivos # 56. 
*	[2] Bourges, Héctor, Casanueva, Esther, Rosado, Jorge L., 
* 	Recomendaciones de Ingestión de Nutrimentos para la Población Mexicana, 
*	Bases Fisiológicas, Tomo 1, Editorial Médica Panamericana, 
*	Instituto Danone, México, D.F. 2005;

*Unir bases de población y concentrado;

use "$poblacionDTA", clear ; 
sort folio;
save, replace;

use "$concentradoDTA", clear ; 
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
keep folio hog rururb;
sort folio;
merge folio using "$poblacionDTA";
gen parent=substr(parentesco,1,1);
destring parent, replace;
drop if parent==4;
drop if parent==7;
keep folio hog rururb edad sexo;

*Requerimientos energéticos;
destring edad sexo, replace;
di in red "Requerimiento energetico por hogar rural y Urbano" ;

* REQUERIMIENTOS DE NUTRIENTES RURAL Y URBANO;
do "$do\requerimientos_rururb2016.do";

sort folio ;
save "$bases\requerimientos_rururb.dta", replace ;

* APORTES BASADOS EN GASTO Y NO MONETARIO;
do "$do\alim_aportes2016";

di in red "Se une la base de gasto monetario y no-monetario" ;

use  "$alim_g_aportesDTA", replace ;
sort folio ;
merge folio using "$alim_n_aportesDTA" ;
tab _merge ;
drop _merge ;
recode *_g *_n (.=0) ;


di in red "Consumo energético total diario dentro del hogar" ;
gen caloria_dh_t = (caloria_dh_g + caloria_dh_n)/7 ;


di in red "Gasto diario total, dentro y fuera del hogar" ;

gen gas_dh_t =  (gas_tri_g + gas_tri_n)/90 ;
gen gas_ddh_t = (gas_tri_d_g + gas_tri_d_n)/90 ;
gen gas_fdh_t = (gas_tri_f_g + gas_tri_f_n)/90 ;


di in red "Alimentos consumidos fuera del hogar diarios" ;

gen alim_fue_t = (alim_fue_g + alim_fue_n)/7 ;
keep folio *_t ;
sort folio ;
save "$temp\consumo_Aportes_16.dta", replace ;


use "$concentradoDTA", clear ;
rename hog factor ;
keep folio factor tam_hog estrato ingcor ;
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
sort folio ;
merge folio using "$temp\consumo_Aportes_16.dta" ;
tab _merge ;
keep if _merge==3 ;
drop _merge ;


di in red "Costo por calorías y nutrientes dentro del hogar" ;

gen costo_cal = (gas_ddh_t/caloria_dh_t) ;
recode costo_* (.=0) ;
drop if costo_cal==0;
gen ictpc= (ingcor/tam_hog) ;
sort folio ;


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

************************************************************************;
* Paso 1.4: Construcción de la canasta básica alimentaria a partir 
* del estrato poblacional de referencia rural y urbano* ;     
************************************************************************;
      
 *Selección del estrato poblacional de referencia (EPR) Urbano;
	  
di in red "Selección del estrato poblacional de referencia (EPR) Urbano";

use "$EPR_CanastaDTA", clear;
keep if percentil_urb>=41 & percentil_urb<=60;


di in red "Total hogares y personas en el EPR"; 
gen uno=1;
sum uno [w=factor];
gen tot_hog=r(sum);
sum tam_hog [w=factor];
gen tot_pers=r(sum);


di in red "Calorías fuera del hogar promedio per cápita 
consumidas por el EPR";

gen caloria_fh_pc=caloria_fh_t/tam_hog;
sum caloria_fh_pc [w=factor];
gen cal_fh_prom=r(mean);
sum cal_fh_prom;
drop caloria_fh_pc;
sort folio;
save  "$temp\Urbano_f.dta", replace;
 
 
 *Selección del estrato poblacional de referencia (EPR) Rural;
 
di in red "Selección del estrato poblacional de referencia (EPR) Rural "; 

use "$EPR_CanastaDTA", clear;
keep if percentil_rur>=32 & percentil_rur<=51;


di in red "Total hogares y personas en el EPR"; 
gen uno=1;
sum uno [w=factor];
gen tot_hog=r(sum);
sum tam_hog [w=factor];
gen tot_pers=r(sum);


di in red "Calorías fuera del hogar promedio per cápita 
consumidas por el EPR";

gen caloria_fh_pc=caloria_fh_t/tam_hog;
sum caloria_fh_pc [w=factor];
gen cal_fh_prom=r(mean);
sum cal_fh_prom;
drop caloria_fh_pc;
sort folio;
save  "$temp\Rural_f.dta", replace;


*Limpieza de bases de datos (gasto y no-monetario);

di in red "Limpieza de las bases de gasto y no-monetario para el análisis del 
			consumo del EPR";

*Abrir base de gastos;
use "$gastoDTA", clear;
gen base=1;
gen cvealim=substr(clave,1,1);
keep if cvealim=="A";
drop if cantidad==0;
drop if  (clave>="A210" & clave<="A214") | (clave>="A223" & clave<="A242") ;
sort folio;
save "$temp\gasto_CANASTA_EPR.dta", replace;


*Abrir base no-monetaria;
use "$nomonetarioDTA", clear;
gen cvealim=substr(clave,1,1);
keep if cvealim=="A";
drop if cantidad==0;
sort folio;
gen base=2;


di in red "Se une gasto y no-monetario";
append using "$temp\gasto_CANASTA_EPR.dta";
tab base,m;
drop base;


di in red "Se excluyen las siguientes claves:

1) Gastos relacionados con la preparación de alimentos: A210 y A211, 
2) Alimentos y/o bebidas en paquete: A212,
3) Alimento para animales: A213 y A214,
4) Bebidas Alcohólicas: A223 a A238
5) Tabaco: A239, A240 y A241
6) Despensa de alimentos que otorgan organizaciones privadas o de gobierno: A242" ;

drop if  (clave>="A210" & clave<="A214") | (clave>="A223" & clave<="A242") ;


*Se obtiene una base con información monetaria y no menetaria;
di in red "Cantidad total y gasto trimestral total por hogar";

collapse (sum) cantidad gas_tri, by(folio clave);
 sort folio;
save "$temp\monynomon_CANASTA_EPR.dta", replace;


*Unión de bases;


*EPR Urbano;
di in red "Se une la base de monetario y no monetario con la base generada para el 
EPR Urbano";

merge folio using "$temp\Urbano_f.dta";
tab _merge;

di in red "Se eliminan los hogares que no forman parte del EPR Urbano";

keep if _merge==3;
drop _merge;
save "$temp\Urbano_f_EPR_CANASTA.dta", replace;
clear;


*EPR Rural;
use "$temp\monynomon_CANASTA_EPR.dta", clear;
sort folio;


di in red "Se une la base de monetario y no monetario con la base generada para el 
EPR Rural";

merge folio using "$temp\Rural_f.dta";
tab _merge;

di in red "Se eliminan los hogares que no forman parte del EPR Rural";

keep if _merge==3;
drop _merge;
save "$temp\Rural_f_EPR_CANASTA.dta", replace;
