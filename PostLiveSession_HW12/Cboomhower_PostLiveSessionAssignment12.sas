/*******************************
* Chris Boomhower
* Post-Live Session HW 12
* MSDS 6306-402
* 8/6/16
********************************/

/* Live Session Unit 12 Assignment */
/* Download and import files into SAS using the code below */
/* There is code for .xlsx, .xls, and .csv files */
/* Merge the files into ONE Excel or CSV file */
/* Commit the file to GitHub */
/* Post link to Live session unit 12 by next Monday/s live session */
/* If you have to, you can physically import the files to your computer. */

/* Code to Import dataset1.sas7bdat from SAS library MSDS6306SASData */
/********** Note the following - READ THIS ************************/
/* Assumes use of apps.smu.edu version of SAS 9.4 on a Mac                               */
/* Also assumes that the data dataset1.sas7bdat is in a folder called MSDS6306SASData    */
/* on the desktop of the computer. Your path name will probably be different             */
/*************************************************************************/

/* First, link the name msds6306 with the SAS library using libname command */
libname msds6306 '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12';
/* Now change the data name to avoid overwriting and because it's just too long. */
proc sort data = msds6306.dataset1 out = edData; by State;
run;

/* Let's see what we have! */
proc contents data = edData; run;
proc print data = edData; run;


/******** Some Links to other data ***********/
/* From Section 402 as of 10:30 p.m. on Monday, August 1 
https://github.com/BlDavenport/population-density-file
https://github.com/amfrye777/MSDS6306_Live-Session-11-Assignment/blob/master
https://github.com/jdquick/SATandACTStudy
https://raw.githubusercontent.com/rlisbona/Unit11SATACT/master/Analysis/Clean/2014PublicPrivateSchoolsClean.csv
https://github.com/data-redraider/Homework_Aug1/blob/master/ACS_14_5YR_GCT1105.US01PR.xls
https://raw.githubusercontent.com/ChrisBoomhower/MSDS6306_HwUploads/master/PostLiveSession_HW11/PercentAPStudent.csv
https://github.com/celiatsmuedu/MSDS6306402HW11Education/blob/master/AverageClassSizeByState.xlsx
****************************************************/
/* I got these links from Week 11 Homework. That is where you were supposed to submit the link. */
 
/******* Now modify the code below to import data from the links above *******/
/********************** WARNING: THIS WILL BE MESSY !!!!!! *******************/
*data streaming;
*infile _inbox "%sysfunc(getoption(work))/streaming.csv";
*proc http method="get" 
* url="https://raw.githubusercontent.com/amfrye777/MSDS6306_Live-Session-11-Assignment/master/DeathPenaltyStatsNotMerged.csv" 
* out=_inbox
* /* proxyhost="http://yourproxy.company.com" */
*;
*run;
** filename _inbox clear;
*proc contents data=streaming;
*run;

*filename _inbox "%sysfunc(getoption(work))/streaming.csv";
*proc http method="get" 
* url="https://raw.githubusercontent.com/amfrye777/MSDS6306_Live-Session-11-Assignment/master/DeathPenaltyStatsNotMerged.csv" 
* out=_inbox
* /* proxyhost="http://yourproxy.company.com" */
*;
*run;
** filename _inbox clear;
*proc contents data=streaming;
*run;

*/* Import Excel Files */

*filename _inbox "%sysfunc(getoption(work))/stream2.xlsx"; 
*proc http method="get"  
*url="https://github.com/anabbott/Education/blob/master/AAbbottEducation.xlsx?raw=true"  
*out=_inbox /* proxyhost="http://yourproxy.company.com" */;
*run; 
*proc import file = _inbox out = foo dbms=xlsx; 
*getnames = yes;
*run;
*proc print data=work.foo;
*run;

*filename _inbox "%sysfunc(getoption(work))/stream2.xls"; 
*proc http method="get"  
* url="https://github.com/data-redraider/Homework_Aug1/blob/master/ACS_14_5YR_GCT1105.US01PR.xls?raw=TRUE"
*out=_inbox /* proxyhost="http://yourproxy.company.com" */;
*run; 
*proc import file = _inbox out = foo2 dbms=xls; 
*/* for old .xls files, use dbms=xls */
*getnames = yes;
*run;
*proc print data=work.foo2;
*run;



