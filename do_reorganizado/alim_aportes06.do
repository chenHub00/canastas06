#delimit ;

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
save "$temp\alim_`labe'_Aportes06.dta", replace ;
} ;


