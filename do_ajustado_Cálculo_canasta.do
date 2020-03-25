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


capture close
log using "$log\Construccin de Lneas de Bienestar.smcl", replace;


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

use "$enigh\poblacion06.dta", clear ; 
sort folio;
save, replace;

use "$enigh\concentrado06.dta", clear ; 
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
keep folio hog rururb;
sort folio;
merge folio using "$enigh\poblacion06.dta";
gen parent=substr(parentesco,1,1);
destring parent, replace;
drop if parent==4;
drop if parent==7;
keep folio hog rururb edad sexo;

*Requerimientos energéticos;
destring edad sexo, replace;
di in red "Requerimiento energetico por hogar rural y Urbano" ;

gen req_cal_rururb = . ;
replace req_cal_rururb = cond(sexo==1, 621, 523) if edad==0 & rururb==1 ;
replace req_cal_rururb = cond(sexo==1, 943, 864) if edad==1 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1129,1048) if edad==2 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1249,1154) if edad==3 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1359,1242) if edad==4 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1393,1280) if edad==5 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1497,1383) if edad==6 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1508,1493) if edad==7 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1704,1515) if edad==8 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1874,1748) if edad==9 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2031,1893) if edad==10 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2134,1997) if edad==11 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2313,2146) if edad==12 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2514,2255) if edad==13 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2735,2316) if edad==14 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2951,2352) if edad==15 & rururb==1;
replace req_cal_rururb = cond(sexo==1,3064,2417) if edad==16 & rururb==1;
replace req_cal_rururb = cond(sexo==1,3221,2444) if edad==17 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2981,2412) if (edad>=18 & edad<=29) & rururb==1 ;
replace req_cal_rururb = cond(sexo==1,2894,2333) if (edad>=30 & edad<=59) & rururb==1;
replace req_cal_rururb = cond(sexo==1,2408,2091) if (edad>=60 & edad<=99) & rururb==1;
replace req_cal_rururb = cond(sexo==1, 621, 523) if edad==0 & rururb==0 ;
replace req_cal_rururb = cond(sexo==1, 943, 864) if edad==1 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1129,1048) if edad==2 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1249,1154) if edad==3 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1359,1242) if edad==4 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1393,1280) if edad==5 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1497,1383) if edad==6 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1508,1493) if edad==7 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1704,1515) if edad==8 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1874,1748) if edad==9 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2031,1893) if edad==10 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2134,1997) if edad==11 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2313,2146) if edad==12 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2514,2255) if edad==13 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2735,2316) if edad==14 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2951,2352) if edad==15 & rururb==0;
replace req_cal_rururb = cond(sexo==1,3064,2417) if edad==16 & rururb==0;
replace req_cal_rururb = cond(sexo==1,3221,2444) if edad==17 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2617,2116) if (edad>=18 & edad<=29) & rururb==0 ;
replace req_cal_rururb = cond(sexo==1,2540,2047) if (edad>=30 & edad<=59) & rururb==0;
replace req_cal_rururb = cond(sexo==1,2113,1836) if (edad>=60 & edad<=99) & rururb==0;


recode req_* (.=0) ;

collapse (sum) req_*, by(folio) ;

sort folio ;
save "$bases\requerimientos_rururb.dta", replace ;

************************************************************************;
*Paso 1.2: Creación de la base de calorias y aportes; 
************************************************************************;


foreach i in "gasto" "nomonetario" { ;
local labe = substr("`i'",1,1) ;

di in red "----- Base de " "`i'" " -----" ;
use "$enigh\\`i'06.dta", clear ;
keep if (clave>="A001" & clave<="A247") ;

di in red "Se excluyen las siguientes claves y los alimentos con cantidad cero:
1) Sal: A191,
2) Gastos relacionados con la preparación de alimentos: A210 y A211, 
3) Despensas: A212,
4) Alimento para animales: A213 y A214,
5) Agua: A215 y
6) Tabaco: A239, A240 y A241" ;
drop if (clave=="A191") | (clave>="A210" & clave<="A215") | 
(clave>="A239" & clave<="A241") ;
drop if cantidad==0 ;


di in red "Alimentos consumidos dentro y fuera del hogar" ;

gen alim_fue = cond(clave>="A243" & clave<="A247",cantidad,0) ;
gen alim_den = cond(clave>="A001" & clave<="A242",cantidad,0) ;


di in red "Gasto trimestral dentro y fuera del hogar" ;

gen gas_tri_f = cond(alim_fue>0 & alim_fue!=.,gas_tri,0) ;
gen gas_tri_d = cond(alim_den>0 & alim_den!=.,gas_tri,0) ;

sort clave ;
merge clave using "$bases\Aportes.dta" ;
tab _merge ;
drop if _merge==2;
drop _merge ;

recode porcion cal (.=0) ;
collapse (mean) precio porcion cal 
     	   (sum) cantidad gas_tri* alim_*, by (folio clave) ;

di in red "Calorías consumidas dentro del hogar" ;

gen caloria_dh = (cal*porcion*cantidad*10) ;

collapse (sum) gas_tri* alim_* cantidad *_dh , by(folio) ;

foreach x in gas_tri gas_tri_f gas_tri_d alim_fue alim_den 
	    caloria_dh  { ;
	  rename `x' `x'_`labe' ;
	  } ;
compress ;
sort folio ;
save "$temp\alim_`labe'_Aportes_06.dta", replace ;
} ;


di in red "Se une la base de gasto monetario y no-monetario" ;

use  "$temp\alim_g_Aportes_06.dta", replace ;
sort folio ;
merge folio using "$temp\alim_n_Aportes_06.dta" ;
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
save "$temp\consumo_Aportes_06.dta", replace ;


use "$enigh\concentrado06.dta", clear ;
rename hog factor ;
keep folio factor tam_hog estrato ingcor ;
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
sort folio ;
merge folio using "$temp\consumo_Aportes_06.dta" ;
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


save "$temp\EPR_Canasta_06.dta", replace;




************************************************************************;
* Paso 1.4: Construcción de la canasta básica alimentaria a partir 
* del estrato poblacional de referencia rural y urbano* ;     
************************************************************************;
      
 *Selección del estrato poblacional de referencia (EPR) Urbano;
	  
di in red "Selección del estrato poblacional de referencia (EPR) Urbano";

use "$temp\EPR_Canasta_06.dta", clear;
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

use "$temp\EPR_Canasta_06.dta", clear;
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
use "$enigh\gasto06.dta", clear;
gen base=1;
gen cvealim=substr(clave,1,1);
keep if cvealim=="A";
drop if cantidad==0;
drop if  (clave>="A210" & clave<="A214") | (clave>="A223" & clave<="A242") ;
sort folio;
save "$temp\gasto_CANASTA_EPR.dta", replace;


*Abrir base no-monetaria;
use "$enigh\nomonetario06.dta", clear;
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

************************************************************************;
*Paso 1.5: Construcción de la canasta básica alimentaria rural y urbana;
************************************************************************;


****************************CANASTA RURAL*****************************;

scalar drop _all;
use "$temp\\Rural_f_EPR_CANASTA.dta", clear;

di in red "Se pondera la frecuencia, cantidad, gasto trimestral y 
calorías consumidas fuera del hogar 
con el factor de expansión por hogares";

gen freqq=1;
rename cantidad cantidad_ORIG;
rename gas_tri gas_tri_ORIG;
egen freq=sum(freqq*factor), by(clave);
egen cantidad=sum(cantidad_ORIG*factor), by(clave);
egen gas_tri=sum(gas_tri_ORIG*factor), by(clave);
egen cal_f=mean(caloria_fh_t*factor), by(folio);
egen cal_f_prom=mean(cal_f);

sort clave;

collapse (mean) cal_fh_prom tot_* freq cantidad gas_tri, by(clave);


di in red "Rubros de alimentos y bebidas de la ENIGH 2006";

