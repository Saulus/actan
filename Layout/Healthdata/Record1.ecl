/* ******************************************************************************
## Paul Hellwig, 14.06.2013
Health Data Records
Record1 = Stammdaten 
******************************************************************************/

EXPORT Record1 := RECORD
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
