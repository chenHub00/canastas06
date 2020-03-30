#delimit;
clear;
cap clear;
cap log close;
scalar drop _all;
set mem 1000m;
set more off;

*Este programa debe ser utilizado con el Software Stata 
versi�n 10 o superior. 

Todas las bases de datos del Model Estad�stico para la continuidad del 
MCS-ENIGH 2016 deben estar en formato *.dta

En este programa se utilizan las siguientes bases, 
renombr�ndolas de la siguiente forma:

Base de poblaci�n: poblacion.dta
Base de trabajos: trabajos.dta
Base de ingresos: ingresos.dta
Base de viviendas: viviendas.dta
Base de hogares: hogares.dta
Base de concentrado: concentradohogar.dta
Base de no monetario hogar: gastoshogar.dta
Base de no monetario personas: gastospersona.dta

En este programa se utilizan tres tipos de archivos, los cuales 
est�n ubicados en las siguientes carpetas:
 
*1) Bases originales: "C:\Pobreza 2016\originales"
*2) Bases generadas: "C:\Pobreza 2016\Bases"
*3) Bit�coras: "C:\Pobreza 2016\log"

Para cambiar estas ubicaciones, se modifican los siguientes
globals (gl); 

*gl data="C:\Pobreza 2016\originales";
*gl bases="C:\Pobreza 2016\Bases";
*gl log="C:\Pobreza 2016\log";

log using "$log\Pobreza_16.txt", text replace;

*********************************************************
*
*	PROGRAMA PARA LA MEDICI�N DE LA POBREZA 2016 
*
*********************************************************

*********************************************************
*Parte I Indicadores de Privaci�n Social:
*INDICADOR DE CARENCIA POR REZAGO EDUCATIVO
*********************************************************;

use "$data\poblacion.dta", clear;

*Poblaci�n objeto: no se incluye a hu�spedes ni trabajadores dom�sticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*A�o de nacimiento;
gen anac_e=.;
replace anac_e=2016-edad if edad!=.;
label var edad "Edad reportada al momento de la entrevista";
label var anac_e "A�o de nacimiento";

*Inasistencia a la escuela (se reporta para personas de 3 a�os o m�s);
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "S� asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*Nivel educativo;
destring nivelaprob gradoaprob antec_esc, replace;
gen niv_ed=.;
replace niv_ed=0 if (nivelaprob<2) | (nivelaprob==2 & gradoaprob<6);
replace niv_ed=1 if (nivelaprob==2 & gradoaprob==6) | 
					(nivelaprob==3 & gradoaprob<3) | 
					(nivelaprob==5 | nivelaprob==6) & gradoaprob<3 & antec_esc==1;
replace niv_ed=2 if (nivelaprob==3 & gradoaprob==3) | 
					(nivelaprob==4) | 
					(nivelaprob==5 & antec_esc==1 & gradoaprob>=3) |
					(nivelaprob==6 & antec_esc==1 & gradoaprob>=3) | 
					(nivelaprob==5 & antec_esc>=2 & antec_esc!=.) | 
					(nivelaprob==6 & antec_esc>=2 & antec_esc!=.) | 
					(nivelaprob>=7 & nivelaprob!=.);
label var niv_ed "Nivel educativo";
label define niv_ed  0 "Con primaria incompleta o menos" 
                     1 "Primaria completa o secundaria incompleta"
                     2 "Secundaria completa o mayor nivel educativo";
label value niv_ed niv_ed;

*Indicador de carencia por rezago educativo
*****************************************************************************
Se considera en situaci�n de carencia por rezago educativo 
a la poblaci�n que cumpla con alguno de los siguientes criterios:

1. Se encuentra entre los 3 y los 15 a�os y no ha terminado la educaci�n 
obligatoria (secundaria terminada) o no asiste a la escuela.
2. Tiene una edad de 16 a�os o m�s, su a�o de nacimiento aproximado es 1981 
o anterior, y no dispone de primaria completa.
3. Tiene una edad de 16 a�os o m�s, su a�o de nacimiento aproximado es 1982 
en adelante, y no dispone de secundaria completa.	
*****************************************************************************;
				
gen ic_rezedu=.;
replace ic_rezedu=1 if  (edad>=3 & edad<=15) & inas_esc==1 & (niv_ed==0 | niv_ed==1);
replace ic_rezedu=1 if  (edad>=16 & edad!=.) & (anac_e>=1982 & anac_e!=.) 
          & (niv_ed==0 | niv_ed==1);
replace ic_rezedu=1 if  (edad>=16 & edad!=.) & (anac_e<=1981) & (niv_ed==0);
replace ic_rezedu=0 if  (edad>=0 & edad<=2);
replace ic_rezedu=0 if  (edad>=3 & edad<=15) & inas_esc==0;
replace ic_rezedu=0 if  (edad>=3 & edad<=15) & inas_esc==1 & (niv_ed==2);
replace ic_rezedu=0 if  (edad>=16 & edad!=.) & (anac_e>=1982 & anac_e!=.) 
          & (niv_ed==2);
replace ic_rezedu=0 if  (edad>=16 & edad!=.) & (anac_e<=1981) & (niv_ed==1 | niv_ed==2);
label var ic_rezedu "Indicador de carencia por rezago educativo";
label define caren 0 "No presenta carencia"
                       1 "Presenta carencia";
label value ic_rezedu caren ;

*Hablante de lengua ind�gena;
gen hli=.;
replace hli=1 if hablaind=="1" & edad>=3;
replace hli=0 if hablaind=="2" & edad>=3;
label var hli "Hablante de lengua ind�gena";
label define hli 0 "No habla lengua ind�gena"
                       1 "Habla lengua ind�gena";
label value hli hli;

keep  folioviv foliohog numren edad anac_e inas_esc niv_ed ic_rezedu hli parentesco;
sort  folioviv foliohog numren;
save "$bases\ic_rezedu16.dta", replace;

************************************************************************
*Parte II Indicadores de Privaci�n Social:
*INDICADOR DE CARENCIA POR ACCESO A LOS SERVICIOS DE SALUD
***********************************************************************;

*Acceso a Servicios de salud por prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la poblaci�n subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor=="1";

*Independientes que reciben un pago;
replace tipo_trab=2 if subor=="2" & indep=="1" & tiene_suel=="1";
replace tipo_trab=2 if subor=="2" & indep=="2" & pago=="1";

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor=="2" & indep=="1" & tiene_suel=="2";
replace tipo_trab=3 if subor=="2" & indep=="2" & (pago=="2" | pago=="3");

*Ocupaci�n principal o secundaria;
destring id_trabajo, replace;
recode id_trabajo (1=1)(2=0), gen (ocupa);

*Distinci�n de prestaciones en trabajo principal y secundario;
keep  folioviv foliohog numren id_trabajo tipo_trab  ocupa;
reshape wide tipo_trab ocupa, i(folioviv foliohog numren) j(id_trabajo);
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label var ocupa1 "Ocupaci�n principal";
recode ocupa2 (0=1)(.=0);
label var ocupa2 "Ocupaci�n secundaria";
label define ocupa   0 "Sin ocupaci�n secundaria" 
                     1 "Con ocupaci�n secundaria";
label value ocupa2 ocupa;

*Identificaci�n de la poblaci�n trabajadora (toda la que reporta al menos un empleo en la base de trabajos.dta);
gen trab=1;
label var trab "Poblaci�n con al menos un empleo";

keep  folioviv foliohog numren trab tipo_trab*  ocupa*;
sort  folioviv foliohog numren;
save "$bases\ocupados16.dta", replace;

use "$data\poblacion.dta", clear;

*Poblaci�n objeto: no se incluye a hu�spedes ni trabajadores dom�sticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

sort  folioviv foliohog numren;
 
merge  folioviv foliohog numren using "$bases\ocupados16.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 a�os o m�s);

gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if (act_pnea1=="1" | act_pnea2=="1") & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & (act_pnea1!="1" & act_pnea2!="1") & 
((act_pnea1>="2" & act_pnea1<="6") | (act_pnea2>="2" & act_pnea2<="6")) & pea==.;
label var pea "Poblaci�n econ�micamente activa";
label define pea 0 "PNEA" 
                1 "PEA: ocupada" 
                2 "PEA: desocupada";
label value pea pea;

*Tipo de trabajo;
*Ocupaci�n principal;
replace tipo_trab1=tipo_trab1 if pea==1;
replace tipo_trab1=. if (pea==0 | pea==2);
replace tipo_trab1=. if pea==.;
label define tipo_trab 1"Depende de un patr�n, jefe o superior"
                       2 "No depende de un jefe y tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;

*Ocupaci�n secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;
label value tipo_trab2 tipo_trab;


*Servicios m�dicos prestaciones laborales ;

*Ocupaci�n principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab1 (.=0) if ocupa1==1;
label var smlab1 "Servicios m�dicos por prestaci�n laboral en ocupaci�n principal";
label define smlab 0 "Sin servicios m�dicos" 
                   1 "Con servicios m�dicos";
label value smlab1 smlab;

*Ocupaci�n secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab2 (.=0) if ocupa2==1;
label var smlab2 "Servicios m�dicos por prestaci�n laboral en ocupaci�n secundaria";
label value smlab2 smlab;

*Contrataci�n voluntaria de servicios m�dicos;

gen smcv=.;
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
					& (inscr_6=="6") & (edad>=12 & edad<=97);
recode smcv (.=0) if (edad>=12 & edad<=97);
label var smcv "Servicios m�dicos por contrataci�n voluntaria";
label value smcv cuenta;

*Acceso directo a servicios de salud;

gen sa_dir=.;
*Ocupaci�n principal;
replace sa_dir=1 if tipo_trab1==1 & (smlab1==1);
replace sa_dir=1 if tipo_trab1==2 & (smlab1==1 | smcv==1);
replace sa_dir=1 if tipo_trab1==3 & (smlab1==1 | smcv==1);
*Ocupaci�n secundaria;
replace sa_dir=1 if tipo_trab2==1 & (smlab2==1);
replace sa_dir=1 if tipo_trab2==2 & (smlab2==1 | smcv==1);
replace sa_dir=1 if tipo_trab2==3 & (smlab2==1 | smcv==1 );

*N�cleos familiares;
gen par=.;
replace par=1 if (parentesco>="100" & parentesco<"200");
replace par=2 if (parentesco>="200" & parentesco<"300");
replace par=3 if (parentesco>="300" & parentesco<"400");
replace par=4 if parentesco=="601";
replace par=5 if parentesco=="615";
recode par (.=6) if  par==.;
label var par "Integrantes que tienen acceso por otros miembros";
label define par       1 "Jefe o jefa del hogar" 
                       2 "C�nyuge del  jefe/a" 
                       3 "Hijo del jefe/a" 
                       4 "Padre o Madre del jefe/a"
                       5 "Suegro del jefe/a"
                       6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizar� la informaci�n relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "S� asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*En primer lugar se identifican los principales parentescos respecto a la jefatura del hogar y si ese miembro