gen rubros=1 if clave>="A001" & clave<="A006";
replace rubros=2 if  clave>="A007" & clave<="A018";
replace rubros=3 if  clave>="A019" & clave<="A020";
replace rubros=4 if  clave>="A021" & clave<="A024";
replace rubros=5 if  clave>="A025" & clave<="A037";
replace rubros=6 if  clave>="A038" & clave<="A046";
replace rubros=7 if  clave>="A047" & clave<="A056";
replace rubros=8 if  clave>="A057" & clave<="A061";
replace rubros=9 if  clave=="A062" ;
replace rubros=10 if  clave>="A063" & clave<="A065";
replace rubros=11 if  clave>="A066" & clave<="A067";
replace rubros=12 if  clave>="A068" & clave<="A070";
replace rubros=13 if  clave=="A071" ;
replace rubros=14 if  clave>="A072" & clave<="A074";
replace rubros=15 if  clave>="A075" & clave<="A081";
replace rubros=16 if  clave>="A082" & clave<="A088";
replace rubros=17 if  clave>="A089" & clave<="A092";
replace rubros=18 if  clave>="A093" & clave<="A094";
replace rubros=19 if  clave>="A095" & clave<="A096";
replace rubros=20 if  clave>="A097" & clave<="A100";
replace rubros=21 if  clave>="A101" & clave<="A104";
replace rubros=22 if  clave>="A105" & clave<="A106";
replace rubros=23 if  clave>="A107" & clave<="A132";
replace rubros=24 if  clave>="A133" & clave<="A136";
replace rubros=25 if  clave>="A137" & clave<="A141";
replace rubros=26 if  clave>="A142" & clave<="A143";
replace rubros=27 if  clave>="A144" & clave<="A146";
replace rubros=28 if  clave>="A147" & clave<="A170";
replace rubros=29 if  clave>="A171" & clave<="A172";
replace rubros=30 if  clave>="A173" & clave<="A175";
replace rubros=31 if  clave>="A176" & clave<="A177";
replace rubros=32 if  clave>="A178" & clave<="A179";
replace rubros=33 if  clave>="A180" & clave<="A182";
replace rubros=34 if  clave>="A183" & clave<="A194";
replace rubros=35 if  clave>="A195" & clave<="A197";
replace rubros=36 if  clave>="A198" & clave<="A202";
replace rubros=37 if  clave>="A203" & clave<="A204";
replace rubros=38 if  clave>="A205" & clave<="A209";
replace rubros=39 if  clave>="A210" & clave<="A211";
replace rubros=40 if  clave=="A212";
replace rubros=42 if  clave>="A215" & clave<="A222";
replace rubros=43 if  clave>="A223" & clave<="A238";
replace rubros=45 if  clave=="A242";
replace rubros=46 if  clave>="A243" & clave<="A247";


* Etiquetar rubros;
label define rubros
1 "Maíz "
2 "Trigo "
3 "Arroz "
4 "Otros cereales "
5 "Carne de res y ternera "
6 "Carne de cerdo "
7 "Carnes procesadas "
8 "Carne de pollo "
9 "Carnes procesadas de aves "
10 "Otras carnes "
11 "Pescados frescos "
12 "Pescados procesados "
13 "Otros pescados "
14 "Mariscos "
15 "Leche "
16 "Quesos "
17 "Otros derivados de la leche "
18 "Huevos "
19 "Aceites "
20 "Grasas "
21 "Tubérculos crudos o frescos "
22 "Tubérculos procesados "
23 "Verduras y legumbres frescas "
24 "Verduras y legumbres procesadas "
25 "Leguminosas "
26 "Leguminosas procesadas "
27 "Semilllas "
28 "Frutas frescas "
29 "Frutas procesadas "
30 "Azúcar y mieles "
31 "Café "
32 "Té "
33 "Chocolate "
34 "Especies y aderezos "
35 "Alimentos preparados para bebé "
36 "Alimentos preparados para consumir en casa "
37 "Alimentos diversos "
38 "Dulces y postres "
39 "Gastos relacionados con la elaboración de alimentos "
40 "Gastos en alimentos y/o bebidas en paquete "
42 "Bebidas no alcohólicas "
43 "Bebidas alcohólicas "
45 "Alimentos de organizaciones "
46 "Alimentos y bebidas consumidas fuera del hogar "
;
label value rubros rubros;

*Frecuencia del consumo de alimentos;
di in red "Porcentaje de la frecuencia de consumo de alimentos 
por rubros";

egen freq_rubros=sum(freq), by(rubros);
gen por_rubros=freq/freq_rubros;
gen por_rubros100=por_rubros*100;

di in red "Porcentaje del gasto en alimentos";
egen sum_gas=sum(gas_tri);
gen por_gas=gas_tri/sum_gas  if rubros!=46;
gen por_gas100=por_gas*100;


*Criterios;


*Criterio 1- Consumo de alimentos mayor al 10%;
di in red "Criterio 1: que el porcentaje de la frecuencia de 
consumo de alimentos con respecto a su rubro sea mayor al 10%";

keep if por_rubros100>=10  | clave=="A160" | clave=="A166" | 
clave=="A158"  | clave=="A154" | (clave>="A115" & clave<="A118");

*Criterio 2-Consumo de alimentos mayor al 0.5%;
di in red "Criterio 2: que el porcentaje del gasto de cada alimento 
con respecto al total sea mayor al 0.5%";
keep if por_gas100>=.5 | clave=="A160" | clave=="A166" | 
clave=="A158"  | clave=="A154" | (clave>="A115" & clave<="A118");

*Elimincación de claves;
di in red "Se eliminan del análisis Rural el chorizo y la longaniza,
 y los jugos y néctares envasados";
 
drop if  clave=="A049";
drop if  clave=="A218";
sort clave;

*Unión de bases;
di in red "Se agregan los aportes energéticos de los alimentos";
merge clave using "$bases\Aportes.dta" ;
tab _merge ;

keep if _merge==3 | _merge==1;
drop _merge ;

di in red "Cantidad diaria per-cápita";
gen cantidadpc_d=cantidad/(7*tot_pers);

di in red "Consumo en gramos diarios per-cápita";
gen consumo=cantidad*1000/(tot_pers*7);

*Normatividad de la CBA;
di in red "Normativización de la Canasta Básica Alimentaria:";
di in green "Inclusión de alimentos a partir de la Norma Oficial 
Mexicana NOM-043-SSA2-2005, Servicios básicos de salud. Promoción 
y educación para la salud en materia alimentaria. Criterios para 
brindar orientación.";

*Se escalan cantidades de algunos alimentos en el ámbito rural para 
ajustar el consumo a los requerimientos nutricionales de ingesta
de micronutrientes ;

replace consumo = 200   if clave=="A004";
replace consumo = 17 	if clave=="A025";
replace consumo = 13.6 	if clave=="A031";
replace consumo = 12.5 	if clave=="A034";
replace consumo = 25.6 	if clave=="A057";
replace consumo = 29.8 	if clave=="A059";
replace consumo = 109.2 if clave=="A075";
replace consumo = 30 	if clave=="A102";
replace consumo = 36.2 	if clave=="A112";
replace consumo = 61.6 	if clave=="A124";
replace consumo = 58.5 	if clave=="A137";
replace consumo = 20.6 	if clave=="A154";
replace cal     = 50 	if clave=="A154";
replace porcion = 0.62 	if clave=="A154";
replace consumo = 23.7 	if clave=="A158";
replace consumo = 22.8 	if clave=="A160";
replace consumo = 29.8 	if clave=="A166";
replace consumo = 18.33 if clave=="A173";

gen req_cal_Rural=2253.791;

di in red "Calorías";
gen calorias= ((cal*porcion*consumo)/100) ;
replace calorias=cal_fh_prom if clave=="A243";
sum calorias  ;
scalar Cal_esc=r(sum);
local Cal=Cal_esc*100/req_cal_Rural;

*Obtención del requerimiento energético Rural;
di in red "Dadas estas cantidades, se alcanza el `Cal' por ciento 
del requerimiento energético Rural";

di in green "Se escalan de forma homogénea las cantidades para 
alcanzar el requerimiento energético ";
scalar esc_cant=req_cal_Rural/(Cal_esc);
scalar list;

replace consumo=consumo*esc_cant if clave!="A202" | rubros!=46;

*Se elimina del análisis el café tostado soluble;
drop if  clave=="A177";

*Debido a la gran variedad de alimentos que se encuentran en la 
clave "A202", se decidió darle el mismo tratamiento de las 
comidas fuera del hogar;


di in red "Cálculo de la adecuación de la Canasta Rural al requerimiento energético";
gen calorias_esc= ((cal*porcion*consumo)/100) ;
replace calorias_esc=cal_fh_prom if clave=="A243";
replace calorias_esc=81.04532 if clave=="A202";

