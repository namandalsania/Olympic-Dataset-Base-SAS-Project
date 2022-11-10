proc sort data=pa.athletes 
	out=pa.sorted_athletes;
	by NOC;
run;

proc sort data=pa.region
	out=pa.sorted_region;
	by NOC;
run;
	
data pa.preprocess;
	merge pa.sorted_athletes pa.sorted_region;
	by NOC;
	count = 1;
run;


/* Athletes and Region merged data */


title 'Athletes and Region merged data';

proc print data=pa.preprocess(obs=10);
run;

title;



/* Checking for Missing Values */


title 'Checking for Missing Values';
proc means data=pa.preprocess nmiss;
run;
title;



/* Medal Achievement Statistics for Every Country */


title 'Medal Achievement Statistics for Every Country';

proc means data=pa.preprocess maxdec=0 sum;
	var count;
	class region Medal;
run;
title;

data pa.formatederep;
	set pa.preprocess;
	
	Gold=0;
	Silver=0;
	No_medal=0;
	Bronze=0;
	
	if medal="NA" then No_medal=1;
	else if medal="Silver" then Silver=1;
	else if medal="Gold" then Gold=1;
	else 
		bronze=1;
run;	

proc sort data=pa.formatederep
	out=pa.sorted_formatedrep;
	by region;
run;

data pa.tally;
	set pa.sorted_formatedrep;
	by region;
	
	retain Gold_c 0 Silver_c 0  Bronze_c 0 No_medal_c 0;
	
	if first._region then 
	do silver_c=0;
		gold_c=0;
		bronze_c=0;
		no_medal_c=0;
	end;
	
	silver_c=silver_c+silver;
	gold_c=gold_c+gold;
	No_medal_c=No_medal_c+No_medal;
	bronze_c=bronze_c+bronze;
	
	if last.region;
	
	keep region gold_c silver_c bronze_c No_medal_c;
run;




/* Year wise medal count */


title 'Year wise medal count';

proc means data=pa.formatederep maxdec=0 sum nonobs;
	var Gold;
	class region Year;
run;

proc means data=pa.formatederep maxdec=0 sum nonobs;
	var Silver;
	class region Year;
run;

proc means data=pa.formatederep maxdec=0 sum nonobs;
	var Bronze;
	class region Year;
run;
title;



/* Years in which Summer Olympics were organised */


title "Years in which Summer Olympics were organised";

data pa.summer pa.winter;
	set pa.formatederep;
	
	if Season="Summer" then output pa.summer;
	else output pa.winter;
	
run;

proc sql;
   select distinct(Year) as Year
   from pa.summer;
quit;

title;



/* Years in which Winter Olympics were organised  */


title "Years in which Winter Olympics were organised";

proc sql;
   select distinct(Year) as Year
   from pa.winter;
quit;

title;




/* No. of times a Sport is played in the Olympics */


title 'No. of times a Sport is played in the Olympics';

proc sort data=pa.preprocess
	out=pa.sort_sport;
	by Year Sport;
run;
title;

data pa.sport;
	set pa.sort_sport;
	by Year Sport;
	
	if first.Sport;
run;

proc freq data=pa.sport order=freq;
	tables Sport / nocum nopercent;
run;




/* Years Wise Nation Participated */


title "Years Wise Nation Participated"

proc sort data=pa.preprocess
	out=pa.sort_nation;
	by Year region;
run;

data pa.nation;
	set pa.sort_nation;
	by Year region;
	
	if last.region;
run;

proc means data=pa.nation sum nonobs maxdec=0;
	var count;
	class Year;
run;
title;

/* Years Wise Events */

title 'Year Wise Events';

proc sort data=pa.preprocess
	out=pa.sort_event;
	by Year Event;
run;

data pa.event;
	set pa.sort_event;
	by Year Event;
	
	if last.Event;
run;

proc means data=pa.event sum nonobs maxdec=0;
	var count;
	class Year;
run;
title;




/* No. of Athletes participated every Year */


title 'Athlete Over Time';

proc sort data=pa.preprocess
	out=pa.sort_name;
	by Year Name;
run;

data pa.name;
	set pa.sort_name;
	by Year Name;
	
	if last.Name;
run;

proc means data=pa.name sum nonobs maxdec=0;
	var count;
	class Year;
run;
title;


