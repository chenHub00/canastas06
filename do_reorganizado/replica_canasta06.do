#delimit ;
clear ;
set more off ;
scalar drop _all;

/* 
Para cambiar estas ubicaciones, se modifican los siguientes
globals (gl); 
*/


*gl dir = "d:\Users\asistente.iidses\Documents\canastas\Canasta_alimentaria_y_no_alimentaria\Canasta_alimentaria_y_no_alimentaria";
gl dir = "C:\Users\vicen\Documents\Canastas\Canasta_alimentaria_y_no_alimentaria\Canasta_alimentaria_y_no_alimentaria";
*gl do = "C:\Users\vicen\Documents\Canastas\do_replica_local";
gl do = "C:\Users\vicen\Documents\Canastas\do_replica_local";


**********************************************************;
gl enigh = "$dir\ENIGH" ; 
gl bases = "$dir\Bases" ; 
gl temp = "$dir\Temp" ; 
gl log = "$dir\Log"; 

cap log close;
log using "$log\revision_segmentado06.smcl", replace;

************************************************************;
#delimit ;
*DTA;
global poblacionDTA = "$enigh\poblacion06.dta"; 
* poblacion;
global concentradoDTA = "$enigh\concentrado06.dta"; 
* concentradohogar;
global gastoDTA "$enigh\gasto06.dta"; 
* gastoshogar + gastospersona;
global nomonetarioDTA "$enigh\nomonetario06.dta"; 
* gastoshogar + gastospersona;

/* TEMPS, con ANIO en nombre;
* "alim_`labe'_Aportes06.dta";
global alim_n_aportesDTA = "$temp\alim_n_Aportes_06.dta"; 
* alim_n_Aportes;
global alim_g_aportesDTA = "$temp\alim_g_Aportes_06.dta"; 
* alim_g_Aportes;

global consumo_aportesDTA = "$temp\consumo_Aportes_06.dta"; 
* consumo_aportes;

global EPR_CanastaDTA "$temp\EPR_Canasta_06.dta"; 
* EPR_Canasta;
*/

/* Do-files 
#delimit cr
do "$do\1_1_requerimientos_energeticos.do"
do "$do\1_2_calorias_aportes"
do "$do\1_3_seleccion_estrato"
do "$do\1_4_construccion_cba"
do "$do\1_5_canasta_basica_alimentaria"
do "$do\1_6_valoracion"

log close
