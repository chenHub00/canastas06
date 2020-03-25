
/* 
1) Bases originales: "C:\Pobreza 2016\originales"
2) Bases generadas: "C:\Pobreza 2016\Bases"
3) Bit⤯ras: "C:\Pobreza 2016\log"

Para cambiar estas ubicaciones, se modifican los siguientes
globals (gl); 
*/
gl dir = "C:\Users\vicen\Documents\Canastas\STATA_2016\";

/*DICE:
gl data="$dir\originales";
gl bases="$dir\Bases";
gl log="$dir\log";
*/

/* Debe decir:*/
gl data="$dir\Bases de datos";
/* Se debe crear el archivo */
gl log="$dir\log";
/* son solo bases creadas */
gl bases="$dir\dta";