sum calorias_esc  ;
local Cal_Totales=r(sum);
local Pje_Calorias=`Cal_Totales'*100/req_cal_Rural;


di in red "Se agrupan las comidas fuera del hogar en un solo rubro";

replace nombre="Alimentos y bebidas consumidas fuera del hogar" if clave=="A243";

keep clave rubros nombre consumo calorias_esc;

rename calorias_esc calorias_r;
rename consumo consumo_r;
gen id_rururb=1;
 
sort clave;
save "$temp\Componentes_Canasta_Rural.dta", replace;



***************************CANASTA URBANA******************************;
scalar drop _all;
		
use "$temp\\Urbano_f_EPR_CANASTA.dta", clear;

gen freqq=1;
rename cantidad cantidad_ORIG;
rename gas_tri gas_tri_ORIG;

egen freq=sum(freqq*factor), by(clave);
egen cantidad=sum(cantidad_ORIG*factor), by(clave);
egen gas_tri=sum(gas_tri_ORIG*factor), by(clave);
egen cal_f=mean(caloria_fh_t*factor), by(folio);
egen cal_f_prom=mean(cal_f);

sort clave;

collapse (mean) cal_fh_prom tot_* freq cantidad gas_tri, by(clave);

gen rubros=1 if clave>="A001" & clave<="A006";
replace rubros=2 if  clave>="A007" & clave<="A018";
replace rubros=3 if  clave>="A019" & clave<="A020";
replace rubros=4 if  clave>="A021" & clave<="A024";
replace rubros=5 if  clave>="A025" & clave<="A037";
replace rubros=6 if  clave>="A038" & clave<="A046";
replace rubros=7 if  clave>="A047" & clave<="A056";
replace rubros=8 if  clave>="A057" & clave<="A061";
replace rubros=9 if  clave=="A062" ;
replace rubros=10 if  clave>="A063" & clave<="A065";
replace rubros=11 if  clave>="A066" & clave<="A067";
replace rubros=12 if  clave>="A068" & clave<="A070";
replace rubros=13 if  clave=="A071" ;
replace rubros=14 if  clave>="A072" & clave<="A074";
replace rubros=15 if  clave>="A075" & clave<="A081";
replace rubros=16 if  clave>="A082" & clave<="A088";
replace rubros=17 if  clave>="A089" & clave<="A092";
replace rubros=18 if  clave>="A093" & clave<="A094";
replace rubros=19 if  clave>="A095" & clave<="A096";
replace rubros=20 if  clave>="A097" & clave<="A100";
replace rubros=21 if  clave>="A101" & clave<="A104";
replace rubros=22 if  clave>="A105" & clave<="A106";
replace rubros=23 if  clave>="A107" & clave<="A132";
replace rubros=24 if  clave>="A133" & clave<="A136";
replace rubros=25 if  clave>="A137" & clave<="A141";
replace rubros=26 if  clave>="A142" & clave<="A143";
replace rubros=27 if  clave>="A144" & clave<="A146";
replace rubros=28 if  clave>="A147" & clave<="A170";
replace rubros=29 if  clave>="A171" & clave<="A172";
replace rubros=30 if  clave>="A173" & clave<="A175";
replace rubros=31 if  clave>="A176" & clave<="A177";
replace rubros=32 if  clave>="A178" & clave<="A179";
replace rubros=33 if  clave>="A180" & clave<="A182";
replace rubros=34 if  clave>="A183" & clave<="A194";
replace rubros=35 if  clave>="A195" & clave<="A197";
replace rubros=36 if  clave>="A198" & clave<="A202";
replace rubros=37 if  clave>="A203" & clave<="A204";
replace rubros=38 if  clave>="A205" & clave<="A209";
replace rubros=39 if  clave>="A210" & clave<="A211";
replace rubros=40 if  clave=="A212";
replace rubros=42 if  clave>="A215" & clave<="A222";
replace rubros=43 if  clave>="A223" & clave<="A238";
replace rubros=45 if  clave=="A242";
replace rubros=46 if  clave>="A243" & clave<="A247";


* Etiquetar rubros;
label define rubros
1 "Maíz "
2 "Trigo "
3 "Arroz "
4 "Otros cereales "
5 "Carne de res y ternera "
6 "Carne de cerdo "
7 "Carnes procesadas "
8 "Carne de pollo "
9 "Carnes procesadas de aves "
10 "Otras carnes "
11 "Pescados frescos "
12 "Pescados procesados "
13 "Otros pescados "
14 "Mariscos "
15 "Leche "
16 "Quesos "
17 "Otros derivados de la leche "
18 "Huevos "
19 "Aceites "
20 "Grasas "
21 "Tubérculos crudos o frescos "
22 "Tubérculos procesados "
23 "Verduras y legumbres frescas "
24 "Verduras y legumbres procesadas "
25 "Leguminosas "
26 "Leguminosas procesadas "
27 "Semilllas "
28 "Frutas frescas "
29 "Frutas procesadas "
30 "Azúcar y mieles "
31 "Café "
32 "Té "
33 "Chocolate "
34 "Especies y aderezos "
35 "Alimentos preparados para bebé "
36 "Alimentos preparados para consumir en casa "
37 "Alimentos diversos "
38 "Dulces y postres "
39 "Gastos relacionados con la elaboración de alimentos "
40 "Gastos en alimentos y/o bebidas en paquete "
42 "Bebidas no alcohólicas "
43 "Bebidas alcohólicas "
45 "Alimentos de organizaciones "
46 "Alimentos y bebidas consumidas fuera del hogar "
;
label value rubros rubros;


*Frecuencia del consumo de alimentos;
di in red "Porcentaje de la frecuencia de consumo de alimentos 
por rubros";
egen freq_rubros=sum(freq), by(rubros);
gen por_rubros=freq/freq_rubros;
gen por_rubros100=por_rubros*100;

di in red "Porcentaje del gasto en alimentos";
egen sum_gas=sum(gas_tri);
gen por_gas=gas_tri/sum_gas;
gen por_gas100=por_gas*100;

*Criterio 1-Consumo de alimentos mayor al 10%;

di in red "Criterio 1: que el porcentaje de la frecuencia de 
consumo de alimentos con respecto a su rubro sea mayor al 10%";

keep if por_rubros100>=10 | clave=="A009" | clave=="A019" | 
clave=="A160" | clave=="A166"  | clave=="A066" | clave=="A177"  |
clave=="A154" | (clave>="A115" & clave<="A118");

*Criterio 2-Consumo de alimentos mayor al 0.5%;

di in red "Criterio 2: que el porcentaje del gasto de 
cada alimento con respecto al total sea mayor al 0.5%";

keep if por_gas100>=.5  | clave=="A009" | clave=="A019" | 
clave=="A160" | clave=="A166"  | clave=="A066" | clave=="A177" |
clave=="A154" | (clave>="A115" & clave<="A118");

*Elimincación de claves;
di in red "Se eliminan del análisis Urbano chorizo de pollo, jamón y nugget";
drop if clave=="A062";


*Unión de bases;
sort clave;
merge clave using "$bases\Aportes.dta" ;

tab _merge ;
keep if _merge==3 | _merge==1;
drop _merge ;

di in red "Cantidad diaria per-cápita";
gen cantidadpc_d=cantidad/(7*tot_pers);

di in red "Consumo en gramos diarios per-cápita";
gen consumo=cantidad*1000/(tot_pers*7);


*Normatividad de la CBA;
di in red "Normativización de la Canasta Básica Alimentaria:";
di in green "Inclusión de alimentos a partir de la Norma Oficial 
Mexicana NOM-043-SSA2-2005, Servicios básicos de salud. Promoción 
y educación para la salud en materia alimentaria. Criterios para 
brindar orientación.";


*Se escalan cantidades de algunos alimentos para ajustar las 
recomendaciones nutricionales de ingesta de micronutrientes;
replace consumo = 25.5     if clave=="A012";
replace consumo = 33.5 	   if clave=="A013";
replace consumo = 20.67863 if clave=="A025";
replace consumo = 13.63469 if clave=="A034";
replace consumo = 19.9	   if clave=="A042";
replace consumo = 43.8 	   if clave=="A102";
replace consumo = 41.5 	   if clave=="A112";
replace consumo = 61.8 	   if clave=="A124";
replace consumo = 49.6 	   if clave=="A137";
replace consumo = 25.5 	   if clave=="A154";
replace cal     = 50 	   if clave=="A154";
replace porcion = 0.62 	   if clave=="A154";
replace consumo = 29.3     if clave=="A158";
replace consumo = 28.1 	   if clave=="A160";
replace consumo = 34 	   if clave=="A166";
replace consumo = 200 	   if clave=="A075";
replace consumo = 55 	   if clave=="A218";

gen req_cal_Urbano=2093.941;

di in red "Calorías";
gen calorias= ((cal*porcion*consumo)/100) ;
replace calorias=cal_fh_prom if clave=="A243";
sum calorias  ;
scalar Cal_esc=r(sum);
local Cal=Cal_esc*100/req_cal_Urbano;

*Obtención del requerimiento energético Urbano;
di in red "Dadas estas cantidades, se alcanza el `Cal' por ciento 
del requerimiento energético Urbano";


di in green "Se escalan de forma homogénea las cantidades para 
alcanzar el requerimiento energético ";
scalar esc_cant=req_cal_Urbano/(Cal_esc);
scalar list;

replace consumo=consumo*esc_cant if clave!="A202" | rubros!=46;

di in red "Se elimina del análisis el café tostado soluble";
drop if  clave=="A177";

*Debido a la gran variedad de alimentos que se encuentran en 
la clave "A202", se decidió darle el mismo tratamiento de las 
comidas fuera del hogar;

di in red "Cálculo de la adecuación de la Canasta Urbana al 
requerimiento energético";
gen calorias_esc= ((cal*porcion*consumo)/100) ;
replace calorias_esc=cal_fh_prom if clave=="A243";
replace calorias_esc=160.57 if clave=="A202";

