#delimit ; 

gen rubros=1 if clave>="A001" & clave<="A006";
replace rubros=2 if  clave>="A007" & clave<="A018";
replace rubros=3 if  clave>="A019" & clave<="A020";
replace rubros=4 if  clave>="A021" & clave<="A024";
replace rubros=5 if  clave>="A025" & clave<="A037";
replace rubros=6 if  clave>="A038" & clave<="A046";
replace rubros=7 if  clave>="A047" & clave<="A056";
replace rubros=8 if  clave>="A057" & clave<="A061";
replace rubros=9 if  clave=="A062" ;
replace rubros=10 if  clave>="A063" & clave<="A065";
replace rubros=11 if  clave>="A066" & clave<="A067";
replace rubros=12 if  clave>="A068" & clave<="A070";
replace rubros=13 if  clave=="A071" ;
replace rubros=14 if  clave>="A072" & clave<="A074";
replace rubros=15 if  clave>="A075" & clave<="A081";
replace rubros=16 if  clave>="A082" & clave<="A088";
replace rubros=17 if  clave>="A089" & clave<="A092";
replace rubros=18 if  clave>="A093" & clave<="A094";
replace rubros=19 if  clave>="A095" & clave<="A096";
replace rubros=20 if  clave>="A097" & clave<="A100";
replace rubros=21 if  clave>="A101" & clave<="A104";
replace rubros=22 if  clave>="A105" & clave<="A106";
replace rubros=23 if  clave>="A107" & clave<="A132";
replace rubros=24 if  clave>="A133" & clave<="A136";
replace rubros=25 if  clave>="A137" & clave<="A141";
replace rubros=26 if  clave>="A142" & clave<="A143";
replace rubros=27 if  clave>="A144" & clave<="A146";
replace rubros=28 if  clave>="A147" & clave<="A170";
replace rubros=29 if  clave>="A171" & clave<="A172";
replace rubros=30 if  clave>="A173" & clave<="A175";
replace rubros=31 if  clave>="A176" & clave<="A177";
replace rubros=32 if  clave>="A178" & clave<="A179";
replace rubros=33 if  clave>="A180" & clave<="A182";
replace rubros=34 if  clave>="A183" & clave<="A194";
replace rubros=35 if  clave>="A195" & clave<="A197";
replace rubros=36 if  clave>="A198" & clave<="A202";
replace rubros=37 if  clave>="A203" & clave<="A204";
replace rubros=38 if  clave>="A205" & clave<="A209";
replace rubros=39 if  clave>="A210" & clave<="A211";
replace rubros=40 if  clave=="A212";
replace rubros=42 if  clave>="A215" & clave<="A222";
replace rubros=43 if  clave>="A223" & clave<="A238";
replace rubros=45 if  clave=="A242";
replace rubros=46 if  clave>="A243" & clave<="A247";


* Etiquetar rubros;
label define rubros
1 "Maíz "
2 "Trigo "
3 "Arroz "
4 "Otros cereales "
5 "Carne de res y ternera "
6 "Carne de cerdo "
7 "Carnes procesadas "
8 "Carne de pollo "
9 "Carnes procesadas de aves "
10 "Otras carnes "
11 "Pescados frescos "
12 "Pescados procesados "
13 "Otros pescados "
14 "Mariscos "
15 "Leche "
16 "Quesos "
17 "Otros derivados de la leche "
18 "Huevos "
19 "Aceites "
20 "Grasas "
21 "Tubérculos crudos o frescos "
22 "Tubérculos procesados "
23 "Verduras y legumbres frescas "
24 "Verduras y legumbres procesadas "
25 "Leguminosas "
26 "Leguminosas procesadas "
27 "Semilllas "
28 "Frutas frescas "
29 "Frutas procesadas "
30 "Azúcar y mieles "
31 "Café "
32 "Té "
33 "Chocolate "
34 "Especies y aderezos "
35 "Alimentos preparados para bebé "
36 "Alimentos preparados para consumir en casa "
37 "Alimentos diversos "
38 "Dulces y postres "
39 "Gastos relacionados con la elaboración de alimentos "
40 "Gastos en alimentos y/o bebidas en paquete "
42 "Bebidas no alcohólicas "
43 "Bebidas alcohólicas "
45 "Alimentos de organizaciones "
46 "Alimentos y bebidas consumidas fuera del hogar "
;
label value rubros rubros;