cuenta con acceso directo;

gen jef=1 if par==1 & sa_dir==1;
replace jef=. if par==1 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" " & inst_6==" ")
& (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));
gen cony=1 if par==2 & sa_dir==1;
replace cony=. if par==2 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" "  & inst_6==" ")
& (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));
gen hijo=1 if par==3 & sa_dir==1  ;
replace hijo=. if par==3 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" " & inst_6==" ")
& (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));

egen jef_sa=sum(jef), by( folioviv foliohog);
egen cony_sa=sum(cony), by( folioviv foliohog);
replace cony_sa=1 if cony_sa>=1 & cony_sa!=.;
egen hijo_sa=sum(hijo), by( folioviv foliohog);
replace hijo_sa=1 if hijo_sa>=1 & hijo_sa!=.;

label var jef_sa "Acceso directo a servicios de salud de la jefatura del hogar";
label value jef_sa cuenta;
label var cony_sa "Acceso directo a servicios de salud del conyuge de la jefatura del hogar";
label value cony_sa cuenta;
label var hijo_sa "Acceso directo a servicios de salud de hijos(as) de la jefatura del hogar";
label value hijo_sa cuenta;

*Otros n�cleos familiares: se identifica a la poblaci�n con acceso a servicios de salud
mediante otros n�cleos familiares a trav�s de la afiliaci�n
o inscripci�n a servicios de salud por alg�n familiar dentro o 
fuera del hogar, muerte del asegurado o por contrataci�n propia;

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
& (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" | inscr_7=="7");
recode s_salud (.=0) if segpop!=" " & atemed!=" ";
label var s_salud "Servicios m�dicos por otros n�cleos familiares o por contrataci�n propia";
label value s_salud cuenta;


*Indicador de carencia por servicios de salud;
*****************************************************************************
Se considera en situaci�n de carencia por acceso a servicios de salud
a la poblaci�n que:

1. No se encuentra afiliada o inscrita al Seguro Popular o alguna 
instituci�n que proporcione servicios m�dicos, ya sea por prestaci�n laboral,
contrataci�n voluntaria o afiliaci�n de un familiar por parentesco directo 

*****************************************************************************;


*Indicador de carencia por acceso a los servicios de salud;
gen ic_asalud=.;
*Acceso directo;
replace ic_asalud=0 if sa_dir==1;
*Parentesco directo: jefatura;
replace ic_asalud=0 if par==1 & cony_sa==1;
replace ic_asalud=0 if par==1 & pea==0 & hijo_sa==1;
*Parentesco directo: c�nyuge;
replace ic_asalud=0 if par==2 & jef_sa==1;
replace ic_asalud=0 if par==2 & pea==0 & hijo_sa==1;
*Parentesco directo: descendientes;
replace ic_asalud=0 if par==3 & edad<16 & jef_sa==1;
replace ic_asalud=0 if par==3 & edad<16 & cony_sa==1;
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & jef_sa==1;
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & cony_sa==1;
*Parentesco directo: ascendientes;
replace ic_asalud=0 if par==4 & pea==0 & jef_sa==1;
replace ic_asalud=0 if par==5 & pea==0 & cony_sa==1;
*Otros n�cleos familiares;
replace ic_asalud=0 if s_salud==1;
*Acceso reportado;
replace ic_asalud=0 if segpop=="1" | (segpop=="2" & atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" | inst_5=="5" | inst_6=="6")) | segvol_2=="2";
recode ic_asalud .=1;


*Poblaci�n con al menos alguna discapacidad, sea f�sica o mental;
gen discap=.;
replace discap=1 if disc1>="1" & disc1<="7";
replace discap=1 if disc2>="2" & disc2<="7";
replace discap=1 if disc3>="3" & disc3<="7";
replace discap=1 if disc4>="4" & disc4<="7";
replace discap=1 if disc5>="5" & disc5<="7";
replace discap=1 if disc6>="6" & disc6<="7";
replace discap=1 if disc7=="7";
replace discap=0 if disc1=="8" | disc1=="";
replace discap=0 if disc1=="8" | disc1==" " | disc1=="&";



label var discap "Poblaci�n con al menos una discapacidad f�sica o mental";
label define discap  0 "No presenta discapacidad"
                        1 "Presenta discapacidad";
label value discap discap;


label var ic_asalud "Indicador de carencia por acceso a servicios de salud";
label define caren  0 "No presenta carencia"
                        1 "Presenta carencia";
label value ic_asalud caren;

keep  folioviv foliohog numren sexo ic_asalud sa_* *_sa segpop atemed inst_* inscr_* segvol_* discap;
sort  folioviv foliohog numren;
save "$bases\ic_asalud16.dta", replace;


*********************************************************
*Parte III Indicadores de Privaci�n social:
*Indicador de carencia por acceso a la seguridad social
*********************************************************;

*Prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la poblaci�n subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor=="1";

*Independientes que reciben un pago;
replace tipo_trab=2 if subor=="2" & indep=="1" & tiene_suel=="1";
replace tipo_trab=2 if subor=="2" & indep=="2" & pago=="1";

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor=="2" & indep=="1" & tiene_suel=="2";
replace tipo_trab=3 if subor=="2" & indep=="2" & (pago=="2" | pago=="3");

*Prestaciones laborales: incapacidad en caso de enfermedad o maternidad con goce de sueldo y SAR o Afore;
gen inclab=0 if pres_7==" ";
replace inclab=1 if pres_7=="07";

gen aforlab=0 if pres_14==" ";
replace aforlab=1 if pres_14=="14";

*Ocupaci�n principal o secundaria;
destring id_trabajo, replace;
recode id_trabajo (1=1)(2=0), gen (ocupa);

*Distinci�n de prestaciones en trabajo principal y secundario;
keep  folioviv foliohog numren id_trabajo tipo_trab inclab aforlab ocupa;
reshape wide tipo_trab inclab aforlab ocupa, i( folioviv foliohog numren) j( id_trabajo);
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label var inclab1 "Incapacidad con goce de sueldo en ocupaci�n principal";
label define cuenta 0 "No cuenta" 
                    1 "S� cuenta";
label value inclab1 cuenta;
label var inclab2 "Incapacidad con goce de sueldo en ocupaci�n secundaria";
label value inclab2 cuenta;
label var aforlab1 "Ocupaci�n principal: SAR o Afore";
label value aforlab1 cuenta;
label var aforlab2 "Ocupaci�n secundaria: SAR o Afore";
label value aforlab2 cuenta;
label var ocupa1 "Ocupaci�n principal";
recode ocupa2 (0=1)(.=0);
label var ocupa2 "Ocupaci�n secundaria";
label define ocupa   0 "Sin ocupaci�n secundaria" 
                     1 "Con ocupaci�n secundaria";
label value ocupa2 ocupa;

*Identificaci�n de la poblaci�n trabajadora (toda la que reporta al menos un empleo en la base de trabajos.dta);
gen trab=1;
label var trab "Poblaci�n con al menos un empleo";

keep  folioviv foliohog numren trab tipo_trab* inclab* aforlab* ocupa*;
sort  folioviv foliohog numren;
save "$bases\prestaciones16.dta", replace;

*Ingresos por jubilaciones o pensiones;
use "$data\ingresos.dta", clear;

keep if clave=="P032" | clave=="P033" | clave=="P044" | clave=="P045" ;
egen ing_pens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P032" | clave=="P033";
egen ing_pam=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P044" | clave=="P045";
recode ing_pens ing_pam (.=0);
collapse (sum) ing_pens ing_pam, by( folioviv foliohog numren);
label var ing_pens "Ingreso promedio mensual por jubilaciones y pensiones";
label var ing_pam "Ingreso promedio mensual por programas de adultos mayores";

sort  folioviv foliohog numren;
save "$bases\pensiones16.dta", replace;

*Construcci�n del indicador;
use "$data\poblacion.dta", clear;

*Poblaci�n objeto:no se incluye a hu�spedes ni trabajadores dom�sticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Integraci�n de bases;
sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\prestaciones16.dta";
tab _merge;
drop _merge;

sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\pensiones16.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 a�os o m�s);
gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if (act_pnea1=="1" | act_pnea2=="1") & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & (act_pnea1!="1" & act_pnea2!="1") & 
((act_pnea1>="2" & act_pnea1<="6") | (act_pnea2>="2" & act_pnea2<="6")) & pea==.;
label var pea "Poblaci�n econ�micamente activa";
label define pea 0 "PNEA" 
                1 "PEA: ocupada" 
                2 "PEA: desocupada";
label value pea pea;

*Tipo de trabajo;
*Ocupaci�n principal;
replace tipo_trab1=tipo_trab1 if pea==1;
replace tipo_trab1=. if (pea==0 | pea==2);
replace tipo_trab1=. if pea==.;
label define tipo_trab 1"Depende de un patr�n, jefe o superior"
                       2 "No depende de un jefe y tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;


*Ocupaci�n secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;
label value tipo_trab2 tipo_trab;

*Jubilados o pensionados;
gen jub=.;
replace jub=1 if trabajo_mp=="2" & (act_pnea1=="2" | act_pnea2=="2");
replace jub=1 if ing_pens>0 &  ing_pens!=.;
replace jub=1 if inscr_2=="2";
recode jub (.=0);
label var jub "Poblaci�n pensionada o jubilada";
label define jub 0 "Poblaci�n no pensionada o jubilada" 
                 1 "Poblaci�n pensionada o jubilada";
label value jub jub;

*Prestaciones b�sicas;

*Prestaciones laborales (Servicios m�dicos);

*Ocupaci�n principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab1 (.=0) if ocupa1==1;
label var smlab1 "Servicios m�dicos por prestaci�n laboral en ocupaci�n principal";
label define smlab 0 "Sin servicios m�dicos" 
                   1 "Con servicios m�dicos";
label value smlab1 smlab;

*Ocupaci�n secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab2 (.=0) if ocupa2==1;
label var smlab2 "Servicios m�dicos por prestaci�n laboral en ocupaci�n secundaria";
label value smlab2 smlab;

*Contrataci�n voluntaria: servicios m�dicos y SAR o Afore;

*Servicios m�dicos;
gen smcv=.;
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
					& (inscr_6=="6") & (edad>=12 & edad<=97);
recode smcv (.=0) if (edad>=12 & edad<=97);
label var smcv "Servicios m�dicos por contrataci�n voluntaria";
label value smcv cuenta;

*SAR o Afore;
gen aforecv=.;
replace aforecv=1 if segvol_1=="1" & (edad>=12 & edad!=.);
recode aforecv (.=0) if segvol_1==" " &  (edad>=12 & edad!=.);
label var aforecv "SAR o Afore";
label value aforecv cuenta;

drop inclab1 aforlab1;
rename aforlab1_final aforlab1;
rename inclab1_final inclab1;

*Acceso directo a la seguridad social;

gen ss_dir=.;
*Ocupaci�n principal;
replace ss_dir=1 if tipo_trab1==1 & (smlab1==1 & inclab1==1 & aforlab1==1);
replace ss_dir=1 if tipo_trab1==2 & ((smlab1==1 | smcv==1) & (aforlab1==1 | aforecv==1));
replace ss_dir=1 if tipo_trab1==3 & ((smlab1==1 | smcv==1) & aforecv==1);
*Ocupaci�n secundaria;
replace ss_dir=1 if tipo_trab2==1 & (smlab2==1 & inclab2==1 & aforlab2==1);
replace ss_dir=1 if tipo_trab2==2 & ((smlab2==1 | smcv==1) & (aforlab2==1 | aforecv==1));
replace ss_dir=1 if tipo_trab2==3 & ((smlab2==1 | smcv==1) & aforecv==1);
*Jubilados y pensionados;
replace ss_dir=1 if jub==1;
recode ss_dir (.=0);
label var ss_dir "Acceso directo a la seguridad social";
label define ss_dir   0 "Sin acceso"
                      1 "Con acceso";
label value ss_dir ss_dir;

*N�cleos familiares;
gen par=.;
replace par=1 if (parentesco>="100" & parentesco<"200");
replace par=2 if (parentesco>="200" & parentesco<"300");
replace par=3 if (parentesco>="300" & parentesco<"400");
replace par=4 if parentesco=="601";
replace par=5 if parentesco=="615";
recode par (.=6) if  par==.;
label var par "Integrantes que tienen acceso por otros miembros";
label define par       1 "Jefe o jefa del hogar" 
                       2 "C�nyuge del  jefe/a" 
                       3 "Hijo del jefe/a" 
                       4 "Padre o Madre del jefe/a"
                       5 "Suegro del jefe/a"
                       6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizar� la informaci�n relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "S� asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*En primer lugar se identifican los principales parentescos respecto a la jefatura del hogar y si ese miembro
cuenta con acceso directo;

gen jef=1 if par==1 & ss_dir==1 ;
replace jef=. if par==1 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" "  & inst_6==" ")
 & (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));
