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

$bases
$log
$enigh
$do

*DTA
global poblacionDTA = "$enigh\poblacion06.dta"
global concentradoDTA = "$enigh\concentrado06.dta"
global gastoDTA "$enigh\gasto06.dta"

global alim_n_aportesDTA = "$temp\alim_n_Aportes_06.dta"
global alim_g_aportesDTA = "$temp\alim_g_Aportes_06.dta"

global EPR_CanastaDTA "$temp\EPR_Canasta_06.dta"


capture close
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
merge folio using "poblacionDTA";
gen parent=substr(parentesco,1,1);
destring parent, replace;
drop if parent==4;
drop if parent==7;
keep folio hog rururb edad sexo;

*Requerimientos energéticos;
destring edad sexo, replace;
di in red "Requerimiento energetico por hogar rural y Urbano" ;

* REQUERIMIENTOS DE NUTRIENTES RURAL Y URBANO
do "$do\requerimientos_rururb2016.do"

sort folio ;
save "$bases\requerimientos_rururb.dta", replace ;

* APORTES BASADOS EN GASTO Y NO MONETARIO
do "$do\alim_aportes2016"

di in red "Se une la base de gasto monetario y no-monetario" ;

use  "$alim_g_aportesDTA", replace ;
sort folio ;
merge folio using "$alim_n_aportesDTA.dta" ;
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

do "$do\rubrosENIGH06.do"

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

do "$do\ajuste_micro_rural.do"
 
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

do "$do\rubrosENIGH2016.do"

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

do "$do\ajuste_micro_urbano"

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




