/* Rubros en urbano = rural?

gen rubros=1 if clave>="A001" & clave<="A006";
replace rubros=2 if  clave>="A007" & clave<="A018";
replace rubros=3 if  clave>="A019" & clave<="A020";
replace rubros=4 if  clave>="A021" & clave<="A024";
replace rubros=5 if  clave>="A025" & clave<="A037";
replace rubros=6 if  clave>="A038" & clave<="A046";
replace rubros=7 if  clave>="A047" & clave<="A056";
replace rubros=8 if  clave>="A057" & clave<="A061";
replace rubros=9 if  clave=="A062" ;
replace rubros=10 if  clave>="A063" & clave<="A065";
replace rubros=11 if  clave>="A066" & clave<="A067";
replace rubros=12 if  clave>="A068" & clave<="A070";
replace rubros=13 if  clave=="A071" ;
replace rubros=14 if  clave>="A072" & clave<="A074";
replace rubros=15 if  clave>="A075" & clave<="A081";
replace rubros=16 if  clave>="A082" & clave<="A088";
replace rubros=17 if  clave>="A089" & clave<="A092";
replace rubros=18 if  clave>="A093" & clave<="A094";
replace rubros=19 if  clave>="A095" & clave<="A096";
replace rubros=20 if  clave>="A097" & clave<="A100";
replace rubros=21 if  clave>="A101" & clave<="A104";
replace rubros=22 if  clave>="A105" & clave<="A106";
replace rubros=23 if  clave>="A107" & clave<="A132";
replace rubros=24 if  clave>="A133" & clave<="A136";
replace rubros=25 if  clave>="A137" & clave<="A141";
replace rubros=26 if  clave>="A142" & clave<="A143";
replace rubros=27 if  clave>="A144" & clave<="A146";
replace rubros=28 if  clave>="A147" & clave<="A170";
replace rubros=29 if  clave>="A171" & clave<="A172";
replace rubros=30 if  clave>="A173" & clave<="A175";
replace rubros=31 if  clave>="A176" & clave<="A177";
replace rubros=32 if  clave>="A178" & clave<="A179";
replace rubros=33 if  clave>="A180" & clave<="A182";
replace rubros=34 if  clave>="A183" & clave<="A194";
replace rubros=35 if  clave>="A195" & clave<="A197";
replace rubros=36 if  clave>="A198" & clave<="A202";
replace rubros=37 if  clave>="A203" & clave<="A204";
replace rubros=38 if  clave>="A205" & clave<="A209";
replace rubros=39 if  clave>="A210" & clave<="A211";
replace rubros=40 if  clave=="A212";
replace rubros=42 if  clave>="A215" & clave<="A222";
replace rubros=43 if  clave>="A223" & clave<="A238";
replace rubros=45 if  clave=="A242";
replace rubros=46 if  clave>="A243" & clave<="A247";


* Etiquetar rubros;
label define rubros
1 "Maíz "
2 "Trigo "
3 "Arroz "
4 "Otros cereales "
5 "Carne de res y ternera "
6 "Carne de cerdo "
7 "Carnes procesadas "
8 "Carne de pollo "
9 "Carnes procesadas de aves "
10 "Otras carnes "
11 "Pescados frescos "
12 "Pescados procesados "
13 "Otros pescados "
14 "Mariscos "
15 "Leche "
16 "Quesos "
17 "Otros derivados de la leche "
18 "Huevos "
19 "Aceites "
20 "Grasas "
21 "Tubérculos crudos o frescos "
22 "Tubérculos procesados "
23 "Verduras y legumbres frescas "
24 "Verduras y legumbres procesadas "
25 "Leguminosas "
26 "Leguminosas procesadas "
27 "Semilllas "
28 "Frutas frescas "
29 "Frutas procesadas "
30 "Azúcar y mieles "
31 "Café "
32 "Té "
33 "Chocolate "
34 "Especies y aderezos "
35 "Alimentos preparados para bebé "
36 "Alimentos preparados para consumir en casa "
37 "Alimentos diversos "
38 "Dulces y postres "
39 "Gastos relacionados con la elaboración de alimentos "
40 "Gastos en alimentos y/o bebidas en paquete "
42 "Bebidas no alcohólicas "
43 "Bebidas alcohólicas "
45 "Alimentos de organizaciones "
46 "Alimentos y bebidas consumidas fuera del hogar "
;
label value rubros rubros;