gen cony=1 if par==2 & ss_dir==1;
replace cony=. if par==2 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" "  & inst_6==" ")
 & (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));
gen hijo=1 if par==3 & ss_dir==1 & jub==0;
replace hijo=1 if par==3 & ss_dir==1 & jub==1 & (edad>25 & edad!=.);
replace hijo=. if par==3 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1==" " & inst_4==" " & inst_6==" ")
 & (inscr_1==" " & inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & inscr_7==" "));

egen jef_ss=sum(jef), by( folioviv foliohog);
egen cony_ss=sum(cony), by( folioviv foliohog);
replace cony_ss=1 if cony_ss>=1 & cony_ss!=.;
egen hijo_ss=sum(hijo), by( folioviv foliohog);
replace hijo_ss=1 if hijo_ss>=1 & hijo_ss!=.;

label var jef_ss "Acceso directo a la seguridad social de la jefatura del hogar";
label value jef_ss cuenta;
label var cony_ss "Acceso directo a la seguridad social de conyuge de la jefatura del hogar";
label value cony_ss cuenta;
label var hijo_ss "Acceso directo a la seguridad social de hijos(as) de la jefatura del hogar";
label value hijo_ss cuenta;

*Otros n�cleos familiares: se identifica a la poblaci�n con acceso a la seguridad
social mediante otros n�cleos familiares a trav�s de la afiliaci�n
o inscripci�n a servicios de salud por alg�n familiar dentro o 
fuera del hogar, muerte del asegurado o por contrataci�n propia;

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
& (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" | inscr_7=="7");
recode s_salud (.=0) if segpop!=" " & atemed!=" ";
label var s_salud "Servicios m�dicos por otros n�cleos familiares o por contrataci�n propia";
label value s_salud cuenta;

*Programas sociales de pensiones para adultos mayores;
gen pam=.;
replace pam=1 if (edad>=65 & edad!=.) & ing_pam>0 & ing_pam!=.;
recode pam (.=0) if (edad>=65 & edad!=.) ;
label var pam "Programa de adultos mayores";
label define pam 0 "No recibe" 
                 1 "Recibe";
label value pam pam;

************************************************************************
Indicador de carencia por acceso a la seguridad social
No se considera en situaci�n de carencia por acceso a la seguridad social
a la poblaci�n que:
1. Disponga de acceso directo a la seguridad social,
2. Cuente con parentesco directo con alguna persona dentro del hogar
que tenga acceso directo,
3. Reciba servicios m�dicos por parte de alg�n familiar dentro o
fuera del hogar, por muerte del asegurado o por contrataci�n propia, o,
4. Reciba ingresos por parte de un programa de adultos mayores. 

Se considera en situaci�n de carencia por acceso a la seguridad social
aquella poblaci�n:

1. En cualquier otra situaci�n.
***********************************************************************;

*Indicador de carencia por acceso a la seguridad social;
gen ic_segsoc=.;
*Acceso directo;
replace ic_segsoc=0 if ss_dir==1;
*Parentesco directo: jefatura;
replace ic_segsoc=0 if par==1 & cony_ss==1;
replace ic_segsoc=0 if par==1 & pea==0 & hijo_ss==1;
*Parentesco directo: c�nyuge;
replace ic_segsoc=0 if par==2 & jef_ss==1;
replace ic_segsoc=0 if par==2 & pea==0 & hijo_ss==1;
*Parentesco directo: descendientes;
replace ic_segsoc=0 if par==3 & edad<16 & jef_ss==1;
replace ic_segsoc=0 if par==3 & edad<16 & cony_ss==1;
replace ic_segsoc=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & jef_ss==1;
replace ic_segsoc=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & cony_ss==1;
*Parentesco directo: ascendientes;
replace ic_segsoc=0 if par==4 & pea==0 & jef_ss==1;
replace ic_segsoc=0 if par==5 & pea==0 & cony_ss==1;
*Otros n�cleos familiares;
replace ic_segsoc=0 if s_salud==1;
*Programa de adultos mayores;
replace ic_segsoc=0 if pam==1;
recode ic_segsoc (.=1);
label var ic_segsoc "Indicador de carencia por acceso a la seguridad social";
label define caren 0 "Con acceso"
                       1 "Sin acceso";
label value ic_segsoc caren;

keep  folioviv foliohog numren tipo_trab*  inclab*  aforlab* smlab* smcv 
aforecv pea jub ss_dir par jef_ss cony_ss hijo_ss s_salud pam ic_segsoc hablaind;

sort  folioviv foliohog numren;


save "$bases\ic_segsoc16.dta", replace;

***********************************************************
*Parte IV Indicadores de Privaci�n social:
*Indicador de carencia por calidad y espacios de la vivienda
***********************************************************;

*Material de construcci�n de la vivienda;

use "$data\viviendas.dta", clear;
sort  folioviv;
save "$bases\viviendas.dta", replace;
use "$data\concentradohogar.dta", clear;
sort  folioviv ;
merge  folioviv  using "$bases\viviendas.dta";
tab _merge;
drop _merge;


*Material de los pisos de la vivienda;
destring mat_pisos, gen(icv_pisos) force;

recode icv_pisos (0=.);
recode icv_pisos (2 3=0) (1=1);

*Material de los techos de la vivienda;
destring mat_techos, gen(icv_techos) force;

recode icv_techos (0=.);
recode icv_techos (3 4 5 6 7 8 9 10=0) (1 2=1);

*Material de muros en la vivienda;
destring mat_pared, gen(icv_muros) force;

recode icv_muros (0=.);
recode icv_muros (6 7 8=0) (1 2 3 4 5=1);

*Espacios en la vivienda (Hacinamiento);

*N�mero de residentes en la vivienda;

rename tot_resid num_ind;

*N�mero de cuartos en la vivienda;
rename num_cuarto num_cua;

*�ndice de hacinamiento;
gen cv_hac=num_ind/num_cua;

*Indicador de carencia por hacinamiento;
gen icv_hac=.;
replace icv_hac=1 if cv_hac>2.5 & cv_hac!=.;
replace icv_hac=0 if cv_hac<=2.5;

label var icv_pisos "Indicador de carencia del material de piso de la vivienda";
label define caren     0 "Sin carencia"
                       1 "Con carencia";
label value icv_pisos caren;

label var icv_techos "Indicador de carencia por material de techos de la vivienda";
label value icv_techos caren;

label var icv_muros "Indicador de carencia del material de muros de la vivienda";
label value icv_muros caren;

label var icv_hac "Indicador de carencia por �ndice de hacinamiento de la vivienda";
label value icv_hac caren;

*Indicador de carencia por calidad y espacios de la vivienda;
********************************************************************************
Se considera en situaci�n de carencia por calidad y espacios 
de la vivienda a la poblaci�n que:

1. Presente carencia en cualquiera de los subindicadores de esta dimensi�n

No se considera en situaci�n de carencia por rezago calidad y espacios 
de la vivienda a la poblaci�n que:

1. Habite en una vivienda sin carencia en todos los subindicadores
de esta dimensi�n
********************************************************************************;

gen ic_cv=.;
replace ic_cv=1 if icv_pisos==1 | icv_techos==1 | icv_muros==1 | icv_hac==1;
replace ic_cv=0 if icv_pisos==0 & icv_techos==0 & icv_muros==0 & icv_hac==0;
replace ic_cv=. if icv_pisos==. | icv_techos==. | icv_muros==. | icv_hac==.;
label var ic_cv "Indicador de carencia por calidad y espacios de la vivienda";
label value ic_cv caren;
sort  folioviv foliohog;
keep  folioviv foliohog icv_pisos icv_techos icv_muros icv_hac ic_cv;
save "$bases\ic_cev16.dta", replace;
 
************************************************************************
*Parte V Indicadores de Privaci�n Social:
*Indicador de carencia por acceso a los servicios b�sicos de la vivienda
*************************************************************************;
#delimit;
use "$data\concentradohogar.dta", clear;
keep  folioviv foliohog;
sort  folioviv ;
merge  folioviv using "$bases\viviendas.dta";
tab _merge;
drop _merge;

*Disponibilidad de agua;
destring disp_agua, gen(isb_agua);
recode isb_agua (0=.);
recode isb_agua (1 2=0) (3 4 5 6 7=1);
replace isb_agua=0 if ubica_geo=="200850016" & disp_agua=="4";

*Drenaje;
destring drenaje, gen(isb_dren);
recode isb_dren (0=.);
recode isb_dren (1 2=0) (3 4 5=1);

*Electricidad;
destring disp_elect, gen(isb_luz);
recode isb_luz (0=.);
recode isb_luz (1 2 3 4=0) (5=1);

*Combustible;


destring combustible, gen(combus);
destring estufa_chi, gen(estufa);
recode combus (0=.) (-1=.);
recode estufa (-1=.);
gen isb_combus=0 if combus>=3 & combus<=6;
replace isb_combus=0 if (combus==1 | combus==2) & estufa==1;
replace isb_combus=1 if (combus==1 | combus==2) & estufa==2;


label var isb_agua "Indicador de carencia de acceso al agua";
label define caren 0 "Sin carencia"
                      1 "Con carencia";
label value isb_agua caren;
label var isb_dren "Indicador de carencia de servicio de drenaje";
label value isb_dren caren;
label var isb_luz "Indicador de carencia de servicios de electricidad";
label value isb_luz caren;
label var isb_combus "Indicador de carencia de servicios de combustible";
label value isb_combus caren;

*Indicador de carencia por acceso a los servicios b�sicos en la vivienda;
********************************************************************************
Se considera en situaci�n de carencia por servicios b�sicos en la vivienda 
a la poblaci�n que:

1. Presente carencia en cualquiera de los subindicadores de esta dimensi�n

No se considera en situaci�n de carencia por  servicios b�sicos en la vivienda
a la poblaci�n que:

1. Habite en una vivienda sin carencia en todos los subindicadores
de esta dimensi�n
********************************************************************************;

gen ic_sbv=.;
replace ic_sbv=1 if (isb_agua==1 | isb_dren==1 | isb_luz==1 | isb_combus==1);
replace ic_sbv=0 if isb_agua==0 & isb_dren==0 & isb_luz==0 & isb_combus==0;
replace ic_sbv=. if (isb_agua==. | isb_dren==. | isb_luz==. | isb_combus==.);
label var ic_sbv "Indicador de carencia de acceso a servicios b�sicos de la vivienda";
label value ic_sbv caren;

sort  folioviv foliohog;
keep  folioviv foliohog isb_agua isb_dren isb_luz isb_combus ic_sbv;
save "$bases\ic_sbv16.dta", replace;

**********************************************************************
*Parte VI Indicadores de Privaci�n Social:
*Indicador de carencia por acceso a la alimentaci�n
**********************************************************************;

use "$data\poblacion.dta", clear;
 
*Poblaci�n objeto: no se incluye a hu�spedes ni trabajadores dom�sticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Indicador de hogares con menores de 18 a�os;
gen men=1 if edad>=0 & edad<=17;
collapse (sum) men, by( folioviv foliohog);

gen id_men=.;
replace id_men=1 if men>=1 & men!=.;
replace id_men=0 if men==0;
label var id_men "Hogares con poblaci�n de 0 a 17 a�os de edad";
label define id_men 0 "Sin poblaci�n de 0 a 17 a�os"
                    1 "Con poblaci�n de 0 a 17 a�os";
label value id_men id_men;

sort  folioviv foliohog;
keep  folioviv foliohog id_men;
save "$bases\menores14.dta", replace;

use "$data\hogares.dta", clear;
destring acc_alim*, replace;

* SEIS PREGUNTAS PARA HOGARES SIN POBLACI�N MENOR A 18 A�OS;
recode acc_alim4 (2=0) (1=1) (.=0), gen (ia_1ad);
recode acc_alim5 (2=0) (1=1) (.=0), gen (ia_2ad);
recode acc_alim6 (2=0) (1=1) (.=0), gen (ia_3ad);
recode acc_alim2 (2=0) (1=1) (.=0), gen (ia_4ad);
recode acc_alim7 (2=0) (1=1) (.=0), gen (ia_5ad);
recode acc_alim8 (2=0) (1=1) (.=0), gen (ia_6ad);

* SEIS PREGUNTAS PARA HOGARES CON POBLACI�N MENOR A 18 A�OS;
recode acc_alim11 (2=0) (1=1) (.=0), gen (ia_7men);
recode acc_alim12 (2=0) (1=1) (.=0), gen (ia_8men);
recode acc_alim13 (2=0) (1=1) (.=0), gen (ia_9men);
recode acc_alim14 (2=0) (1=1) (.=0), gen (ia_10men);
recode acc_alim15 (2=0) (1=1) (.=0), gen (ia_11men);
recode acc_alim16 (2=0) (1=1) (.=0), gen (ia_12men);

label var ia_1ad "Alg�n adulto tuvo una alimentaci�n basada en muy poca variedad de alimentos";
label define si_no 1 "S�" 0 "No";
label value ia_1ad si_no;

label var ia_2ad "Alg�n adulto dej� de desayunar, comer o cenar";
label var ia_3ad "Alg�n adulto comi� menos de lo que deb�a comer";
label var ia_4ad "El hogar se qued� sin comida";
label var ia_5ad "Alg�n adulto sinti� hambre pero no comi�";
label var ia_6ad "Alg�n adulto solo comi� una vez al d�a o dej� de comer todo un d�a";
label var ia_7men "Alguien de 0 a 17 a�os tuvo una alimentaci�n basada en muy poca variedad de alimentos";
label var ia_8men "Alguien de 0 a 17 a�os comi� menos de lo que deb�a";
label var ia_9men "Se tuvo que disminuir la cantidad servida en las comidas a alguien de 0 a 17 a�os";
label var ia_10men "Alguien de 0 a 17 a�os sinti� hambre pero no comi�";
label var ia_11men "Alguien de 0 a 17 a�os se acost� con hambre";
label var ia_12men "Alguien de 0 a 17 a�os comi� una vez al d�a o dej� de comer todo un d�a";

forvalues i=2(1)6 {;
label value ia_`i'ad si_no;
};

forvalues i=7(1)12 {;
label value ia_`i'men si_no;
};

*Construcci�n de la escala de inseguridad alimentaria;
sort  folioviv foliohog;
merge  folioviv foliohog using "$bases\menores14.dta";
tab _merge;
drop _merge;

*Escala para hogares sin menores de 18 a�os;
gen tot_iaad=.;
replace tot_iaad=ia_1ad + ia_2ad + ia_3ad +ia_4ad + ia_5ad+ ia_6ad if id_men==0;
label var tot_iaad "Escala de IA para hogares sin menores de 18 a�os";

*Escala para hogares con menores de 18 a�os;
gen tot_iamen=.;
replace tot_iamen=ia_1ad + ia_2ad + ia_3ad +ia_4ad + ia_5ad+ ia_6ad+ia_7men + ia_8men + ia_9men+ia_10men + ia_11men+ia_12men if id_men==1;
label var tot_iamen "Escala IA para hogares con menores de 18 a�os ";

gen ins_ali=.;
replace ins_ali=0 if tot_iaad==0 | tot_iamen==0;
replace ins_ali=1 if (tot_iaad==1 | tot_iaad==2) | (tot_iamen==1 | tot_iamen==2 |tot_iamen==3);
replace ins_ali=2 if  (tot_iaad==3 | tot_iaad==4) | (tot_iamen==4 | tot_iamen==5 |tot_iamen==6 |tot_iamen==7);
replace ins_ali=3 if (tot_iaad==5 | tot_iaad==6) | (tot_iamen>=8 & tot_iamen!=.) ;

label var  ins_ali "Grado de inseguridad alimentaria";
label define  ins_ali 0 "Seguridad alimentaria"
                      1 "Inseguridad alimentaria leve"
                      2 "Inseguridad alimentaria moderada"
                      3 "Inseguridad alimentaria severa";
label value ins_ali ins_ali;

*Indicador de carencia por acceso a la alimentaci�n;

***********************************************************************
Se considera en situaci�n de carencia por acceso a la alimentaci�n 
a la poblaci�n en hogares que:

1. Presenten inseguridad alimentaria moderada o severa.

No se considera en situaci�n de carencia por acceso a la alimentaci�n 
a la poblaci�n que:

1. No presente inseguridad alimentaria o un grado de inseguridad 
alimentaria leve.;
***********************************************************************;
gen ic_ali=.;
replace ic_ali=1 if ins_ali==2 | ins_ali==3;
replace ic_ali=0 if ins_ali==0 | ins_ali==1;
label var ic_ali "Indicador de carencia por acceso a la alimentaci�n";
label define caren 1 "Con carencia"
                    0 "Sin carencia";
label value ic_ali caren;

sort  folioviv foliohog;
keep  folioviv foliohog id_men ia_* tot_iaad tot_iamen ins_ali ic_ali;
save "$bases\ic_ali16.dta", replace;

*********************************************************
*Parte VII 
*Bienestar (ingresos)
*********************************************************;

*Para la construcci�n del ingreso corriente del hogar es necesario utilizar
informaci�n sobre la condici�n de ocupaci�n y los ingresos de los individuos.
Se utiliza la informaci�n contenida en la base "$bases\trabajo.dta" para 
identificar a la poblaci�n ocupada que declara tener como prestaci�n laboral aguinaldo, 
ya sea por su trabajo principal o secundario, a fin de incorporar los ingresos por este 
concepto en la medici�n;

*Creaci�n del ingreso monetario deflactado a pesos de agosto del 2016;

*Ingresos;

use "$data\trabajos.dta", clear;

keep  folioviv foliohog numren id_trabajo pres_8;
destring pres_8 id_trabajo, replace;
reshape wide pres_8, i( folioviv foliohog numren) j(id_trabajo);

gen trab=1;

label var trab "Poblaci�n con al menos un empleo";

gen aguinaldo1=.;
replace aguinaldo1=1 if pres_81==8;
recode aguinaldo1 (.=0);

gen aguinaldo2=.;
replace aguinaldo2=1 if pres_82==8 ;
recode aguinaldo2 (.=0);

label var aguinaldo1 "Aguinaldo trabajo principal";
label define aguinaldo 0 "No dispone de aguinaldo"
                       1 "Dispone de aguinaldo";
label value aguinaldo1 aguinaldo;
label var aguinaldo2 "Aguinaldo trabajo secundario";
label value aguinaldo2 aguinaldo;

keep  folioviv foliohog numren aguinaldo1 aguinaldo2 trab;

sort  folioviv foliohog numren ;

save "$bases\aguinaldo.dta", replace;

*Ahora se incorpora a la base de ingresos;

use "$data\ingresos.dta", clear;

sort  folioviv foliohog numren;

merge  folioviv foliohog numren using "$bases\aguinaldo.dta";

tab _merge;
drop _merge;

sort  folioviv foliohog numren;

drop if (clave=="P009" & aguinaldo1!=1);
drop if (clave=="P016" & aguinaldo2!=1);

*Una vez realizado lo anterior, se procede a deflactar el ingreso recibido
por los hogares a precios de agosto de 2016. Para ello, se utilizan las 
variables meses, las cuales toman los valores 2 a 10 e indican el mes en
que se recibi� el ingreso respectivo;

*Definici�n de los deflactores 2016 ;

scalar	dic15	=	0.9915096155	;
scalar	ene16	=	0.9952905552	;
scalar	feb16	=	0.9996486737	;
scalar	mar16	=	1.0011208981	;
scalar	abr16	=	0.9979505968	;
scalar	may16	=	0.9935004643	;
scalar	jun16	=	0.9945962676	;
scalar	jul16	=	0.9971893899	;
scalar	ago16	=	1.0000000000	;
scalar	sep16	=	1.0061063849	;
scalar	oct16	=	1.0122127699	;
scalar	nov16	=	1.0201259756	;
scalar	dic16	=	1.0248270555	;

destring mes_*, replace;
replace ing_6=ing_6/feb16 if mes_6==2;
replace ing_6=ing_6/mar16 if mes_6==3;
replace ing_6=ing_6/abr16 if mes_6==4;
replace ing_6=ing_6/may16 if mes_6==5;


replace ing_5=ing_5/mar16 if mes_5==3;
replace ing_5=ing_5/abr16 if mes_5==4;
replace ing_5=ing_5/may16 if mes_5==5;
replace ing_5=ing_5/jun16 if mes_5==6;

replace ing_4=ing_4/abr16 if mes_4==4;
replace ing_4=ing_4/may16 if mes_4==5;
replace ing_4=ing_4/jun16 if mes_4==6;
replace ing_4=ing_4/jul16 if mes_4==7;

replace ing_3=ing_3/may16 if mes_3==5;
replace ing_3=ing_3/jun16 if mes_3==6;
replace ing_3=ing_3/jul16 if mes_3==7;
replace ing_3=ing_3/ago16 if mes_3==8;

replace ing_2=ing_2/jun16 if mes_2==6;
replace ing_2=ing_2/jul16 if mes_2==7;
replace ing_2=ing_2/ago16 if mes_2==8;
replace ing_2=ing_2/sep16 if mes_2==9;

replace ing_1=ing_1/jul16 if mes_1==7;
replace ing_1=ing_1/ago16 if mes_1==8;
replace ing_1=ing_1/sep16 if mes_1==9;
replace ing_1=ing_1/oct16 if mes_1==10;


*Se deflactan las claves P008 y P015 (Reparto de utilidades) 
y P009 y P016 (aguinaldo)
con los deflactores de mayo a agosto 2016 
y de diciembre de 2015 a agosto 2016, 
respectivamente, y se obtiene el promedio mensual.;

replace ing_1=(ing_1/may16)/12 if clave=="P008" | clave=="P015";
replace ing_1=(ing_1/dic15)/12 if clave=="P009" | clave=="P016";

recode ing_2 ing_3 ing_4 ing_5 ing_6 (0=.) if clave=="P008" | clave=="P009" | clave=="P015" | clave=="P016";

*Una vez realizada la deflactaci�n, se procede a obtener el 
ingreso mensual promedio en los �ltimos seis meses, para 
cada persona y clave de ingreso;

egen double ing_mens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6);

