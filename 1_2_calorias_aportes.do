#delimit ;
************************************************************************;
*Paso 1.2: Creación de la base de calorias y aportes; 
************************************************************************;

* APORTES BASADOS EN GASTO Y NO MONETARIO;
do "$do\alim_aportes06.do";

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



#delimit ;
capture log close;
log using "$log\calorias_estratos.smcl", replace ;
use "$concentradoDTA", clear ;
rename hog factor ;
keep folio factor tam_hog estrato ingcor ;
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ; /*se repite en la seccion 1_1, ingcor no se usa en esa parte*/
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

log close
