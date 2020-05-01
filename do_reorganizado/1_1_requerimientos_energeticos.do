#delimit ;

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
merge folio using "$poblacionDTA";
gen parent=substr(parentesco,1,1);
destring parent, replace;
drop if parent==4;
drop if parent==7;
keep folio hog rururb edad sexo;

*Requerimientos energéticos;
destring edad sexo, replace;
di in red "Requerimiento energetico por hogar rural y Urbano" ;

* REQUERIMIENTOS DE NUTRIENTES RURAL Y URBANO;
do "$do\requerimientos_rururb.do";
collapse (sum) req_*, by(folio) ;

sort folio ;
save "$bases\requerimientos_rururb.dta", replace ;


	