format  calorias_esc  consumo %9.2f;
sum calorias_esc  ;
local Cal_Totales=r(sum);
local Pje_Calorias=`Cal_Totales'*100/req_cal_Urbano;

replace nombre="Agua embotellada" if clave=="A215";
di in red "Se agrupan las comidas fuera del hogar en un solo rubro";
replace nombre="Alimentos y bebidas consumidas fuera del hogar" if clave=="A243";

keep clave rubros nombre consumo calorias_esc;

rename calorias_esc calorias_u;
rename consumo consumo_u;
gen id_rururb=0;
 
sort clave;

save "$temp\Componentes_Canasta_Urbana.dta", replace;


************************************************************************;
*Paso 1.6: Valoración monetaria CBA;
************************************************************************;

*Generar base de precios rural y urbana;

di in red "Se genera una base de precios rural y otra urbana";
use "$enigh\concentrado06.dta", replace;
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
keep folio rururb hog;
rename hog factor;
sort folio;
save "$temp\Identificador rururb_06.dta", replace;

use "$enigh\gasto06.dta", clear;
gen base=1;
append using "$enigh\nomonetario06.dta";
gen cvealim=substr(clave,1,1);
keep if cvealim=="A";
drop if cantidad==0;
drop if  (clave>="A210" & clave<="A214") | (clave>="A223" & clave<="A242") ;

sort folio;
merge folio using "$temp\Identificador rururb_06.dta";
tab _merge;
keep if _merge==3;
gen precio_r=gasto/cantidad if rururb==1;
gen precio_u=gasto/cantidad if rururb==0;
drop if precio_r==0;
drop if precio_u==0;
save "$temp\preciosrururb.dta", replace;
drop _merge;
sort clave;
merge clave using "$temp\Componentes_Canasta_Urbana.dta";
tab _merge;
rename _merge m_u;
sort clave;
merge clave using "$temp\Componentes_Canasta_Rural.dta";
tab _merge;
rename _merge m_r;

gen precio_mg_u=0 if rururb==0;

*Calcular media geométrica;

*Urbana;
gen clave_alim=real(substr(clave,2,3));
di in red "Se calcula la media geométrica del precio de todos los bienes urbanos";
forvalues i=1/247 { ;
qui ameans precio_u  if clave_alim==`i'  ;
replace precio_mg_u=r(mean_g) if  clave_alim==`i' ;
};


gen precio_mg_r=0 if rururb==1;


*Rural;
di in red "Se calcula la media geométrica del precio de todos los bienes rurales";
forvalues i=1/247 { ;
qui ameans precio_r  if clave_alim==`i'  ;
replace precio_mg_r=r(mean_g) if  clave_alim==`i' ;
};

sort clave;
merge clave using "$bases\Deflactores.dta";
tab _merge;
keep if _merge==3 | _merge==1;
drop _merge;
#delimit;



gen precio_r_08=precio_mg_r*def;
gen precio_u_08=precio_mg_u*def;



collapse (mean)  precio_* consumo_* cal*, by(clave nombres);
di in red "Se le aplica a los precios el deflactor para que estén en 
términos de agosto 2008";


*Tratamiento Chiles;
sum consumo_u if (clave>="A115" & clave<="A118");
local consumo_chiles_u=r(sum);
sum calorias_u if (clave>="A115" & clave<="A118");
local calorias_chiles_u=r(sum);

sum precio_mg_u if (clave>="A115" & clave<="A118");
local precio_chiles_u=r(mean);

sum consumo_r if (clave>="A115" & clave<="A118");
local consumo_chiles_r=r(sum);
sum calorias_r if (clave>="A115" & clave<="A118");
local calorias_chiles_r=r(sum);
sum precio_mg_r if (clave>="A115" & clave<="A118");
local precio_chiles_r=r(mean);

sum precio_r_08 if (clave>="A115" & clave<="A118");
local precio_chiles_r_08=r(mean);
sum precio_u_08 if (clave>="A115" & clave<="A118");
local precio_chiles_u_08=r(mean);

*Nos quedamos con la clave A115 que ya tiene la información agregada de chiles;
drop if (clave>="A116" & clave<="A118");
replace consumo_u=`consumo_chiles_u' if clave=="A115";
replace calorias_u=`calorias_chiles_u' if clave=="A115";
replace precio_mg_u=`precio_chiles_u' if clave=="A115";
replace consumo_r=`consumo_chiles_r' if clave=="A115";
replace calorias_r=`calorias_chiles_r' if clave=="A115";
replace precio_mg_r=`precio_chiles_r' if clave=="A115";

replace precio_r_08=`precio_chiles_r_08' if clave=="A115";
replace precio_u_08=`precio_chiles_u_08' if clave=="A115";

drop if consumo_u==. & consumo_r==.;

*Generación del Costo Rural y Urbano;
gen costo_r=(precio_r_08*consumo_r/1000);
gen costo_u=(precio_u_08*consumo_u/1000);

gen costo_r_06=(precio_mg_r*consumo_r/1000);
gen costo_u_06=(precio_mg_u*consumo_u/1000);

sum costo_r;
gen CBA_RURAL= r(sum)*30;
sum costo_u;
gen CBA_URBANA= r(sum)*30;
sum costo_r_06;
gen CBA_RURAL_06= r(sum)*30;
sum costo_u_06;
gen CBA_URBANA_06= r(sum)*30;

*Dar formato de variables;
format  CBA_RURAL CBA_URBANA CBA_RURAL_06 CBA_URBANA_06 %9.2f;
list CBA_RURAL CBA_URBANA  CBA_RURAL_06 CBA_URBANA_06 in 1;

format precio_* consumo* costo* calori* %9.1f; 
format costo* %9.2f; 


replace precio_u_08=. if clave>="A243";
replace precio_r_08=. if clave>="A243";
replace nombre="Leche de vaca, pasteurizada, entera, light" if clave=="A075";
replace nombre="Otros alimentos preparados" if clave=="A202";
replace nombre="Alimentos y bebidas consumidas fuera del hogar" if clave>="A243";

*Canastas Alimentarias;

*Urbana;
di in green "Canasta Básica Alimentaria Urbana";
list clave nombre precio_u_08 consumo_u costo_u calorias_u if consumo_u!=., 
sum(consumo_u costo_u calorias_u)  N(precio_u_08) separator(0)  subvarname t div  labv(nombre);

*Rural;
di in green "Canasta Básica Alimentaria Rural";
list clave nombre precio_r_08 consumo_r costo_r calorias_r if consumo_r!=., 
sum(consumo_r costo_r calorias_r)  N(precio_r_08) separator(0)  subvarname t div  labv(nombre);

save "$temp\CANASTAS.dta", replace;


************************************************************************;
* 
*        CONSTRUCCIÓN DE LA CANASTA BÁSICA NO ALIMENTARIA(CBNA);
*
************************************************************************;
clear;

di in red "Se utilizan los Estratos Poblacionales de Referencia de la Canasta
Básica Alimentaria";

*Abrir bases y dejar sólo las variableas a utilizar;

*Urbano;
use "$temp\\Urbano_f_EPR_CANASTA.dta", clear;

keep folio factor tam_hog ict  tot_hog tot_pers ;
sort folio;
save "$temp\EPR_CBNA_Urbano.dta", replace;

*Rural;
use "$temp\\Rural_f_EPR_CANASTA.dta";
keep folio factor tam_hog ict  tot_hog tot_pers ;
sort folio;
save "$temp\EPR_CBNA_Rural.dta", replace;


***********************************************************************************;
*Paso 2.1: Se deflactan todos los gastos monetarios y no monetarios.
***********************************************************************************;
*******************

*Abrir bases;

use "$enigh\gasto06.dta", clear;

append using "$enigh\nomonetario06.dta";

gen mon=1 if tipo_gas=="";
recode mon .=0;

#delimit;
gen decena=real(substr(folio,7,1));

*Definición de los deflactores;
*Rubro 1.1 semanal;
scalar d11w07	=	0.9844609	;
scalar d11w08	=	1.0000000	;
scalar d11w09	=	1.0329810	;
scalar d11w10	=	1.0431290	;
scalar d11w11	=	1.0336965	;

*Rubro 1.2 semanal;
scalar d12w07	=	0.9945895	;
scalar d12w08	=	1.0000000	;
scalar d12w09	=	0.9991202	;
scalar d12w10	=	0.9989091	;
scalar d12w11	=	0.9993842	;

*Rubro 2 trimestral;
scalar d2t05	=	0.9980605	;
scalar d2t06	=	0.9984439	;
scalar d2t07	=	0.9993801	;
scalar d2t08	=	1.0012110	;

*Rubro 3 mensual;
scalar d3m07	=	0.9974508	;
scalar d3m08	=	1.0000000	;
scalar d3m09	=	1.0015785	;
scalar d3m10	=	1.0085508	;
scalar d3m11	=	1.0329622	;

*Rubro 4.2 mensual;
scalar d42m07	=	0.9953644	;
scalar d42m08	=	1.0000000	;
scalar d42m09	=	1.0059547	;
scalar d42m10	=	1.0124654	;
scalar d42m11	=	1.0118058	;

*Rubro 4.2 trimestral;
scalar d42t05	=	0.9960396	;
scalar d42t06	=	0.9978015	;
scalar d42t07	=	1.0004397	;
scalar d42t08	=	1.0061400	;

*Rubro 4.1 semestral;
scalar d41s02	=	1.0026645	;
scalar d41s03	=	1.0021045	;
scalar d41s04	=	1.0020266	;
scalar d41s05	=	1.0026198	;

*Rubro 5.1 trimestral;
scalar d51t05	=	0.9939752	;
scalar d51t06	=	0.9970799	;
scalar d51t07	=	0.9999539	;
scalar d51t08	=	1.0032132	;

*Rubro 6.1.1 semanal;
scalar d611w07	=	0.9929616	;
scalar d611w08	=	1.0000000	;
scalar d611w09	=	1.0005707	;
scalar d611w10	=	1.0007196	;
scalar d611w11	=	1.0009181	;

*Rubro 6 mensual;
scalar d6m07	=	0.9965857	;
scalar d6m08	=	1.0000000	;
scalar d6m09	=	1.0016507	;
scalar d6m10	=	0.9998002	;
scalar d6m11	=	1.0019548	;

*Rubro 6 semestral;
scalar d6s02	=	0.9891271	;
scalar d6s03	=	0.9926674	;
scalar d6s04	=	0.9958950	;
scalar d6s05	=	0.9971953	;

*Rubro 7 mensual;
scalar d7m07	=	0.9993756	;
scalar d7m08	=	1.0000000	;
scalar d7m09	=	1.0175236	;
scalar d7m10	=	1.0184843	;
scalar d7m11	=	1.0197811	;

*Rubro 2.3 mensual;
scalar d23m07	=	0.9970873	;
scalar d23m08	=	1.0000000	;
scalar d23m09	=	0.9996172	;
scalar d23m10	=	0.9987101	;
scalar d23m11	=	1.0072734	;

*Rubro 2.3 trimestral;
scalar d23t05	=	0.9985825	;
scalar d23t06	=	0.9975117	;
scalar d23t07	=	0.9989015	;
scalar d23t08	=	0.9994424	;

*INPC semestral;
scalar dINPCs02	=	0.9936076	;
scalar dINPCs03	=	0.9947618	;
scalar dINPCs04	=	0.9973908	;
scalar dINPCs05	=	1.0005128	;

drop if gas_tri==0;
gen double gasm=gas_tri/3;

*Se excluyen del análisis los siguientes gastos: 
Mantenimiento, reparación, remodelación y ampliación de la vivienda: K037 a K044 
Vivienda y servicios de conservación: G001 a G006 y G012 a G019
Erogaciones financieras y de capital: Q001 a Q016
Gastos en regalos a personas ajenas al hogar (transferencias): T901 a T915
Bebidas alcohólicas y tabaco:


drop if (clave>="K037" & clave<="K044");
drop if (clave>="G001" & clave<="G006");
drop if (clave>="G012" & clave<="G019");
drop if (clave>="Q001" & clave<="Q016");
drop if (clave>="A223" & clave<="A241");
drop if (clave>="T901" & clave<="T915");



*Gasto en Alimentos deflactado;
gen gasdef=.;
gen ali_m=gasm if (clave>="A001" & clave<="A222") | 
(clave>="A242" & clave<="A247");
replace gasdef=ali_m/d11w08 if decena==0 & ali_m!=.;
replace gasdef=ali_m/d11w08 if decena==1 & ali_m!=.;
replace gasdef=ali_m/d11w08 if decena==2 & ali_m!=.;
replace gasdef=ali_m/d11w09 if decena==3 & ali_m!=.;
replace gasdef=ali_m/d11w09 if decena==4 & ali_m!=.;
replace gasdef=ali_m/d11w09 if decena==5 & ali_m!=.;
replace gasdef=ali_m/d11w10 if decena==6 & ali_m!=.;
replace gasdef=ali_m/d11w10 if decena==7 & ali_m!=.;
replace gasdef=ali_m/d11w10 if decena==8 & ali_m!=.;
replace gasdef=ali_m/d11w11 if decena==9 & ali_m!=.;

*Gasto en Alcohol y tabaco deflactado;
gen alta_m=gasm if (clave>="A223" & clave<="A241");
replace gasdef=alta_m/d12w08 if decena==0 & alta_m!=.;
replace gasdef=alta_m/d12w08 if decena==1 & alta_m!=.;
replace gasdef=alta_m/d12w08 if decena==2 & alta_m!=.;
replace gasdef=alta_m/d12w09 if decena==3 & alta_m!=.;
replace gasdef=alta_m/d12w09 if decena==4 & alta_m!=.;
replace gasdef=alta_m/d12w09 if decena==5 & alta_m!=.;
replace gasdef=alta_m/d12w10 if decena==6 & alta_m!=.;
replace gasdef=alta_m/d12w10 if decena==7 & alta_m!=.;
replace gasdef=alta_m/d12w10 if decena==8 & alta_m!=.;
replace gasdef=alta_m/d12w11 if decena==9 & alta_m!=.;

*Gasto en Vestido y calzado deflactado;
gen veca_m=gasm if (clave>="H001" & clave<="H072") | 
(clave>="H075" & clave<="H108");
replace gasdef=veca_m/d2t05 if decena==0 & veca_m!=.;
replace gasdef=veca_m/d2t05 if decena==1 & veca_m!=.;
replace gasdef=veca_m/d2t06 if decena==2 & veca_m!=.;
replace gasdef=veca_m/d2t06 if decena==3 & veca_m!=.;
replace gasdef=veca_m/d2t06 if decena==4 & veca_m!=.;
replace gasdef=veca_m/d2t07 if decena==5 & veca_m!=.;
replace gasdef=veca_m/d2t07 if decena==6 & veca_m!=.;
replace gasdef=veca_m/d2t07 if decena==7 & veca_m!=.;
replace gasdef=veca_m/d2t08 if decena==8 & veca_m!=.;
replace gasdef=veca_m/d2t08 if decena==9 & veca_m!=.;

*Gasto en Vivienda y servicios de conservación deflactado;
gen viv_m=gasm if (clave>="G001" & clave<="G011") | 
(clave>="G020" & clave<="G030");
replace gasdef=viv_m/d3m07 if decena==0 & viv_m!=.;
replace gasdef=viv_m/d3m07 if decena==1 & viv_m!=.;
replace gasdef=viv_m/d3m08 if decena==2 & viv_m!=.;
replace gasdef=viv_m/d3m08 if decena==3 & viv_m!=.;
replace gasdef=viv_m/d3m08 if decena==4 & viv_m!=.;
replace gasdef=viv_m/d3m09 if decena==5 & viv_m!=.;
replace gasdef=viv_m/d3m09 if decena==6 & viv_m!=.;
replace gasdef=viv_m/d3m09 if decena==7 & viv_m!=.;
replace gasdef=viv_m/d3m10 if decena==8 & viv_m!=.;
replace gasdef=viv_m/d3m10 if decena==9 & viv_m!=.;

*Gasto en Artículos de limpieza deflactado;
gen lim_m=gasm if (clave>="C001" & clave<="C024");
replace gasdef=lim_m/d42m07 if decena==0 & lim_m!=.;
replace gasdef=lim_m/d42m07 if decena==1 & lim_m!=.;
replace gasdef=lim_m/d42m08 if decena==2 & lim_m!=.;
replace gasdef=lim_m/d42m08 if decena==3 & lim_m!=.;
replace gasdef=lim_m/d42m08 if decena==4 & lim_m!=.;
replace gasdef=lim_m/d42m09 if decena==5 & lim_m!=.;
replace gasdef=lim_m/d42m09 if decena==6 & lim_m!=.;
replace gasdef=lim_m/d42m09 if decena==7 & lim_m!=.;
replace gasdef=lim_m/d42m10 if decena==8 & lim_m!=.;
replace gasdef=lim_m/d42m10 if decena==9 & lim_m!=.;

*Gasto en Cristalería y blancos deflactado;
gen cris_m=gasm if (clave>="I001" & clave<="I026");
replace gasdef=cris_m/d42t05 if decena==0 & cris_m!=.;
replace gasdef=cris_m/d42t05 if decena==1 & cris_m!=.;
replace gasdef=cris_m/d42t06 if decena==2 & cris_m!=.;
replace gasdef=cris_m/d42t06 if decena==3 & cris_m!=.;
replace gasdef=cris_m/d42t06 if decena==4 & cris_m!=.;
replace gasdef=cris_m/d42t07 if decena==5 & cris_m!=.;
replace gasdef=cris_m/d42t07 if decena==6 & cris_m!=.;
replace gasdef=cris_m/d42t07 if decena==7 & cris_m!=.;
replace gasdef=cris_m/d42t08 if decena==8 & cris_m!=.;
replace gasdef=cris_m/d42t08 if decena==9 & cris_m!=.;

*Gasto en Enseres domésticos y muebles deflactado;
gen ens_m=gasm if (clave>="K001" & clave<="K036");
replace gasdef=ens_m/d41s02 if decena==0 & ens_m!=.;
replace gasdef=ens_m/d41s02 if decena==1 & ens_m!=.;
replace gasdef=ens_m/d41s03 if decena==2 & ens_m!=.;
replace gasdef=ens_m/d41s03 if decena==3 & ens_m!=.;
replace gasdef=ens_m/d41s03 if decena==4 & ens_m!=.;
replace gasdef=ens_m/d41s04 if decena==5 & ens_m!=.;
replace gasdef=ens_m/d41s04 if decena==6 & ens_m!=.;
replace gasdef=ens_m/d41s04 if decena==7 & ens_m!=.;
replace gasdef=ens_m/d41s05 if decena==8 & ens_m!=.;
replace gasdef=ens_m/d41s05 if decena==9 & ens_m!=.;

*Gasto en Salud deflactado;
gen sal_m=gasm if (clave>="J001" & clave<="J072");
replace gasdef=sal_m/d51t05 if decena==0 & sal_m!=.;
replace gasdef=sal_m/d51t05 if decena==1 & sal_m!=.;
replace gasdef=sal_m/d51t06 if decena==2 & sal_m!=.;
replace gasdef=sal_m/d51t06 if decena==3 & sal_m!=.;
replace gasdef=sal_m/d51t06 if decena==4 & sal_m!=.;
replace gasdef=sal_m/d51t07 if decena==5 & sal_m!=.;
replace gasdef=sal_m/d51t07 if decena==6 & sal_m!=.;
replace gasdef=sal_m/d51t07 if decena==7 & sal_m!=.;
replace gasdef=sal_m/d51t08 if decena==8 & sal_m!=.;
replace gasdef=sal_m/d51t08 if decena==9 & sal_m!=.;

*Gasto en Transporte público deflactado;
gen tpub_m=gasm if (clave>="B001" & clave<="B007");
replace gasdef=tpub_m/d611w08 if decena==0 & tpub_m!=.;
replace gasdef=tpub_m/d611w08 if decena==1 & tpub_m!=.;
replace gasdef=tpub_m/d611w08 if decena==2 & tpub_m!=.;
replace gasdef=tpub_m/d611w09 if decena==3 & tpub_m!=.;
replace gasdef=tpub_m/d611w09 if decena==4 & tpub_m!=.;
replace gasdef=tpub_m/d611w09 if decena==5 & tpub_m!=.;
replace gasdef=tpub_m/d611w10 if decena==6 & tpub_m!=.;
replace gasdef=tpub_m/d611w10 if decena==7 & tpub_m!=.;
replace gasdef=tpub_m/d611w10 if decena==8 & tpub_m!=.;
replace gasdef=tpub_m/d611w11 if decena==9 & tpub_m!=.;

*Gasto en Transporte foráneo deflactado;
gen tfor_m=gasm if (clave>="M001" & clave<="M018") | 
(clave>="F010" & clave<="F017");
replace gasdef=tfor_m/d6s02 if decena==0 & tfor_m!=.;
replace gasdef=tfor_m/d6s02 if decena==1 & tfor_m!=.;
replace gasdef=tfor_m/d6s03 if decena==2 & tfor_m!=.;
replace gasdef=tfor_m/d6s03 if decena==3 & tfor_m!=.;
replace gasdef=tfor_m/d6s03 if decena==4 & tfor_m!=.;
replace gasdef=tfor_m/d6s04 if decena==5 & tfor_m!=.;
replace gasdef=tfor_m/d6s04 if decena==6 & tfor_m!=.;
replace gasdef=tfor_m/d6s04 if decena==7 & tfor_m!=.;
replace gasdef=tfor_m/d6s05 if decena==8 & tfor_m!=.;
replace gasdef=tfor_m/d6s05 if decena==9 & tfor_m!=.;

*Gasto en Comunicaciones deflactado;
gen com_m=gasm if (clave>="F001" & clave<="F009");
replace gasdef=com_m/d6m07 if decena==0 & com_m!=.;
replace gasdef=com_m/d6m07 if decena==1 & com_m!=.;
replace gasdef=com_m/d6m08 if decena==2 & com_m!=.;
replace gasdef=com_m/d6m08 if decena==3 & com_m!=.;
replace gasdef=com_m/d6m08 if decena==4 & com_m!=.;
replace gasdef=com_m/d6m09 if decena==5 & com_m!=.;
replace gasdef=com_m/d6m09 if decena==6 & com_m!=.;
replace gasdef=com_m/d6m09 if decena==7 & com_m!=.;
replace gasdef=com_m/d6m10 if decena==8 & com_m!=.;
replace gasdef=com_m/d6m10 if decena==9 & com_m!=.;

*Gasto en Educación y recreación deflactado;
gen edre_m=gasm if (clave>="E001" & clave<="E033") | 
(clave>="H073" & clave<="H074") | (clave>="L001" & 
clave<="L029") | (clave>="N003" & clave<="N005");
replace gasdef=edre_m/d7m07 if decena==0 & edre_m!=.;
replace gasdef=edre_m/d7m07 if decena==1 & edre_m!=.;
replace gasdef=edre_m/d7m08 if decena==2 & edre_m!=.;
replace gasdef=edre_m/d7m08 if decena==3 & edre_m!=.;
replace gasdef=edre_m/d7m08 if decena==4 & edre_m!=.;
replace gasdef=edre_m/d7m09 if decena==5 & edre_m!=.;
replace gasdef=edre_m/d7m09 if decena==6 & edre_m!=.;
replace gasdef=edre_m/d7m09 if decena==7 & edre_m!=.;
replace gasdef=edre_m/d7m10 if decena==8 & edre_m!=.;
replace gasdef=edre_m/d7m10 if decena==9 & edre_m!=.;


*Gasto en Cuidado personal deflactado;
gen cuip_m=gasm if (clave>="D001" & clave<="D026") | 
(clave=="H118");
replace gasdef=cuip_m/d23m07 if decena==0 & cuip_m!=.;
replace gasdef=cuip_m/d23m07 if decena==1 & cuip_m!=.;
replace gasdef=cuip_m/d23m08 if decena==2 & cuip_m!=.;
replace gasdef=cuip_m/d23m08 if decena==3 & cuip_m!=.;
replace gasdef=cuip_m/d23m08 if decena==4 & cuip_m!=.;
replace gasdef=cuip_m/d23m09 if decena==5 & cuip_m!=.;
replace gasdef=cuip_m/d23m09 if decena==6 & cuip_m!=.;
replace gasdef=cuip_m/d23m09 if decena==7 & cuip_m!=.;
replace gasdef=cuip_m/d23m10 if decena==8 & cuip_m!=.;
replace gasdef=cuip_m/d23m10 if decena==9 & cuip_m!=.;

*Gasto en Accesorios personales deflactado;
gen accp_m=gasm if (clave>="H109" & clave<="H117") | 
(clave=="H119");
replace gasdef=accp_m/d23t05 if decena==0 & accp_m!=.;
replace gasdef=accp_m/d23t05 if decena==1 & accp_m!=.;
replace gasdef=accp_m/d23t06 if decena==2 & accp_m!=.;
replace gasdef=accp_m/d23t06 if decena==3 & accp_m!=.;
replace gasdef=accp_m/d23t06 if decena==4 & accp_m!=.;
replace gasdef=accp_m/d23t07 if decena==5 & accp_m!=.;
replace gasdef=accp_m/d23t07 if decena==6 & accp_m!=.;
replace gasdef=accp_m/d23t07 if decena==7 & accp_m!=.;
replace gasdef=accp_m/d23t08 if decena==8 & accp_m!=.;
replace gasdef=accp_m/d23t08 if decena==9 & accp_m!=.;

*Gasto en Otros gastos y transferencias deflactado;
gen otr_m=gasm if (clave>="N001" & clave<="N002") | 
(clave>="N006" & clave<="N016") | (clave>="T901" & 
clave<="T914");
replace gasdef=otr_m/dINPCs02 if decena==0 & otr_m!=.;
replace gasdef=otr_m/dINPCs02 if decena==1 & otr_m!=.;
replace gasdef=otr_m/dINPCs03 if decena==2 & otr_m!=.;
replace gasdef=otr_m/dINPCs03 if decena==3 & otr_m!=.;
replace gasdef=otr_m/dINPCs03 if decena==4 & otr_m!=.;
replace gasdef=otr_m/dINPCs04 if decena==5 & otr_m!=.;
replace gasdef=otr_m/dINPCs04 if decena==6 & otr_m!=.;
replace gasdef=otr_m/dINPCs04 if decena==7 & otr_m!=.;
replace gasdef=otr_m/dINPCs05 if decena==8 & otr_m!=.;
replace gasdef=otr_m/dINPCs05 if decena==9 & otr_m!=.;

collapse (sum) cantidad gasdef, by(folio clave);
sort folio clave;
compress;
save "$temp\gastos mon_nomon.dta", replace;


*******************************************************************************;
* Paso 2.2: Selección de los bienes y servicios de la CBNA;
*******************************************************************************;
*Se seleccionó bienes y servicios considerando los siguientes criterios:  
*1.	Que los bienes mostraran una elasticidad ingreso menor a uno 1, ya que estos 
*   son clasificados en la teoría económica como bienes necesarios. 
*2.	Que sea percibido por la mayoría de la población como un bien o servicio necesario.
*3.	Que la participación del gasto en el bien con respecto al gasto total en el 
*   estrato de referencia sea mayor a la media de todos los bienes. ;


*Abrir base EPR de Canasta Básica No Alimentaria Rural y unirla con la base de gastos no monetarios;
use "$temp\EPR_CBNA_Rural.dta", clear;
sort folio;
merge folio using  "$temp\gastos mon_nomon.dta";
tab _merge;
keep if _merge==3;
drop _merge;
sort clave;

*Generar claves de la Canasta Básica No Alimentaria Rural;

gen claves_cbna=.;
replace claves_cbna=1 if clave=="B002" | clave=="B004" | clave=="B005" | clave=="B006" |
clave=="C001" | clave=="C002" | clave=="C003" | clave=="C005" | clave=="C006" | 
clave=="C008" | clave=="C009" | clave=="C010" | clave=="C011" | clave=="C012" | 
clave=="C013" | clave=="C015" | clave=="C017" | clave=="C018" | clave=="D001" | 
clave=="D003" | clave=="D004" | clave=="D005" | clave=="D007" | clave=="D009" |
clave=="D011" | clave=="D014" | clave=="D015" | clave=="D016" | clave=="D017" | 
clave=="D018" | clave=="D021" | clave=="D022" | clave=="E014" | clave=="E016" |
clave=="E020" | clave=="F001" | clave=="F002" | clave=="F003" | clave=="F005" |
clave=="F006" | clave=="G007" | clave=="G008" | clave=="G009" | clave=="G020" |
clave=="G029" ;
replace claves_cbna=1 if clave=="H001" | clave=="H003" | clave=="H004" | clave=="H005" |
clave=="H006" | clave=="H007" | clave=="H008" | clave=="H009" | clave=="H010" |
clave=="H011" | clave=="H012" | clave=="H015" | clave=="H016" | clave=="H017" |
clave=="H018" | clave=="H019" | clave=="H020" | clave=="H021" | clave=="H022" |
clave=="H023" | clave=="H024" | clave=="H025" | clave=="H026" | clave=="H029" |
clave=="H030" | clave=="H031" | clave=="H033" | clave=="H034" | clave=="H035" |
clave=="H036" | clave=="H037" | clave=="H038" | clave=="H039" | clave=="H040" |
clave=="H041" | clave=="H042" | clave=="H043" | clave=="H044" | clave=="H045" |
clave=="H046" | clave=="H047" | clave=="H049" | clave=="H050" | clave=="H051" |
clave=="H052" | clave=="H053" | clave=="H055" | clave=="H056" | clave=="H057" |
clave=="H058" | clave=="H059" | clave=="H061" | clave=="H062" | clave=="H063" |
clave=="H064" | clave=="H065" | clave=="H066" | clave=="H067" | clave=="H068" | 
clave=="H069" | clave=="H070" | clave=="H071" | clave=="H072" | clave=="H073" |
clave=="H075" | clave=="H076" | clave=="H077" | clave=="H078" | clave=="H079" |
clave=="H080" | clave=="H082" | clave=="H083" | clave=="H084" | clave=="H085" | 
clave=="H086" | clave=="H088" | clave=="H089" | clave=="H090" | clave=="H091" |
clave=="H092" | clave=="H094" | clave=="H095" | clave=="H096" | clave=="H097" | 
clave=="H098" | clave=="H100" | clave=="H101" | clave=="H102" | clave=="H103" | 
clave=="H104" | clave=="H106" | clave=="H107" | clave=="H108" | clave=="H109" |
clave=="H110" | clave=="H115" | clave=="H116" ;
replace claves_cbna=1 if clave=="I001" | clave=="I002" |
clave=="I003" | clave=="I004" | clave=="I005" | clave=="I007" | clave=="I009" |
clave=="I011" | clave=="I014" | clave=="I015" | clave=="I016" | clave=="I017" | 
clave=="I019" | clave=="I020" | clave=="I021" | clave=="I022" | clave=="I023" |
clave=="I024" | clave=="I025" | clave=="I026" | clave=="J019" | clave=="J020" |
clave=="J021" | clave=="J022" | clave=="J023" | clave=="J024" | clave=="J025" | 
clave=="J026" | clave=="J027" | clave=="J028" | clave=="J029" | clave=="J030" | 
clave=="J031" | clave=="J032" | clave=="J033" | clave=="J060" | clave=="J061" | 
clave=="K001" | clave=="K007" | clave=="K009" | clave=="K010" | clave=="K012" |
clave=="K015" | clave=="K026" | clave=="K028" | clave=="K035" | clave=="L001" | 
clave=="L003" | clave=="L005" | clave=="L012" | clave=="L016" | clave=="N002" |
clave=="N003" | clave=="N006" ;

keep if claves_cbna==1 | (clave>="E001" & clave<="E019") | (clave>="J001" & clave<="J072") |  (clave>="A001" & clave<="A222") 
| (clave>="A242" & clave<="A247") | (clave>="H073" & clave<="H074") ;

save "$temp\EPR_CBNA_GASTO_Rural.dta", replace;


*Abrir base EPR de Canasta Básica No Alimentaria Urbana y unirla con la base de gastos no monetarios;
use "$temp\EPR_CBNA_Urbano.dta", clear;
sort folio;
merge folio using  "$temp\gastos mon_nomon.dta";
tab _merge;
keep if _merge==3;
drop _merge;

*Generar claves de la Canasta Básica No Alimentaria Urabana;

gen claves_cbna=.;
replace claves_cbna=1 if clave=="B001" | clave=="B002" | clave=="B004" | clave=="B005" | clave=="B006" | clave=="C001" |
clave=="C002" | clave=="C003" | clave=="C005" | clave=="C006" | clave=="C007" | clave=="C008" |
clave=="C009" | clave=="C010" | clave=="C011" | clave=="C012" | clave=="C013" | clave=="C015" |
clave=="C017" | clave=="C018" | clave=="D001" | clave=="D003" | clave=="D004" | clave=="D005" |
clave=="D007" | clave=="D009" | clave=="D010" | clave=="D011" | clave=="D012" | clave=="D014" |
clave=="D015" | clave=="D016" | clave=="D017" | clave=="D018" | clave=="D021" | clave=="D022" | 
clave=="E008" | clave=="E014" | clave=="E016" | clave=="E020" | clave=="E021" | clave=="E022" |
clave=="E023" | clave=="F001" | clave=="F002" | clave=="F003" | clave=="F004" | clave=="F005" |
clave=="F006" | clave=="G007" | clave=="G008" | clave=="G009" | clave=="G020" | clave=="H001" |
clave=="H003" | clave=="H004" | clave=="H005" | clave=="H007" | clave=="H008" | clave=="H010" |
clave=="H011" | clave=="H012" | clave=="H016" | clave=="H017" | clave=="H018" | clave=="H019" |
clave=="H021" | clave=="H022" | clave=="H023" | clave=="H024" | clave=="H025" | clave=="H026" ;
replace claves_cbna=1 if clave=="H028" | clave=="H029" | clave=="H030" | clave=="H031" | clave=="H032" | clave=="H033" |
clave=="H034" | clave=="H035" | clave=="H036" | clave=="H037" | clave=="H038" | clave=="H039" |
clave=="H040" | clave=="H041" | clave=="H042" | clave=="H045" | clave=="H046" | clave=="H047" |
clave=="H049" | clave=="H050" | clave=="H051" | clave=="H052" | clave=="H053" | clave=="H056" |
clave=="H057" | clave=="H058" | clave=="H059" | clave=="H060" | clave=="H061" | clave=="H062" |
clave=="H063" | clave=="H064" | clave=="H065" | clave=="H066" | clave=="H067" | clave=="H068" |
clave=="H069" | clave=="H070" | clave=="H072" | clave=="H073" | clave=="H076" | clave=="H077" |
clave=="H078" | clave=="H079" | clave=="H080" | clave=="H082" | clave=="H084" | clave=="H085" |
clave=="H086" | clave=="H088" | clave=="H090" | clave=="H091" | clave=="H092" | clave=="H094" |
clave=="H095" | clave=="H096" | clave=="H097" | clave=="H098" | clave=="H100" | clave=="H101" |
clave=="H102" | clave=="H103" | clave=="H104" | clave=="H106" | clave=="H107" | clave=="H108" |
clave=="H109" | clave=="H110" | clave=="H115" | clave=="H116" | clave=="I001" | clave=="I002" ;
replace claves_cbna=1 if clave=="I003" | clave=="I004" | clave=="I005" | clave=="I007" | clave=="I009" | clave=="I010" |
clave=="I011" | clave=="I012" | clave=="I014" | clave=="I015" | clave=="I016" | clave=="I017" |
clave=="I019" | clave=="I020" | clave=="I021" | clave=="I022" | clave=="I024" | clave=="I025" |
clave=="I026" | clave=="J019" | clave=="J020" | clave=="J021" | clave=="J022" | clave=="J023" |
clave=="J024" | clave=="J025" | clave=="J026" | clave=="J027" | clave=="J028" | clave=="J029" |
clave=="J030" | clave=="J031" | clave=="J032" | clave=="J033" | clave=="J060" | clave=="J061" |
clave=="J065" | clave=="K001" | clave=="K005" | clave=="K007" | clave=="K009" | clave=="K010" |
clave=="K012" | clave=="K015" | clave=="K021" | clave=="K026" | clave=="K027" | clave=="K035" |
clave=="L001" | clave=="L003" | clave=="L005" | clave=="L008" | clave=="L012" | clave=="L016" |
clave=="N002" | clave=="N003" ;
 
keep if claves_cbna==1 | (clave>="E001" & clave<="E019") | (clave>="J001" & clave<="J072") | (clave>="A001" & clave<="A222") 
| (clave>="A242" & clave<="A247") | (clave>="H073" & clave<="H074")   ;


save "$temp\EPR_CBNA_GASTO_Urbano.dta", replace;

*******************************************************************************;
* Paso 2.3: Valoración monetaria CBNA;
*******************************************************************************;


*Desagregación del gasto no alimentario del Estrato Poblacional de Referencia Rural;

use "$temp\EPR_CBNA_GASTO_Rural.dta", clear;

*Generar variables de gasto, gasto per cápita y alimentos;
egen gasto=sum(gasdef*factor), by(clave);
sort clave;
collapse (mean) tot_* gasto, by(clave);
gen grupo= substr(clave,1,1);
gen gasto_pc=gasto/tot_pers;
gen alim=gasto  if (clave>="A001" & clave<="A222") | 
(clave>="A242" & clave<="A247");

*Generar variables alimentaria, no alimentaria y gasto total;
egen totalim=sum(alim);
gen noalim=gasto if alim==.;
egen totnoalim=sum(noalim);
egen gasto_tot=sum(gasto);

gen totalim_pc=totalim/tot_pers;
sum totalim_pc;
scalar gto_alim1=r(mean);
gen totnoalim_pc=totnoalim/tot_pers;
sum totnoalim_pc;


*Generar Coeficiente de Engel Rural;
scalar gto_noalim1=r(mean);
scalar engel_rural=(gto_noalim1+gto_alim1)/gto_alim1;

*Ajustar valores desagregados con el valor de la canasta alimentaria rural 2006;

**********************************************************************
 *La idea detrás de este ajuste consiste en considerar
que los hogares satisfacen las necesidades alimentarias básicas antes
que las no alimentarias.
***********************************************************************;

gen gib_06_rural=(gasto_pc/gto_alim1)*525.95;
#delimit;
sort clave;

merge clave using "$bases\Deflactores.dta";
tab _merge;
keep if _merge==3;

gen gib_08_rural=gib_06_rural*def;

drop if grupo=="A";

keep clave grupo gib*;
sort clave;
save "$temp\No_Alimentaria_Rural.dta", replace;


*Desagregación del gasto no alimentario del Estrato Poblacional de Referencia Urbano;

use "$temp\EPR_CBNA_GASTO_Urbano.dta", clear;
*Generar variables de gasto, gasto per cápita y alimentos;
egen gasto=sum(gasdef*factor), by(clave);
sort clave;
collapse (mean) tot_* gasto, by(clave);

gen grupo= substr(clave,1,1);
gen gasto_pc=gasto/tot_pers;
gen alim=gasto  if (clave>="A001" & clave<="A222") | 
(clave>="A242" & clave<="A247");

*Generar variables alimentaria, no alimentaria y gasto total;
egen totalim=sum(alim);
gen noalim=gasto if alim==.;
egen totnoalim=sum(noalim);
egen gasto_tot=sum(gasto);

gen totalim_pc=totalim/tot_pers;
sum totalim_pc;
scalar gto_alim1=r(mean);
gen totnoalim_pc=totnoalim/tot_pers;
sum totnoalim_pc;


*Generar Coeficiente de Engel Urbano;
scalar gto_noalim1=r(mean);
scalar engel_urbano=(gto_noalim1+gto_alim1)/gto_alim1;


*Ajustar valores desagregados con el valor de la canasta alimentaria urbano 2006*;
gen gib_06_urbano=(gasto_pc/gto_alim1)*757.08;

**********************************************************************
 *La idea detrás de este ajuste consiste en considerar
que los hogares satisfacen las necesidades alimentarias básicas antes
que las no alimentarias
***********************************************************************;

sort clave;

*Unir bases;
merge clave using "$bases\Deflactores.dta";
tab _merge;
keep if _merge==3;

drop _merge;

gen gib_08_urbano=gib_06_urbano*def;

drop if grupo=="A";
keep clave grupo gib*;

save "$temp\No_Alimentaria_Urbano.dta", replace;
sort clave;


*Unir bases No Alimentaria Urbano con No alimentaria Rural;

merge clave using "$temp\No_Alimentaria_Rural.dta";
tab _merge;
drop _merge;

*Línea de Bienestar rural;
sum gib_06_rural;
scalar Costo_Rural_06=r(sum);
sum gib_08_rural;
scalar Costo_Rural_08=r(sum);

scalar LP_Ingresos_Rural_08=Costo_Rural_08+613.80;


*Línea de Bienestar urbana;
sum gib_06_urbano;
scalar Costo_Urbano_06=r(sum);
sum gib_08_urbano;
scalar Costo_Urbano_08=r(sum);
scalar LP_Ingresos_Urbano_08=Costo_Urbano_08+874.63;
scalar list;
#delimit;
count;
local n=r(N)+1;

set obs `n';
replace clave="CBA" if clave=="";

