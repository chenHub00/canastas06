
gen req_cal_rururb = . ;
replace req_cal_rururb = cond(sexo==1, 621, 523) if edad==0 & rururb==1 ;
replace req_cal_rururb = cond(sexo==1, 943, 864) if edad==1 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1129,1048) if edad==2 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1249,1154) if edad==3 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1359,1242) if edad==4 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1393,1280) if edad==5 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1497,1383) if edad==6 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1508,1493) if edad==7 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1704,1515) if edad==8 & rururb==1;
replace req_cal_rururb = cond(sexo==1,1874,1748) if edad==9 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2031,1893) if edad==10 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2134,1997) if edad==11 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2313,2146) if edad==12 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2514,2255) if edad==13 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2735,2316) if edad==14 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2951,2352) if edad==15 & rururb==1;
replace req_cal_rururb = cond(sexo==1,3064,2417) if edad==16 & rururb==1;
replace req_cal_rururb = cond(sexo==1,3221,2444) if edad==17 & rururb==1;
replace req_cal_rururb = cond(sexo==1,2981,2412) if (edad>=18 & edad<=29) & rururb==1 ;
replace req_cal_rururb = cond(sexo==1,2894,2333) if (edad>=30 & edad<=59) & rururb==1;
replace req_cal_rururb = cond(sexo==1,2408,2091) if (edad>=60 & edad<=99) & rururb==1;
replace req_cal_rururb = cond(sexo==1, 621, 523) if edad==0 & rururb==0 ;
replace req_cal_rururb = cond(sexo==1, 943, 864) if edad==1 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1129,1048) if edad==2 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1249,1154) if edad==3 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1359,1242) if edad==4 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1393,1280) if edad==5 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1497,1383) if edad==6 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1508,1493) if edad==7 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1704,1515) if edad==8 & rururb==0;
replace req_cal_rururb = cond(sexo==1,1874,1748) if edad==9 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2031,1893) if edad==10 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2134,1997) if edad==11 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2313,2146) if edad==12 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2514,2255) if edad==13 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2735,2316) if edad==14 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2951,2352) if edad==15 & rururb==0;
replace req_cal_rururb = cond(sexo==1,3064,2417) if edad==16 & rururb==0;
replace req_cal_rururb = cond(sexo==1,3221,2444) if edad==17 & rururb==0;
replace req_cal_rururb = cond(sexo==1,2617,2116) if (edad>=18 & edad<=29) & rururb==0 ;
replace req_cal_rururb = cond(sexo==1,2540,2047) if (edad>=30 & edad<=59) & rururb==0;
replace req_cal_rururb = cond(sexo==1,2113,1836) if (edad>=60 & edad<=99) & rururb==0;


recode req_* (.=0) ;

collapse (sum) req_*, by(folio) ;