/* DUE TO APPS.SMU.EDU CITRIX SAS AND SAS UNIVERSITY EDITION LIMITATIONS PREVENTING PROC HTTP USAGE, THE FILES WERE MANUALLY DOWNLOADED AND ARE IMPORTED BELOW*/



/* Import and Clean Public-Private data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\2014PublicPrivateSchoolsClean.csv'
	out = PublicPrivate
	replace; *Replace existing data set if it already exists under this name;
	getnames = yes; *Use header for variable names;
	guessingrows=100; *Required to review all rows when determining data length (i.e. string length for a given data);
run;

proc contents data = PublicPrivate; run;
proc print data = PublicPrivate; run;

data PublicPrivateEdit;
	set PublicPrivate;
	State = strip(State); *Remove leading and trailing blank spaces;
run;

proc sort data = PublicPrivateEdit out = PublicPrivateSort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc print data = PublicPrivateSort; run;




/* Import Percent APStudents data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\PercentAPStudents.csv'
	out = PercentAPstudents
	replace;
	getnames = yes;
	guessingrows=100;
run;

proc contents data = PercentAPStudents; run;

data PercentAPStudentsEdit;
	set PercentAPStudents;
	_2014_Students_in_AP_Classes = substr(_2014_Students_in_AP_Classes,1,length(_2014_Students_in_AP_Classes)-2)/100; *Remove percent sign and convert to ratio value less than 1;
	_2015_Students_in_AP_Classes = substr(_2015_Students_in_AP_Classes,1,length(_2015_Students_in_AP_Classes)-2)/100; *Remove percent sign and convert to ratio value less than 1;
	State = strip(State); *Remove leading and trailing blank spaces;
run;

proc sort data = PercentAPStudentsEdit out = PercentAPStudentsSort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc print data = PercentAPstudentsSort; run;




/* Import Death Penalty Stats data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\DeathPenaltyStatsNotMerged.csv'
	out = DeathPenalty
	replace;
	getnames = yes;
	guessingrows=100;
run;

proc contents data = DeathPenalty; run;

data DeathPenaltyEdit (rename=(States = State) drop = VAR1);
	set DeathPenalty;
	new = put(DeathPenaltyCode, 1.); *Convert numeric type to character for treatment as categorical data;
	drop DeathPenaltyCode; *Remove numeric type data;
	rename new=DeathPenaltyCode; *Rename new character type data to match old name;
	if States EQ "Federal system" | States EQ "American Samoa" | States EQ "Guam" | States EQ "Puerto Rico" | States EQ "Virgin Islands" then DELETE; *Delete undesired state entries;
		else if States EQ "District of Columbia" then States = "DC";
	States = strip(States); *Remove leading and trailing blank spaces;
run;

proc sort data = DeathPenaltyEdit out = DeathPenaltySort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc contents data = DeathPenaltySort; run;
proc print data = DeathPenaltySort; run;




/* Import Population Density data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\PopDensity.xlsx'
	out = PopDensity
	dbms =xlsx
	replace;
	sheet = "Sheet1";
	getnames = yes;
	guessingrows=100;
run;

proc contents data = PopDensity; run;

data PopDensityEdit (rename=(POP_KM_ = Pop_per_Sq_KM) rename=(POP_MI_ = Pop_per_Sq_Mile));
	set PopDensity;
	State = strip(State); *Remove leading and trailing blank spaces;
run;

proc sort data = PopDensityEdit out = PopDensitySort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc contents data = PopDensitySort; run;

proc print data = PopDensitySort; run;




/* Import Average Class Size data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\AverageClassSizeByState.xlsx'
	out = AvgSize
	dbms =xlsx
	replace;
	sheet = "Sheet1";
	getnames = yes;
	guessingrows=100;
run;
proc contents data = AvgSize; run;

data AvgSizeEdit (rename=(Rank = Avg_Class_Size_Rank));
	set AvgSize;
	State = strip(PROPCASE(State)); *Capitalize only first letter of all states and remove leading and trailing blank spaces;
	if State EQ "" | STATE EQ "United States" then DELETE; *Delete undesired or empty state entries;
		else if State EQ "District Of Columbia" then State = "DC";
run;

proc sort data = AvgSizeEdit out = AvgSizeSort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc print data = AvgSizeSort; run;




/* Import Average Household Size data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\ACS_14_5YR_GCT1105.US01PR.xls'
	out = HouseholdSize
	dbms =xls
	replace;
	sheet = "GCT1105-Geography-United States";
	getnames = no;
	guessingrows=100;
run;
proc contents data = HouseholdSize; run;
proc print data = HouseholdSize; run;

data HouseholdSizeEdit (rename=(A = State) rename=(D = Avg_Household_Size) rename=(G = Household_Size_Margin) drop = B drop = C drop = E drop = F);
	set HouseholdSize;
	if D EQ "" | D EQ "Person" | A EQ "  Puerto Rico" | A EQ "United States" then DELETE; *Delete undesired or empty state entries;
		else if A EQ "  District of Columbia" then A = "DC";
	A = strip(A); *Remove leading and trailing blank spaces;
run;

proc sort data = HouseholdSizeEdit out = HouseholdSizeSort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc print data = HouseholdSizeSort; run;





/* Import Students Per Teacher data */
proc import datafile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\StudentsPerTeacher2013.csv'
	out = StudentsPerTeacher
	replace;
	getnames = yes;
	guessingrows=100;