*Para obtener el ingreso corriente monetario, se seleccionan 
las claves de ingreso correspondientes;

gen double ing_mon=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P048") | (clave>="P067" & clave<="P081");

*Para obtener el ingreso laboral, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_lab=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P022") | (clave>="P067" & clave<="P081");

*Para obtener el ingreso por rentas, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_ren=ing_mens if (clave>="P023" & clave<="P031");

*Para obtener el ingreso por transferencias, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_tra=ing_mens if (clave>="P032" & clave<="P048");

							 
*Se estima el total de ingresos de cada  hogar;

collapse (sum) ing_mon ing_lab ing_ren ing_tra, by( folioviv foliohog);

label var ing_mon "Ingreso corriente monetario del hogar";
label var ing_lab "Ingreso corriente monetario laboral";
label var ing_ren "Ingreso corriente monetario por rentas";
label var ing_tra "Ingreso corriente monetario por transferencias";
							 
sort  folioviv foliohog;

save "$bases\ingreso_deflactado16.dta", replace;

*********************************************************

Creaci�n del ingreso no monetario deflactado a pesos de 
agosto del 2016.

*********************************************************;

*No Monetario;

use "$data\gastoshogar.dta", clear;
gen base=1;
append using "$data\gastospersona.dta";
recode base (.=2);