*Generación de variables con los rubros de la CBNA;
gen grupo2=1 if grupo=="B";
replace grupo2=2 if grupo=="C";
replace grupo2=3 if grupo=="D";
replace grupo2=4 if grupo=="E";
replace grupo2=5 if grupo=="F";
replace grupo2=6 if grupo=="G";
replace grupo2=7 if grupo=="H";
replace grupo2=8 if grupo=="I";
replace grupo2=9 if grupo=="J";
replace grupo2=10 if grupo=="K";
replace grupo2=11 if grupo=="L";
replace grupo2=12 if grupo=="M";
replace grupo2=13 if grupo=="N";
replace grupo2=14 if clave=="CBA";

replace gib_08_urbano=874.63 if clave=="CBA";
replace  gib_08_rural=613.8 if clave=="CBA";

*Etiquetar las variables de los rubros de la CBNA;

label value grupo2 grupo2;
label define grupo2 
1 "Transporte público"
2 "Limpieza y cuidados de la casa"
3 "Cuidados personales"
4 "Educación, cultura y recreación"
5 "Comunicaciones y servicios para vehículos"
6 "Vivienda y servicios de conservación"
7 "Prendas de vestir, calzado y accesorios"
8 "Cristalería, blancos y utensilios domésticos"
9 "Cuidados de la salud"
10 "Enseres domésticos y mantenimiento de la vivienda"
11 "Artículos de esparcimiento"
12 "Transporte"
13 "Otros gastos"
14 "Canasta Básica Alimentaria";
gen uno_u=1 if gib_08_urbano!=. ;
gen uno_r=1 if gib_08_rural!=. ;