run;

proc contents data = StudentsPerTeacher; run;
proc print data = StudentsPerTeacher; run;

data StudentsPerTeacherEdit (rename=(Students_per_T = Avg_Students_per_Teacher));
	set StudentsPerTeacher;
	ST = strip(ST); *Remove leading and trailing blank spaces;
run;

proc print data = StudentsPerTeacherEdit; run;

/* Create state mapper data set to map full state names to abbreviated state names */
data StateMap;
input ST $ State $20.;
datalines;
AK	Alaska
AL	Alabama
AR	Arkansas
AZ	Arizona
CA	California
CO	Colorado
CT	Connecticut
DC	DC
DE	Delaware
FL	Florida
GA	Georgia
HI	Hawaii
IA	Iowa
ID	Idaho
IL	Illinois
IN	Indiana
KS	Kansas
KY	Kentucky
LA	Louisiana
MA	Massachusetts
MD	Maryland
ME	Maine
MI	Michigan
MN	Minnesota
MO	Missouri
MS	Mississippi
MT	Montana
NB	Nebraska
NC	North Carolina
ND	North Dakota
NH	New Hampshire
NJ	New Jersey
NM	New Mexico
NV	Nevada
NY	New York
OH	Ohio
OK	Oklahoma
OR	Oregon
PA	Pennsylvania
RI	Rhode Island
SC	South Carolina
SD	South Dakota
TN	Tennessee
TX	Texas
UT	Utah
VA	Virginia
VT	Vermont
WA	Washington
WI	Wisconsin
WV	West Virginia
WY	Wyoming
;
proc print data = StateMap;
run;

/* Map Students Per Teacher data state names*/
data StudentsPerTeacherMapped;
	merge StudentsPerTeacherEdit StateMap; by ST;
	drop ST;
run;

proc sort data = StudentsPerTeacherMapped out = StudentsPerTeacherSort; by State; *Sort by State to ensure in correct order before merge with edData;
run;

proc print data = StudentsPerTeacherSort; run; /*/////// CLEANED ////////*/




/* Merge all data together */
data msds6306.FinalData (rename=(Pop = Population));
	merge edData PublicPrivateSort PercentAPstudentsSort DeathPenaltySort PopDensitySort AvgSizeSort HouseholdSizeSort StudentsPerTeacherSort; by State;
run;

proc print data = msds6306.FinalData; run;




/* Write merged file to CSV */
proc export data = msds6306.FinalData
	outfile = '\\Client\C$\Users\Owner\Documents\GitHub\MSDS_6306\MSDS6306_HwUploads\PostLiveSession_HW12\Cboomhower_PostLiveSessionHW12_MergedData.csv'
	dbms=csv
	replace;
run;