compress;

replace frecuencia=frec_rem if base==2;

label var base "Origen del monto";
label define base 1 "Monto del hogar"
                       2 "Monto de personas";
label value base base;

*En el caso de la informaci�n de gasto no monetario, para 
deflactar se utiliza la decena de levantamiento de la 
encuesta, la cual se encuentra en la octava posici�n del 
folio de la vivienda. En primer lugar se obtiene una variable que 
identifique la decena de levantamiento;

gen decena=real(substr(folioviv,8,1));

*Definici�n de los deflactores;		
		
*Rubro 1.1 semanal, Alimentos;		
scalar d11w07=	0.9985457696	;
scalar d11w08=	1.0000000000	;
scalar d11w09=	1.0167932672	;
scalar d11w10=	1.0199415214	;
scalar d11w11=	1.0251086805	;
		
*Rubro 1.2 semanal, Bebidas alcoh�licas y tabaco;		
scalar d12w07=	0.9959845820	;
scalar d12w08=	1.0000000000	;
scalar d12w09=	1.0066744829	;
scalar d12w10=	1.0087894741	;
scalar d12w11=	1.0100998490	;
		
*Rubro 2 trimestral, Vestido, calzado y accesorios;		
scalar d2t05=	0.9920067602	;
scalar d2t06=	0.9948005139	;
scalar d2t07=	0.9986462366	;
scalar d2t08=	1.0053546946	;
		
*Rubro 3 mensual, viviendas;		
scalar d3m07=	1.0017314941	;
scalar d3m08=	1.0000000000	;
scalar d3m09=	0.9978188915	;
scalar d3m10=	1.0133832055	;
scalar d3m11=	1.0358543632	;
		
*Rubro 4.2 mensual, Accesorios y art�culos de limpieza para el hogar;		
scalar d42m07=	0.9936894797	;
scalar d42m08=	1.0000000000	;
scalar d42m09=	1.0041605121	;
scalar d42m10=	1.0056376169	;
scalar d42m11=	1.0087477433	;
		
*Rubro 4.2 trimestral, Accesorios y art�culos de limpieza para el hogar;		
scalar d42t05=	0.9932545544	;
scalar d42t06=	0.9960501122	;
scalar d42t07=	0.9992833306	;
scalar d42t08=	1.0032660430	;
		
*Rubro 4.1 semestral, Muebles y aparatos d�mesticos;		
scalar d41s02=	1.0081456317	;
scalar d41s03=	1.0057381027	;
scalar d41s04=	1.0038444337	;
scalar d41s05=	1.0025359940	;
		
*Rubro 5.1 trimestral, Salud;		
scalar d51t05=	0.9948500567	;
scalar d51t06=	0.9974422922	;
scalar d51t07=	1.0000318717	;
scalar d51t08=	1.0028179937	;
		
*Rubro 6.1.1 semanal, Transporte p�blico urbano;		
scalar d611w07=	0.9998162514	;
scalar d611w08=	1.0000000000	;
scalar d611w09=	1.0010465683	;
scalar d611w10=	1.0030038907	;
scalar d611w11=	1.0040584480	;
		
*Rubro 6 mensual, Transporte;		
scalar d6m07=	0.9907765708	;
scalar d6m08=	1.0000000000	;
scalar d6m09=	1.0049108739	;
scalar d6m10=	1.0097440440	;
scalar d6m11=	1.0137147031	;
		
*Rubro 6 semestral, Transporte;		
scalar d6s02=	0.9749314912	;
scalar d6s03=	0.9796636466	;
scalar d6s04=	0.9851637735	;
scalar d6s05=	0.9917996695	;
		
*Rubro 7 mensual, Educaci�n y esparcimiento;		
scalar d7m07=	0.9997765641	;
scalar d7m08=	1.0000000000	;
scalar d7m09=	1.0128930818	;
scalar d7m10=	1.0131744455	;
scalar d7m11=	1.0158805031	;
		
*Rubro 2.3 mensual, Accesorios y cuidados del vestido;		
scalar d23m07=	0.9923456541	;
scalar d23m08=	1.0000000000	;
scalar d23m09=	1.0029207372	;
scalar d23m10=	1.0029710948	;
scalar d23m11=	1.0057155806	;
		
*Rubro 2.3 trimestral,  Accesorios y cuidados del vestido;		
scalar d23t05=	0.9913748727	;
scalar d23t06=	0.9950229966	;
scalar d23t07=	0.9984221305	;
scalar d23t08=	1.0019639440	;
		
*INPC semestral;		
scalar dINPCs02=	0.9973343817	;
scalar dINPCs03=	0.9973929361	;
scalar dINPCs04=	0.9982238506	;
scalar dINPCs05=	1.0006008794	;


*Una vez definidos los deflactores, se seleccionan los rubros;

gen double gasnomon=gas_nm_tri/3;

gen esp=1 if tipo_gasto=="G4";
gen reg=1 if tipo_gasto=="G5";
replace reg=1 if tipo_gasto=="G6";
drop if tipo_gasto=="G2" | tipo_gasto=="G3" | tipo_gasto=="G7";

*Control para la frecuencia de los regalos recibidos por el hogar;
drop if ((frecuencia>="5" & frecuencia<="6") | frecuencia==" " | frecuencia=="0") & base==1 & tipo_gasto=="G5";

*Control para la frecuencia de los regalos recibidos por persona;

drop if ((frecuencia=="9") | frecuencia==" ") & base==2 & tipo_gasto=="G5";

*Gasto en Alimentos deflactado (semanal) ;

gen ali_nm=gasnomon if (clave>="A001" & clave<="A222") | 
(clave>="A242" & clave<="A247");

replace ali_nm=ali_nm/d11w08 if decena==1;
replace ali_nm=ali_nm/d11w08 if decena==2;
replace ali_nm=ali_nm/d11w08 if decena==3;
replace ali_nm=ali_nm/d11w09 if decena==4;
replace ali_nm=ali_nm/d11w09 if decena==5;
replace ali_nm=ali_nm/d11w09 if decena==6;
replace ali_nm=ali_nm/d11w10 if decena==7;
replace ali_nm=ali_nm/d11w10 if decena==8;
replace ali_nm=ali_nm/d11w10 if decena==9;
replace ali_nm=ali_nm/d11w11 if decena==0;

*Gasto en Alcohol y tabaco deflactado (semanal);

gen alta_nm=gasnomon if (clave>="A223" & clave<="A241");

