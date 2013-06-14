// import data.
// 1. UPLOAD manually
// 2. SPRAY manually

// 3. Start Import
		stamm_record := RECORD
			UNSIGNED2 Bezugsjahr; 
			STRING24 PID; 
			UNSIGNED1 Geschlecht;
			UNSIGNED2 Vers_Tage;
			STRING9 H2IK;
			UNSIGNED1 Alter;
			UNSIGNED1 AGG;
			UNSIGNED1 Verstorben;
			UNSIGNED5	RecordID := 0;
		end;
		stamm_members_in := DATASET('~thor::in::speedtest::stamm_v.csv', stamm_record , CSV(HEADING(1),  SEPARATOR(';'), TERMINATOR(['\r\n','\n\r','\n','\r']), QUOTE('"')) );
		
		diag_record := RECORD
			UNSIGNED2 Bezugsjahr; 
			STRING24 PID; 
			UNSIGNED1 Behandl_Quartal;
			STRING24 EFN_ID;
			STRING7 BS_NR;
			STRING24 LANR;
			STRING2 FG;
			STRING5 ICD_Code;
			STRING1 Diagnosesicherheit;
			UNSIGNED1 Lokalisation;
			STRING3 Vertrags_ID;
			UNSIGNED1 Quarter_PY;
			STRING9 H2IK;
			STRING9 date_yyq;
			STRING1 MRSARelevanz;
			UNSIGNED5	RecordID := 0;
		end;
		diag_members_in := DATASET('~thor::in::speedtest::arzt_diagnose_v.csv', diag_record , CSV(HEADING(1),  SEPARATOR(';'), TERMINATOR(['\r\n','\n\r','\n','\r']), QUOTE('"')) );
	
//add a technical record no. to each dataset and distribute stamm and diag through clusters to make parsing faster
// Add a RecordID to each record - this is used for matching up the child sets and datasets after parsing.
stamm_members_counted :=
	PROJECT(stamm_members_in, TRANSFORM(stamm_record, SELF.RecordID := COUNTER; SELF := LEFT;));
stamm_members := DISTRIBUTE(stamm_members_counted, RecordID);

diag_members_counted :=
	PROJECT(diag_members_in, TRANSFORM(diag_record, SELF.RecordID := COUNTER; SELF := LEFT;));
diag_members := DISTRIBUTE(diag_members_in, RecordID);


// Filter stamm
StammFilterSet := stamm_members(Alter BETWEEN 40 and 50);

// Filter Diagnosis
DiagmosisFilterSet := diag_members(ICD_Code[1..3]='F32');

//Define resultset
result_record := RECORD
			STRING24 PID; 
			UNSIGNED Integer1 Alter;
			STRING5 ICD_Code;
		end;

preresult := JOIN(StammFilterSet,DiagmosisFilterSet,LEFT.PID=RIGHT.PID,TRANSFORM(result_record, SELF.PID := LEFT.PID; SELF.Alter := LEFT.ALter; SELF.ICD_Code := Right.ICD_Code;));

//DEDUP
result := DEDUP(SORT(preresult, PID, ICD_Code),PID, ICD_Code);

//Send Output to file
Output(result,,'~thor::out::speedtest::result', CSV(HEADING,  SEPARATOR(';'), TERMINATOR(['\r\n','\n\r','\n','\r']), QUOTE('"')),OVERWRITE);