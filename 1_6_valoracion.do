#delimit ;
set more off;
************************************************************************;
*Paso 1.6: Valoración monetaria CBA;
************************************************************************;
*Generar base de precios rural y urbana;

di in red "Se genera una base de precios rural y otra urbana";
use "$concentradoDTA", replace;
gen rururb = cond(estrato=="1" | estrato=="2" | estrato=="3",0,1) ;
keep folio rururb hog;
rename hog factor;
sort folio;
save "$temp\Identificador rururb_06.dta", replace;

use "$gastoDTA", clear;
gen base=1;
append using "$nomonetarioDTA";
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