replace alta_nm=alta_nm/d12w08 if decena==1;
replace alta_nm=alta_nm/d12w08 if decena==2;
replace alta_nm=alta_nm/d12w08 if decena==3;
replace alta_nm=alta_nm/d12w09 if decena==4;
replace alta_nm=alta_nm/d12w09 if decena==5;
replace alta_nm=alta_nm/d12w09 if decena==6;
replace alta_nm=alta_nm/d12w10 if decena==7;
replace alta_nm=alta_nm/d12w10 if decena==8;
replace alta_nm=alta_nm/d12w10 if decena==9;
replace alta_nm=alta_nm/d12w11 if decena==0;

*Gasto en Vestido y calzado deflactado (trimestral);

gen veca_nm=gasnomon if (clave>="H001" & clave<="H122") | 
(clave=="H136");

replace veca_nm=veca_nm/d2t05 if decena==1;
replace veca_nm=veca_nm/d2t05 if decena==2;
replace veca_nm=veca_nm/d2t06 if decena==3;
replace veca_nm=veca_nm/d2t06 if decena==4;
replace veca_nm=veca_nm/d2t06 if decena==5;
replace veca_nm=veca_nm/d2t07 if decena==6;
replace veca_nm=veca_nm/d2t07 if decena==7;
replace veca_nm=veca_nm/d2t07 if decena==8;
replace veca_nm=veca_nm/d2t08 if decena==9;
replace veca_nm=veca_nm/d2t08 if decena==0;

*Gasto en viviendas y servicios de conservaci�n deflactado (mensual);

gen viv_nm=gasnomon if (clave>="G001" & clave<="G016") | (clave>="R001" & clave<="R004") 
						| clave=="R013";

replace viv_nm=viv_nm/d3m07 if decena==1;
replace viv_nm=viv_nm/d3m07 if decena==2;
replace viv_nm=viv_nm/d3m08 if decena==3;
replace viv_nm=viv_nm/d3m08 if decena==4;
replace viv_nm=viv_nm/d3m08 if decena==5;
replace viv_nm=viv_nm/d3m09 if decena==6;
replace viv_nm=viv_nm/d3m09 if decena==7;
replace viv_nm=viv_nm/d3m09 if decena==8;
replace viv_nm=viv_nm/d3m10 if decena==9;
replace viv_nm=viv_nm/d3m10 if decena==0;

*Gasto en Art�culos de limpieza deflactado (mensual);

gen lim_nm=gasnomon if (clave>="C001" & clave<="C024");

replace lim_nm=lim_nm/d42m07 if decena==1;
replace lim_nm=lim_nm/d42m07 if decena==2;
replace lim_nm=lim_nm/d42m08 if decena==3;
replace lim_nm=lim_nm/d42m08 if decena==4;
replace lim_nm=lim_nm/d42m08 if decena==5;
replace lim_nm=lim_nm/d42m09 if decena==6;
replace lim_nm=lim_nm/d42m09 if decena==7;
replace lim_nm=lim_nm/d42m09 if decena==8;
replace lim_nm=lim_nm/d42m10 if decena==9;
replace lim_nm=lim_nm/d42m10 if decena==0;

*Gasto en Cristaler�a y blancos deflactado (trimestral);

gen cris_nm=gasnomon if (clave>="I001" & clave<="I026");

replace cris_nm=cris_nm/d42t05 if decena==1;
replace cris_nm=cris_nm/d42t05 if decena==2;
replace cris_nm=cris_nm/d42t06 if decena==3;
replace cris_nm=cris_nm/d42t06 if decena==4;
replace cris_nm=cris_nm/d42t06 if decena==5;
replace cris_nm=cris_nm/d42t07 if decena==6;
replace cris_nm=cris_nm/d42t07 if decena==7;
replace cris_nm=cris_nm/d42t07 if decena==8;
replace cris_nm=cris_nm/d42t08 if decena==9;
replace cris_nm=cris_nm/d42t08 if decena==0;

*Gasto en Enseres dom�sticos y muebles deflactado (semestral);

gen ens_nm=gasnomon if (clave>="K001" & clave<="K037");

replace ens_nm=ens_nm/d41s02 if decena==1;
replace ens_nm=ens_nm/d41s02 if decena==2;
replace ens_nm=ens_nm/d41s03 if decena==3;
replace ens_nm=ens_nm/d41s03 if decena==4;
replace ens_nm=ens_nm/d41s03 if decena==5;
replace ens_nm=ens_nm/d41s04 if decena==6;
replace ens_nm=ens_nm/d41s04 if decena==7;
replace ens_nm=ens_nm/d41s04 if decena==8;
replace ens_nm=ens_nm/d41s05 if decena==9;
replace ens_nm=ens_nm/d41s05 if decena==0;

*Gasto en Salud deflactado (trimestral);

gen sal_nm=gasnomon if (clave>="J001" & clave<="J072");

replace sal_nm=sal_nm/d51t05 if decena==1;
replace sal_nm=sal_nm/d51t05 if decena==2;
replace sal_nm=sal_nm/d51t06 if decena==3;
replace sal_nm=sal_nm/d51t06 if decena==4;
replace sal_nm=sal_nm/d51t06 if decena==5;
replace sal_nm=sal_nm/d51t07 if decena==6;
replace sal_nm=sal_nm/d51t07 if decena==7;
replace sal_nm=sal_nm/d51t07 if decena==8;
replace sal_nm=sal_nm/d51t08 if decena==9;
replace sal_nm=sal_nm/d51t08 if decena==0;

*Gasto en Transporte p�blico deflactado (semanal);

gen tpub_nm=gasnomon if (clave>="B001" & clave<="B007");

replace tpub_nm=tpub_nm/d611w08 if decena==1;
replace tpub_nm=tpub_nm/d611w08 if decena==2;
replace tpub_nm=tpub_nm/d611w08 if decena==3;
replace tpub_nm=tpub_nm/d611w09 if decena==4;
replace tpub_nm=tpub_nm/d611w09 if decena==5;
replace tpub_nm=tpub_nm/d611w09 if decena==6;
replace tpub_nm=tpub_nm/d611w10 if decena==7;
replace tpub_nm=tpub_nm/d611w10 if decena==8;
replace tpub_nm=tpub_nm/d611w10 if decena==9;
replace tpub_nm=tpub_nm/d611w11 if decena==0;


*Gasto en Transporte for�neo deflactado (semestral);

gen tfor_nm=gasnomon if (clave>="M001" & clave<="M018") | 
(clave>="F007" & clave<="F014");

replace tfor_nm=tfor_nm/d6s02 if decena==1;
replace tfor_nm=tfor_nm/d6s02 if decena==2;
replace tfor_nm=tfor_nm/d6s03 if decena==3;
replace tfor_nm=tfor_nm/d6s03 if decena==4;
replace tfor_nm=tfor_nm/d6s03 if decena==5;
replace tfor_nm=tfor_nm/d6s04 if decena==6;
replace tfor_nm=tfor_nm/d6s04 if decena==7;
replace tfor_nm=tfor_nm/d6s04 if decena==8;
replace tfor_nm=tfor_nm/d6s05 if decena==9;
replace tfor_nm=tfor_nm/d6s05 if decena==0;

*Gasto en Comunicaciones deflactado (mensual);

gen com_nm=gasnomon if (clave>="F001" & clave<="F006") | (clave>="R005" & clave<="R008")
| (clave>="R010" & clave<="R011");

replace com_nm=com_nm/d6m07 if decena==1;
replace com_nm=com_nm/d6m07 if decena==2;
replace com_nm=com_nm/d6m08 if decena==3;
replace com_nm=com_nm/d6m08 if decena==4;
replace com_nm=com_nm/d6m08 if decena==5;
replace com_nm=com_nm/d6m09 if decena==6;
replace com_nm=com_nm/d6m09 if decena==7;
replace com_nm=com_nm/d6m09 if decena==8;
replace com_nm=com_nm/d6m10 if decena==9;
replace com_nm=com_nm/d6m10 if decena==0;

*Gasto en Educaci�n y recreaci�n deflactado (mensual);

gen edre_nm=gasnomon if (clave>="E001" & clave<="E034") | 
(clave>="H134" & clave<="H135") | (clave>="L001" & 
clave<="L029") | (clave>="N003" & clave<="N005") | clave=="R009";

replace edre_nm=edre_nm/d7m07 if decena==1;
replace edre_nm=edre_nm/d7m07 if decena==2;
replace edre_nm=edre_nm/d7m08 if decena==3;
replace edre_nm=edre_nm/d7m08 if decena==4;
replace edre_nm=edre_nm/d7m08 if decena==5;
replace edre_nm=edre_nm/d7m09 if decena==6;
replace edre_nm=edre_nm/d7m09 if decena==7;
replace edre_nm=edre_nm/d7m09 if decena==8;
replace edre_nm=edre_nm/d7m10 if decena==9;
replace edre_nm=edre_nm/d7m10 if decena==0;

*Gasto en Educaci�n b�sica deflactado (mensual);

gen edba_nm=gasnomon if (clave>="E002" & clave<="E003") | 
(clave>="H134" & clave<="H135");

replace edba_nm=edba_nm/d7m07 if decena==1;
replace edba_nm=edba_nm/d7m07 if decena==2;
replace edba_nm=edba_nm/d7m08 if decena==3;
replace edba_nm=edba_nm/d7m08 if decena==4;
replace edba_nm=edba_nm/d7m08 if decena==5;
replace edba_nm=edba_nm/d7m09 if decena==6;
replace edba_nm=edba_nm/d7m09 if decena==7;
replace edba_nm=edba_nm/d7m09 if decena==8;
replace edba_nm=edba_nm/d7m10 if decena==9;
replace edba_nm=edba_nm/d7m10 if decena==0;

*Gasto en Cuidado personal deflactado (mensual);

gen cuip_nm=gasnomon if (clave>="D001" & clave<="D026") | 
(clave=="H132");

replace cuip_nm=cuip_nm/d23m07 if decena==1;
replace cuip_nm=cuip_nm/d23m07 if decena==2;
replace cuip_nm=cuip_nm/d23m08 if decena==3;
replace cuip_nm=cuip_nm/d23m08 if decena==4;
replace cuip_nm=cuip_nm/d23m08 if decena==5;
replace cuip_nm=cuip_nm/d23m09 if decena==6;
replace cuip_nm=cuip_nm/d23m09 if decena==7;
replace cuip_nm=cuip_nm/d23m09 if decena==8;
replace cuip_nm=cuip_nm/d23m10 if decena==9;
replace cuip_nm=cuip_nm/d23m10 if decena==0;

*Gasto en Accesorios personales deflactado (trimestral);

gen accp_nm=gasnomon if (clave>="H123" & clave<="H131") | 
(clave=="H133");

