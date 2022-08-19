data _null_; 
      rc=dlgcdir("Z:\OneDrive - Smart City Real Estate\Personal\Baruch\S4\STA 9705 - Multivariate\Project");
      put rc=;
run;

PROC IMPORT DATAFILE = "Peas.csv" DBMS = CSV OUT = PEAS REPLACE;
GETNAMES = YES;
RUN;

/* Perform Best Subset Selection */
ods pdf file ="9705 Peas Subset Selection.pdf";
proc reg data = work.peas;
	model Flavour Sweet Fruity OffFlavour Mealiness Hardness = Tenderometer DryMatter Dry_matter_after_freezing SucrosePercent TotalGlucose1 TotalGlucose2 Whiteness Colour1 Colour2 Colour3 Skin / selection=stepwise slentry=.15 slstay=.05;
	title "Stepwise Subset Selection";
run;
quit;
ods pdf close;

/* based on above check the full model versus the reduced model */
ods pdf file ="9705 Peas Coefficient Subset Test.pdf";
proc reg data = work.peas;
	model Flavour Sweet Fruity OffFlavour Mealiness Hardness = Tenderometer DryMatter Dry_matter_after_freezing SucrosePercent TotalGlucose1 TotalGlucose2 Whiteness Colour1 Colour2 Colour3 Skin;
	overall: mtest /print canprint mstat=exact;
	partial1: mtest Colour2, TotalGlucose1, TotalGlucose2, Dry_matter_after_freezing, Whiteness /print canprint mstat=exact;
	TITLE "Coefficient Subset Test";
run;
quit;
ods pdf close;

/* running the model with the subset of variables chosen above */
ods pdf file = "9705 Reduced Model";
proc reg data =work.peas; 
	MODEL Flavour Sweet Fruity OffFlavour Mealiness Hardness = Tenderometer DryMatter SucrosePercent Colour1 Colour3 Skin;
	OVERALL: MTEST /PRINT CANPRINT MSTAT=EXACT;
	TITLE "Reduced Model";
RUN;
quit;
ods pdf close;

/* CHECK IF COLOUR 1 IS SIGNIFICANT */
proc reg data =work.peas; 
	MODEL Flavour Sweet Fruity OffFlavour Mealiness Hardness = Tenderometer DryMatter SucrosePercent Colour1 Colour3 Skin;
	OVERALL: MTEST /PRINT CANPRINT MSTAT=EXACT;
	PARTIAL11: MTEST Colour1 /PRINT MSTAT = EXACT;
	TITLE "Checking Colour1";
RUN;

proc print data =WORK.PEAS;
run;
QUIT;

ods pdf file = "9705 Y's Correlation";
proc corr data = work.peas plots=matrix;
	var Flavour Sweet Fruity OffFlavour Mealiness Hardness;
	run;
quit;
ods pdf close;

/* Run the Canonical Correlation */
ods pdf file="9705 Canonical Correlation";
proc cancorr ALL;
	with Flavour Sweet Fruity OffFlavour Mealiness Hardness;
	var Tenderometer DryMatter SucrosePercent Colour1 Colour3 Skin;
run;
quit;
ods pdf close;
