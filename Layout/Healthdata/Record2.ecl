/* ******************************************************************************
## Paul Hellwig, 14.06.2013
Health Data Records
Record2 = Amb_Diagnosen
******************************************************************************/

EXPORT Record2 := RECORD
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