replace accp_nm=accp_nm/d23t05 if decena==1;
replace accp_nm=accp_nm/d23t05 if decena==2;
replace accp_nm=accp_nm/d23t06 if decena==3;
replace accp_nm=accp_nm/d23t06 if decena==4;
replace accp_nm=accp_nm/d23t06 if decena==5;
replace accp_nm=accp_nm/d23t07 if decena==6;
replace accp_nm=accp_nm/d23t07 if decena==7;
replace accp_nm=accp_nm/d23t07 if decena==8;
replace accp_nm=accp_nm/d23t08 if decena==9;
replace accp_nm=accp_nm/d23t08 if decena==0;

*Gasto en Otros gastos y transferencias deflactado (semestral);

gen otr_nm=gasnomon if (clave>="N001" & clave<="N002") | 
(clave>="N006" & clave<="N016") | (clave>="T901" & 
clave<="T915") | (clave=="R012");

replace otr_nm=otr_nm/dINPCs02 if decena==1;
replace otr_nm=otr_nm/dINPCs02 if decena==2;
replace otr_nm=otr_nm/dINPCs03 if decena==3;
replace otr_nm=otr_nm/dINPCs03 if decena==4;
replace otr_nm=otr_nm/dINPCs03 if decena==5;
replace otr_nm=otr_nm/dINPCs04 if decena==6;
replace otr_nm=otr_nm/dINPCs04 if decena==7;
replace otr_nm=otr_nm/dINPCs04 if decena==8;
replace otr_nm=otr_nm/dINPCs05 if decena==9;
replace otr_nm=otr_nm/dINPCs05 if decena==0;

*Gasto en Regalos Otorgados deflactado;

gen reda_nm=gasnomon if (clave>="T901" & clave<="T915") | (clave=="N013");

replace reda_nm=reda_nm/dINPCs02 if decena==1;
replace reda_nm=reda_nm/dINPCs02 if decena==2;
replace reda_nm=reda_nm/dINPCs03 if decena==3;
replace reda_nm=reda_nm/dINPCs03 if decena==4;
replace reda_nm=reda_nm/dINPCs03 if decena==5;
replace reda_nm=reda_nm/dINPCs04 if decena==6;
replace reda_nm=reda_nm/dINPCs04 if decena==7;
replace reda_nm=reda_nm/dINPCs04 if decena==8;
replace reda_nm=reda_nm/dINPCs05 if decena==9;
replace reda_nm=reda_nm/dINPCs05 if decena==0;

save "$bases\ingresonomonetario_def16.dta", replace;

use "$bases\ingresonomonetario_def16.dta", clear;

*Construcci�n de la base de pagos en especie a partir de la base 
de gasto no monetario;

keep if esp==1;

collapse (sum) *_nm, by( folioviv foliohog);

rename  ali_nm ali_nme;
rename  alta_nm alta_nme;
rename  veca_nm veca_nme;
rename  viv_nm viv_nme;
rename  lim_nm lim_nme;
rename  cris_nm cris_nme;
rename  ens_nm ens_nme;
rename  sal_nm sal_nme;
rename  tpub_nm tpub_nme;
rename  tfor_nm tfor_nme;
rename  com_nm com_nme; 
rename  edre_nm edre_nme;
rename  edba_nm edba_nme;
rename  cuip_nm cuip_nme;
rename  accp_nm accp_nme;
rename  otr_nm otr_nme;
rename  reda_nm reda_nme;

sort  folioviv foliohog;

save "$bases\esp_def16.dta", replace;

use "$bases\ingresonomonetario_def16.dta", clear;

*Construcci�n de base de regalos a partir de la base no 
monetaria ;

keep if reg==1;

collapse (sum) *_nm, by( folioviv foliohog);

rename  ali_nm ali_nmr;
rename  alta_nm alta_nmr;
rename  veca_nm veca_nmr;
rename  viv_nm viv_nmr;
rename  lim_nm lim_nmr;
rename  cris_nm cris_nmr;
rename  ens_nm ens_nmr;
rename  sal_nm sal_nmr;
rename  tpub_nm tpub_nmr;
rename  tfor_nm tfor_nmr;
rename  com_nm com_nmr; 
rename  edre_nm edre_nmr;
rename  edba_nm edba_nmr;
rename  cuip_nm cuip_nmr;
rename  accp_nm accp_nmr;
rename  otr_nm otr_nmr;
rename  reda_nm reda_nmr;

sort  folioviv foliohog;

save "$bases\reg_def16.dta", replace;

*********************************************************

Construcci�n del ingreso corriente total

*********************************************************;

use "$data\concentradohogar.dta", clear;

keep  folioviv foliohog tam_loc factor tot_integ est_dis upm ubica_geo;

*Incorporaci�n de la base de ingreso monetario deflactado;

sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\ingreso_deflactado16.dta";
tab _merge;
drop _merge;

*Incorporaci�n de la base de ingreso no monetario deflactado: pago en especie;

sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\esp_def16.dta";
tab _merge;
drop _merge;

*Incorporaci�n de la base de ingreso no monetario deflactado: regalos en especie;

sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\reg_def16.dta";
tab _merge;
drop _merge;

gen rururb=1 if tam_loc=="4";
replace rururb=0 if tam_loc<="3";
label define rururb 1 "Rural" 
                    0 "Urbano";
label value rururb rururb;

egen double pago_esp=rsum(ali_nme alta_nme veca_nme 
viv_nme lim_nme ens_nme cris_nme sal_nme 
tpub_nme tfor_nme com_nme edre_nme cuip_nme 
accp_nme otr_nme);

egen double reg_esp=rsum(ali_nmr alta_nmr veca_nmr 
viv_nmr lim_nmr ens_nmr cris_nmr sal_nmr 
tpub_nmr tfor_nmr com_nmr edre_nmr cuip_nmr 
accp_nmr otr_nmr);

egen double nomon=rsum(pago_esp reg_esp);

egen double ict=rsum(ing_mon nomon);

label var ict "Ingreso corriente total";
label var nomon "Ingreso corriente no monetario";
label var pago_esp "Ingreso corriente no monetario pago especie";
label var reg_esp "Ingreso corriente no monetario regalos especie";

sort  folioviv foliohog;

save "$bases\ingresotot16.dta", replace;

***********************************************************

Construcci�n del tama�o de hogar con econom�as de escala
y escalas de equivalencia

***********************************************************;

use "$data\poblacion.dta", clear;
*Poblaci�n objeto: no se incluye a hu�spedes ni trabajadores dom�sticos;

drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Total de integrantes del hogar;
gen ind=1;
egen tot_ind=sum(ind), by ( folioviv foliohog);

*************************
*Escalas de equivalencia*
*************************;

gen n_05=.;
replace n_05=1 if edad>=0 & edad<=5;
recode n_05 (.=0) if edad!=.;

gen n_6_12=0;
replace n_6_12=1 if edad>=6 & edad<=12;
recode n_6_12 (.=0) if edad!=.;

gen n_13_18=0;
replace n_13_18=1 if edad>=13 & edad<=18;
recode n_13_18 (.=0) if edad!=.;

gen n_19=0;
replace n_19=1 if edad>=19 & edad!=.;
recode n_05 (.=0) if edad!=.;

gen tamhogesc=n_05*.7031;
replace tamhogesc=n_6_12*.7382 if n_6_12==1;
replace tamhogesc=n_13_18*.7057 if n_13_18==1;
replace tamhogesc=n_19*.9945 if n_19==1 ;
replace tamhogesc=1 if tot_ind==1;

collapse (sum)  tamhogesc, by( folioviv foliohog);

sort  folioviv foliohog;

save "$bases\tamhogesc16.dta", replace;

*************************************************************************

*Bienestar por ingresos

*************************************************************************;

use "$bases\ingresotot16.dta", clear;

*Incorporaci�n de la informaci�n sobre el tama�o del hogar ajustado;

merge  folioviv foliohog using "$bases\tamhogesc16.dta";
tab _merge;
drop _merge;

*Informaci�n per capita;

gen double ictpc= ict/tamhogesc;

label var  ictpc "Ingreso corriente total per capita";

*************************************************************************

*Indicador de Bienestar por ingresos

*************************************************************************

LP I: Valor de la Canasta para bienestar m�nimo 

LP II: Valor de la Canasta Alimentaria m�s el valor de la canasta
no alimentaria (ver Anexo A del documento metodol�gico).

En este programa se construyen los indicadores de bienestar por ingresos
mediante las 2 l�neas definidas por CONEVAL , denomin�ndoles:

lp1 : L�nea de Bienestar M�nimo
lp2 : L�nea de Bienestar

************************************************************************;


*Bienestar m�nimo;

*Valor de la canasta b�sica (ver Nota T�cnica);

scalar lp1_urb = 1310.94;
scalar lp1_rur = 933.20;

*Se identifica a los hogares bajo LP1;

gen  plb_m=1 if ictpc<lp1_urb & rururb==0;
replace plb_m=0 if ictpc>=lp1_urb & rururb==0 & ictpc!=.;
replace plb_m=1 if ictpc<lp1_rur & rururb==1;
replace plb_m=0 if ictpc>=lp1_rur & rururb==1 & ictpc!=.;

*Bienestar;

scalar lp2_urb = 2660.40;
scalar lp2_rur = 1715.57;

gen  plb=1 if (ictpc<lp2_urb & rururb==0);
replace plb=0 if (ictpc>=lp2_urb & rururb==0) & ictpc!=.;
replace plb=1 if (ictpc<lp2_rur & rururb==1);
replace plb=0 if (ictpc>=lp2_rur & rururb==1) & ictpc!=.;

label var factor "Factor de expansi�n";
label var tam_loc "Tama�o de la localidad";
label var rururb "Identificador de localidades rurales";
label var tot_integ "Total de integrantes del hogar";
label var tamhogesc "Tama�o de hogar ajustado";
label var ict "Ingreso corriente total del hogar";
label var ictpc "Ingreso corriente total per c�pita";
label var plb_m "Poblaci�n con ingreso menor a la l�nea de bienestar m�nimo";
label var plb "Poblaci�n con ingreso menor a la l�nea de bienestar";

keep  folioviv foliohog factor tam_loc
rururb tamhogesc ict ictpc plb_m plb est_dis upm ubica_geo tot_integ 
ing_mon ing_lab ing_ren ing_tra nomon pago_esp reg_esp; 

sort  folioviv foliohog;

save "$bases\p_ingresos16.dta", replace;

************************************************************************

*Parte VIII Pobreza 

************************************************************************;

**************************
Integraci�n de las bases*
*************************;

use "$bases\ic_rezedu16.dta", clear;

merge  folioviv foliohog numren using "$bases\ic_asalud16.dta";
tab _merge;
drop _merge;
sort  folioviv foliohog numren;