*Generar variables de gasto por tipo de rubro;
egen gto_u=sum(gib_08_urbano), by(grupo2);
egen gto_r=sum(gib_08_rural), by(grupo2);
egen num_u=sum(uno_u), by(grupo2);
egen num_r=sum(uno_r), by(grupo2);

*Generar porcentaje de gasto urnbano y rural;
gen pje_gasto_r=(gto_r/LP_Ingresos_Rural_08)*100;
gen pje_gasto_u=(gto_u/LP_Ingresos_Urbano_08)*100;

*Generar estadísticos de las variables;

tabstat gib_08_urbano, by(grupo2) stats(sum N)  la(32)  format(%10.2f);
tabstat pje_gasto_u, by(grupo2) stats(mean)  format(%10.2f) not  la(32);

tabstat gib_08_rural, by(grupo2) stats(sum N)  la(32)  format(%10.2f);
tabstat pje_gasto_r, by(grupo2) stats(mean)  format(%10.2f) not  la(32);

di in red "Inverso del coeficiente de Engel Rural:" ;
di in yellow engel_rural;
di in red "Inverso del coeficiente de Engel Urbano:";
di in yellow  engel_urbano;
di in red "Valor de la línea de bienestar 2008 Rural:";
di in yellow LP_Ingresos_Rural_08;
di in red "Valor de la línea de bienestar 2008 Urbano:";
di in yellow LP_Ingresos_Urbano_08;

save "$temp\CANASTA NO ALIMENTARIA.dta", replace;


*Usar base de Canastas;
use "$temp\CANASTAS.dta", clear;



*Valores de las Líneas de Binestar Mínimo 2008;


*Rural
di in red "Valor de la línea de bienestar mínimo 2008 Rural:";
list CBA_RURAL in 1;


*Urbano;
di in red "Valor de la línea de bienestar mínimo 2008 Urbano:";
list  CBA_URBANA  in 1;

log close;






























