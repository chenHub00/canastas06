#delimit ;

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
