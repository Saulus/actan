//Form 1 example
NamesRec := RECORD 
	UNSIGNED1 numRows;
	STRING20 thename;
	STRING20 addr1 := '';
	STRING20 addr2 := '';
	STRING20 addr3 := '';
	STRING20 addr4 := '';
END;

NamesTable := DATASET([
	{1,'Kevin','10 Malt Lane'},
	{2,'Liz','10 Malt Lane','3 The cottages'},
	{0,'Mr Nobody'},
	{4,'Anywhere','Here','There','Near','Far'}],
	NamesRec);
	
OUTPUT(NamesTable);

OutRec := RECORD
	UNSIGNED1 numRows;
	STRING20 thename;
	STRING20 addr;
END;

OutRec NormIt(NamesRec L, INTEGER C) := TRANSFORM
	SELF := L;
	SELF.addr := CHOOSE(C, L.addr1, L.addr2, L.addr3,
    	         L.addr4);
END;
  
NormAddrs := NORMALIZE(namesTable,LEFT.numRows,NormIt(LEFT,COUNTER));

OUTPUT(NormAddrs);
/* the result is: numRows thename
            addr
1 Kevin 10 Malt Lane
2 Liz 10 Malt Lane
2 Liz 3 The cottages
4 Anywhere Here
4 Anywhere There
4 Anywhere Near
4 Anywhere Far */
//************************

//Form 2 example
ChildRec := RECORD
	INTEGER1 NameID;
	STRING20 Addr;
END;

DenormedRec := RECORD
	INTEGER1 NameID;
	STRING20 Name;
	DATASET(ChildRec) Children;
END;

ds := DATASET([
	{1,'Kevin',[ {1,'10 Malt Lane'}]},
	{2,'Liz', [ {2,'10 Malt Lane'},
	{2,'3 The cottages'}]},
	{3,'Mr Nobody', []},
	{4,'Anywhere',[ {4,'Far'},
	{4,'Here'},
	{4,'There'},
	{4,'Near'}]} ],
	DenormedRec);

OUTPUT(ds);

ChildRec NewChildren(ChildRec R) := TRANSFORM
	SELF := R;
END;

NewChilds := NORMALIZE(ds,LEFT.Children,NewChildren(RIGHT));

OUTPUT(NewChilds);