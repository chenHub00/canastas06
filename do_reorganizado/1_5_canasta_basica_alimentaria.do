#delimit ;
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

do "$do\rubrosENIGH06.do";

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

do "$do\ajuste_micro_rural.do";
 
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

do "$do\rubrosENIGH06.do";

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

do "$do\ajuste_micro_urbano";

sort clave;

save "$temp\Componentes_Canasta_Urbana.dta", replace;

