* ajuste_micro_urbano 

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
 