merge  folioviv foliohog numren using "$bases\ic_segsoc16.dta";
tab _merge;
drop _merge;
sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\ic_cev16.dta";
tab _merge;
drop _merge;
sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\ic_sbv16.dta";
tab _merge;
drop _merge;
sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\ic_ali16.dta";
tab _merge;
drop _merge;
sort  folioviv foliohog;

merge  folioviv foliohog using "$bases\p_ingresos16.dta";
tab _merge;
drop _merge;

duplicates drop  folioviv foliohog numren, force;

gen ent=real(substr(folioviv,1,2));

recode ing_* (.=0) if ictpc!=0 | ing_mon==.;

label var ent "Identificador de la entidad federativa";

label define ent 
1	"Aguascalientes"
2	"Baja California"
3	"Baja California Sur"
4	"Campeche"
5	"Coahuila"
6	"Colima"
7	"Chiapas"
8	"Chihuahua"
9	"Ciudad de M�xico"
10	"Durango"
11	"Guanajuato"
12	"Guerrero"
13	"Hidalgo"
14	"Jalisco"
15	"M�xico"
16	"Michoac�n"
17	"Morelos"
18	"Nayarit"
19	"Nuevo Le�n"
20	"Oaxaca"
21	"Puebla"
22	"Quer�taro"
23	"Quintana Roo"
24	"San Luis Potos�"
25	"Sinaloa"
26	"Sonora"
27	"Tabasco"
28	"Tamaulipas"
29	"Tlaxcala"
30	"Veracruz"
31	"Yucat�n"
32	"Zacatecas";
label value ent ent;

****************************
*�ndice de Privaci�n Social
****************************;

egen i_privacion=rsum(ic_rezedu ic_asalud ic_segsoc ic_cv ic_sbv ic_ali);
replace i_privacion=. if ic_rezedu==. | ic_asalud==. | ic_segsoc==. | 
ic_cv==. | ic_sbv==. | ic_ali==.;

label var i_privacion "�ndice de Privaci�n Social";

***************************
*Pobreza 
***************************;

*Pobreza;
gen pobreza=1 if plb==1 & (i_privacion>=1 & i_privacion!=.);
replace pobreza=0 if (plb==0 | i_privacion==0) & (plb!=. & i_privacion!=.);
label var pobreza "Pobreza";
label define pobreza 0 "No pobre" 
                     1 "Pobre";
label value pobreza pobreza;

*Pobreza extrema;
gen pobreza_e=1 if plb_m==1 & (i_privacion>=3 & i_privacion!=.);
replace pobreza_e=0 if (plb_m==0 | i_privacion<3) & (plb_m!=. & i_privacion!=.);
label var pobreza_e "Pobreza extrema";
label define pobreza_e 0 "No pobre extremo" 
                      1 "Pobre extremo";
label value pobreza_e pobreza_e;

*Pobreza moderada;
gen pobreza_m=1 if pobreza==1 & pobreza_e==0;
replace pobreza_m=0 if pobreza==0 | (pobreza==1 & pobreza_e==1);
label var pobreza_m "Pobreza moderada";
label define pobreza_m 0 "No pobre moderado" 
                      1 "Pobre moderado";
label value pobreza_m pobreza_m;

*******************************
*Poblaci�n vulnerable
*******************************;

*Vulnerables por carencias;
gen vul_car=cond(plb==0 & (i_privacion>=1 & i_privacion!=.),1,0);
replace vul_car=. if pobreza==.;
label var vul_car "Poblaci�n vulnerable por carencias";
label define vul 0 "No vulnerable" 
                     1 "Vulnerable";
label value vul_car vul;

*Vulnerables por ingresos;
gen vul_ing=cond(plb==1 & i_privacion==0,1,0);
replace vul_ing=. if pobreza==.;
label var vul_ing "Poblaci�n vulnerable por ingresos";
label value vul_ing vul;

****************************************************
*Poblaci�n no pobre y no vulnerable
****************************************************;

gen no_pobv=cond(plb==0 & i_privacion==0,1,0);
replace no_pobv=. if pobreza==.;
label var no_pobv "Poblaci�n no pobre y no vulnerable";
label define no_pobv 0 "Pobre o vulnerable" 
					1 "No pobre y no vulnerable";
label value no_pobv no_pobv;

***********************************
*Poblaci�n con carencias sociales 
***********************************;

gen carencias=cond(i_privacion>=1 & i_privacion!=.,1,0);
replace carencias=. if pobreza==.;
label var carencias "Poblaci�n con al menos una carencia";
label define carencias  0 "Poblaci�n sin carencias" 
						1 "Poblaci�n con carencias";
label value carencias carencias;

gen carencias3=cond(i_privacion>=3 & i_privacion!=.,1,0);
replace carencias3=. if pobreza==.;
label var carencias3 "Poblaci�n con tres o m�s carencias";
label define carencias3 0 "Poblaci�n con menos de tres carencias" 
						1 "Poblaci�n con tres o m�s carencias";
label value carencias3 carencias3;

************
*Cuadrantes
************;

gen cuadrantes=.;
replace cuadrantes=1 if plb==1 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=2 if plb==0 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=3 if plb==1 & i_privacion==0;
replace cuadrantes=4 if plb==0 & i_privacion==0;
label var cuadrantes "Cuadrantes de Bienestar y Derechos sociales";
label define cuadrantes 1 "Pobres"
						2 "Vulnerables por carencias" 
						3 "Vulnerables por ingresos"
						4 "No pobres y no vulnerables";
label value cuadrantes cuadrantes;

*****************************************
*Profundidad en el espacio del bienestar
*****************************************;

*FGT (a=1);

*Distancia normalizada del ingreso respecto a la l�nea de bienestar;
gen prof_b1=(lp2_rur-ictpc)/(lp2_rur) if rururb==1 & plb==1;
replace prof_b1=(lp2_urb-ictpc)/(lp2_urb) if rururb==0 & plb==1;
recode prof_b1 (.=0) if ictpc!=.;
label var prof_b1 "�ndice FGT con alfa igual a 1 (l�nea de bienestar)";

*Distancia normalizada del ingreso respecto a la l�nea de bienestar m�nimo;
gen prof_bm1=(lp1_rur-ictpc)/(lp1_rur) if rururb==1 & plb_m==1;
replace prof_bm1=(lp1_urb-ictpc)/(lp1_urb) if rururb==0 & plb_m==1;
recode prof_bm1 (.=0) if ictpc!=.;
label var prof_bm1 "�ndice FGT con alfa igual a 1 (l�nea de bienestar m�nimo)";

************************************
*Profundidad de la privaci�n social
************************************;

gen profun=i_privacion/6;
label var profun "Profundidad de la privaci�n social";

***********************************
*Intensidad de la privaci�n social
***********************************;

*Poblaci�n pobre;
gen int_pob=profun*pobreza;
label var int_pob "Intensidad de la privaci�n social: pobres";

*Poblaci�n pobre extrema;
gen int_pobe=profun*pobreza_e;
label var int_pobe "Intensidad de la privaci�n social: pobres extremos";

*Poblaci�n vulnerable por carencias;
gen int_vulcar=profun*vul_car;
label var int_vulcar "Intensidad de la privaci�n social: poblaci�n vulnerable por carencias";

*Poblaci�n carenciada;
gen int_caren=profun*carencias;
label var int_caren "Intensidad de la privaci�n social: poblaci�n carenciada";

keep 	 folioviv foliohog numren factor tam_loc rururb ent ubica_geo edad sexo tamhogesc parentesco
		ic_rezedu anac_e inas_esc niv_ed
		ic_asalud ic_segsoc ss_dir pea par jef_ss cony_ss hijo_ss s_salud pam 
		ic_cv icv_pisos icv_muros icv_techos icv_hac
		ic_sbv isb_agua isb_dren isb_luz isb_combus
		ic_ali id_men tot_iaad tot_iamen ins_ali
		plb_m plb ictpc est_dis upm
		i_privacion pobreza pobreza_e pobreza_m  vul_car vul_ing no_pobv carencias carencias3 cuadrantes 
		prof_b1 prof_bm1 profun int_pob int_pobe int_vulcar int_caren ict ing_mon ing_lab ing_ren ing_tra 
		nomon pago_esp reg_esp hli discap;

order 	 folioviv foliohog numren factor tam_loc rururb ent ubica_geo edad sexo tamhogesc parentesco
		ic_rezedu anac_e inas_esc niv_ed
		ic_asalud ic_segsoc ss_dir pea par jef_ss cony_ss hijo_ss s_salud pam 
		ic_cv icv_pisos icv_muros icv_techos icv_hac
		ic_sbv isb_agua isb_dren isb_luz isb_combus
		ic_ali id_men tot_iaad tot_iamen ins_ali
		plb_m plb ictpc est_dis upm
		i_privacion pobreza pobreza_e pobreza_m  vul_car vul_ing no_pobv carencias carencias3 cuadrantes 
		prof_b1 prof_bm1 profun int_pob int_pobe int_vulcar int_caren ict ing_mon ing_lab ing_ren ing_tra 
		nomon pago_esp reg_esp hli discap;

label var sexo "Sexo";
label var parentesco "Parentesco con el jefe del hogar";
label var est_dis "Estrato de dise�o";
label var upm "Unidad primaria de muestreo";
label var ubica_geo "Ubicaci�n geogr�fica";


sort  folioviv foliohog numren;

save "$bases\pobreza_16.dta", replace;

********************************************************
*Cuadros resultado
********************************************************;
di "TABULADOS B�SICOS";



********************************************************
* RESULTADOS A NIVEL NACIONAL
********************************************************;
#delimit;
tabstat pobreza pobreza_m pobreza_e vul_car vul_ing no_pobv carencias carencias3 ic_rezedu ic_asalud 
ic_segsoc ic_cv ic_sbv ic_ali plb_m plb [w=factor] if pobreza!=., stats(mean sum) format(%15.6gc) c(s);

********************************************************************************
* PORCENTAJE Y N�MERO DE PERSONAS POR CONDICI? DE POBREZA, ENTIDAD FEDERATIVA
********************************************************************************;
tabstat pobreza pobreza_m pobreza_e vul_car vul_ing no_pobv [w=factor] if pobreza!=., 
stats(mean sum) format(%11.6gc) by(ent);



*********************************************************************************
* PORCENTAJE Y N�MERO DE PERSONAS CON CARENCIAS SOCIALES, ENTIDAD FEDERATIVA
*********************************************************************************;
tabstat ic_rezedu ic_asalud ic_segsoc ic_cv ic_sbv ic_ali carencias carencias3 plb_m plb [w=factor] if pobreza!=., 
stats(mean sum) format(%11.6gc) by(ent);



***************************************************************************************************
* NOTA: LOS CUADROS ANTERIORES SE PUEDEN RECUPERAR DEL ARCHIVO LOG
***************************************************************************************************;

log close;

