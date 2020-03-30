
/* 
Para cambiar estas ubicaciones, se modifican los siguientes
globals (gl); 
*/

#delimit ;

*gl dir = "d:\Users\asistente.iidses\Documents\canastas\Canasta_alimentaria_y_no_alimentaria\Canasta_alimentaria_y_no_alimentaria";
gl dir = "C:\Users\vicen\Documents\Canastas\Canasta_alimentaria_y_no_alimentaria\Canasta_alimentaria_y_no_alimentaria";
gl do = "C:\Users\vicen\Documents\Canastas\do_replica_local";

gl enigh = "$dir\ENIGH" ;
gl bases = "$dir\Bases" ;
gl temp = "$dir\Temp" ;
gl log = "$dir\Log";

*DTA;
global poblacionDTA = "$enigh\poblacion06.dta";
global concentradoDTA = "$enigh\concentrado06.dta";
global gastoDTA "$enigh\gasto06.dta";
global nomonetarioDTA "$enigh\nomonetario06.dta";

* TEMPS, con ANIO en nombre;
global alim_n_aportesDTA = "$temp\alim_n_Aportes_06.dta";
global alim_g_aportesDTA = "$temp\alim_g_Aportes_06.dta";

global EPR_CanastaDTA "$temp\EPR_Canasta_06.dta";

