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
#delimit ;

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
