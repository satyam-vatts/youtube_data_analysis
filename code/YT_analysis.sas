***************************************************************;
*************** CREATING a NEW LIBRARY FOR DATA ***************;
***************************************************************;
libname A3 "/folders/myfolders/A3_Library";

***************************************************************;
********************IMPORTING YOUTUBE DATA*********************;
***************************************************************;
PROC IMPORT DATAFILE='/folders/myfolders/Youtube.csv'
	DBMS=CSV
	OUT=A3.YOUTUBE(drop=VAR1) REPLACE ;
RUN;


***************************************************************;
********************* ANALYSING DATASETS **********************;
***************************************************************;

*-------------------- Analysing Table Attributes --------------;

ods noproctitle;
ods select attributes position;

title 'Data Structure for Youtube Videos Data';
proc contents data=A3.YOUTUBE order=varnum;
run;

*-----------------Analysing First 10 Rows----------------------;

proc print data=A3.YOUTUBE (obs=10) obs="S.No." label n;
	title 'YouTube Data First 10 Observations';
run;

*-----------------Analyze variables-----------------;
ods noproctitle;

/*** Analyze numeric variables ***/
title "Descriptive Statistics for Numeric Variables";

proc means data=A3.YOUTUBE n nmiss min mean median max std skew kurt;
	var Clicks_per_end_screen_element_sh Comments_added Shares Dislikes Likes 
		Average_percentage_viewed____ Average_view_duration Views Watch_time__hours_ 
		Subscribers Impressions Impressions_click_through_rate__;
run;

title;

/*** Analyze date variables ***/
title "Minimum and Maximum Dates";

proc sql;
	select "Video_publish_time" label="Date variable", min(Video_publish_time) 
		format=DDMMYY10. label="Minimum date" , max(Video_publish_time) 
		format=DDMMYY10. label="Maximum date" from A3.YOUTUBE;
quit;

title "Date Frequencies";

proc freq data=A3.YOUTUBE noprint;
	tables Video_publish_time / out=_tmpfreq1;
run;

proc sgplot data=_tmpfreq1;
	yaxis min=0;
	series x=Video_publish_time y=count;
run;

proc delete data=_tmpfreq1;
run;
title;
***************************************************************;
**************** BINNING NUMERICAL VARIABLES ******************;
***************************************************************;

proc format;
value bin_format
0 = 'Low'
1 = 'Med'
2 = 'High';
run;

PROC RANK data = A3.YOUTUBE
          groups=3
          out = A3.YOUTUBE_BINNED;
          var  Average_percentage_viewed____ Average_view_duration
               Clicks_per_end_screen_element_sh Comments_added Dislikes
               Impressions Impressions_click_through_rate__ Likes Shares
               Subscribers Views Watch_time__hours_;
          ranks Average_percentage_viewed____ Average_view_duration
               Clicks_per_end_screen_element_sh Comments_added Dislikes
               Impressions Impressions_click_through_rate__ Likes Shares
               Subscribers Views Watch_time__hours_;
         format Clicks_per_end_screen_element_sh bin_format. Comments_added bin_format.
		       Shares bin_format. Dislikes bin_format. Likes bin_format.
		       Average_percentage_viewed____ bin_format. Average_view_duration bin_format.
		       Views bin_format. Watch_time__hours_ bin_format. Subscribers bin_format.
		       Impressions bin_format. Impressions_click_through_rate__ bin_format.;
		 label Average_percentage_viewed____='Average Percentage Viewed'
		       Average_view_duration='Average View Duration'
               Clicks_per_end_screen_element_sh = 'Clicks/End Screen Element Shown'
               Comments_added = 'Comments Added'
               Dislikes = 'Dislikes'
               Impressions = 'Impressions'
               Impressions_click_through_rate__ = 'Impressions CTR'
               Likes='Likes'
               Shares='Shares'
               Subscribers= 'Subscribers'
               Views='Views'
               Watch_time__hours_='Watch Time Hours';
run;

proc print data=A3.YOUTUBE_BINNED (obs=10) obs="S.No." label n;
	title 'Binned Youtube Data First 10 Observations';
run;

proc freq data = A3.YOUTUBE_BINNED;
title "Frequency of Binned Variables";
tables Average_percentage_viewed____ Average_view_duration
       Clicks_per_end_screen_element_sh Comments_added Dislikes
       Impressions Impressions_click_through_rate__ Likes Shares
       Subscribers Views Watch_time__hours_;
run;
title;


***************************************************************;
**************** Analysing Relationships **********************;
***************************************************************;

************Chi Sqaure Tests*************************;

*****************Views*******************************;

ods noproctitle;
title "Views realtionship with Other Variables";
proc freq data=A3.YOUTUBE_BINNED; 
tables  (Views) *(Average_view_duration Comments_added Dislikes Impressions Likes Shares Subscribers Watch_time__hours_) / 
		chisq measures relrisk nopercent norow nocol expected deviation nopercent nocum plots=none;
run;
title;

*****************Average_Percentage_Viewed*******************************;

ods noproctitle;
title "Average Percentage Viewed realtionship with Other Variables";
proc freq data=A3.YOUTUBE_BINNED; 
tables  ( Average_percentage_viewed____) *( Clicks_per_end_screen_element_sh Impressions_click_through_rate__) / 
		chisq measures relrisk nopercent norow nocol expected deviation nopercent nocum plots=none;
run;
title;

*****************Clicks_Per_End_Screen_Element*******************************;

ods noproctitle;
title "Clicks per End Screen Element Shown realtionship with Other Variables";
proc freq data=A3.YOUTUBE_BINNED; 
tables  ( Clicks_per_end_screen_element_sh) *(  Impressions_click_through_rate__) / 
		chisq measures relrisk nopercent norow nocol expected deviation nopercent nocum plots=none;
run;
title;

*****************************************************************************;
**************** Comparing With Numerical Relationship **********************;
*****************************************************************************;

ods noproctitle;
ods graphics / imagemap=on;
title "Numerical Variable Correlations ";

proc corr data=A3.YOUTUBE pearson spearman kendall plots=matrix(histogram 
		nvar=10 nwith=10);
	var Views;
	with Comments_added Shares Dislikes Likes Average_view_duration 
		Watch_time__hours_ Subscribers Impressions ;
run;

ods noproctitle;
ods graphics / imagemap=on;

proc corr data=A3.YOUTUBE pearson spearman kendall plots=matrix(histogram 
		nvar=10);
	var Clicks_per_end_screen_element_sh Average_percentage_viewed____ 
		Impressions_click_through_rate__;
run;

title;

***************************************************************;
**************** Variable Selection ***************************;
***************************************************************;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=A3.YOUTUBE alpha=0.05 ;
	model Views=Shares / stb;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=A3.YOUTUBE alpha=0.05;
	model Views=Likes / stb;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=A3.YOUTUBE alpha=0.05;
	model Views=Watch_time__hours_ / stb;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=A3.YOUTUBE alpha=0.05;
	model Views=Subscribers / stb;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=A3.YOUTUBE alpha=0.05;
	model Views=Impressions / stb;
	run;
quit;


***************************************************************;
****************Exporting the Datasets and Samples*************;
***************************************************************;

proc export data=A3.YOUTUBE_BINNED
	outfile="/folders/myfolders/CATEGORICAL_DATASET_YT.csv"
	dbms=csv
	replace;
run;
