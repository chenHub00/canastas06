#delimit ;
clear ;
set mem 500m ;
set more off ;
scalar drop _all;
cap log close;


**************************************************************************;
*
*    PROGRAMA DE CÁLCULO PARA LA CONSTRUCCIÓN DE LAS LÍNEAS DE BIENESTAR;
*
**************************************************************************;

*Para cambiar estas ubicaciones, se modifican los siguientes
globals; 

gl do = "C:\Users\vicen\Documents\Canastas\do_replica_local";

do "$do\macros_dirs_Canasta.do";

capture close;
log using "$log\canastas2016.smcl", replace;


*El siguiente programa de cálculo cuenta con dos principales procesos:
* Paso 1: Construcción de la canasta básica alimentaria
* Paso 2: Construcción de la canasta básica no alimentaria
************************************************************************
*     
*      CONSTRUCCIÓN DE LA CANASTA BÁSICA ALIMENTARIA
*
************************************************************************

do "$do\1_1_requerimientos_energeticos.do";
do "$do\1_2_calorias_aportes.do";


log close;
