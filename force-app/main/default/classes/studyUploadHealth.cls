public class studyUploadHealth {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}
    public String  results {get;set;}
    public String  errors {get;set;}
    
    public studyUploadHealth () {        
        String errmsg = ApexPages.currentPage().getParameters().get('err');
        String rowCnt = ApexPages.currentPage().getParameters().get('rowCnt');
        results = '';
        if(errmsg != NULL) {
            errors = errmsg;         
        } else if (rowCnt != NULL) {
            results = 'Processed ' + rowCnt + ' Rows.';
        }

    }

    public PageReference tryagain() {
        errors = '';
        results = '';
        return new Pagereference('/apex/studyUploadHealth');
    }
    
    public PageReference ReadFile() {
        
        String errmsg = '';
        String doc;
        
        if(contentFile == null) {
            if (Test.isRunningTest()) {
                doc = 'Study ID,UpdatedWeight,UpdatedWeightDate,UpdatedRMR,UpdatedRMRDate\n123ABC,32,2020-03-25,100,2020-03-25';
            } else {
                return null;      
            }
        } else {            
            doc  = contentFile.toString();
        }

        system.debug('doc == '+doc);
        
        API_Request__c fAPI = new API_Request__c();
        fAPI.Raw_Request__c = doc;
        insert fAPI;
        
        
        List<List<String>> csvArray = new List<List<String>>();
        csvArray = parseCSV(doc, true);
        system.debug('csvArray == '+csvArray);
        
        MAP<String,String> emailMap = new MAP<String,String>();
        
        Set<String> emails = new Set<String>();
        
        List<API_Request__c> lstAPI = new List<API_Request__c>();
        
        
        Integer rowCnt=0;
        for(List<String> arrOut :csvArray) {   
            Integer colCnt=0;
            
            API_Request__c apir = new API_Request__c();
            apir.Request_Type__c = 'Health Update';
            apir.Batch__c = True;
            
            for(String strCol :arrOut) {
                strCol = strCol.replaceAll('(\\r|\\n)+', '');
                strCol = strCol.replaceAll('"', '');
                
                System.debug('strCol:' + strCol + ':');
                if(colCnt == 0) {
                    if (strCol.length() > 0) {
                        apir.Study_ID__c = strCol;
                    } else {
                        errmsg += '~Study ID Missing in Row ' + String.valueOf(rowCnt);
                    }
                }
                if (colCnt == 1) {
                    if (strCol.length() > 0) {
                         apir.Study_Updated_Weight__c = Integer.valueOf(strCol);
                    } else {
                        errmsg += '~Updated Weight Missing in Row ' + String.valueOf(rowCnt);
                    }
                }
                if (colCnt == 2) {
                    if (strCol.length() > 0) {
                        try { 
                            apir.Study_Date_of_Updated_Weight__c = date.parse(strCol);
                        }catch(exception e){
                            errmsg += '~Updated Weight Date wrong format in Row ' + String.valueOf(rowCnt);            
                        }
                    } else {
                        errmsg += '~Updated Weight Date Missing in Row ' + String.valueOf(rowCnt);
                    }
                }
                if (colCnt == 3) {
                    if (strCol.length() > 0) {
                         apir.Study_Updated_RMR__c = Integer.valueOf(strCol);
                    } else {
                        errmsg += '~Updated RMR Missing in Row ' + String.valueOf(rowCnt);
                    }
                    
                }
                if (colCnt == 4) {
                    if (strCol.length() > 0) {
                        try { 
                            apir.Study_Date_of_Updated_RMR__c = date.parse(strCol);
                        }catch(exception e){
                            errmsg += '~Updated RMR Date wrong format in Row ' + String.valueOf(rowCnt);            
                        }
                    } else {
                        errmsg += '~Updated RMR Date Missing in Row ' + String.valueOf(rowCnt);
                    }
                }
                if (colCnt == 5) {
                    if (strCol.length() > 0) {
                        apir.Study_Update_Calorie_Goal_Food_Deficit__c = Integer.valueOf(strCol);
                    } else {
                        errmsg += '~Updated Calorie Goal Food Deficit Missing in Row ' + String.valueOf(rowCnt);
                    }                        
                }
                
                colCnt++;
                System.debug('apircol: ' + apir);
            }
            apir.Study_Access_Key__c = generateAccessToken();
            System.debug('apir: ' + apir);
            
            if(errmsg == '') {
                lstAPI.add(apir);    
            }
            
            rowCnt++;
        } 
        System.debug('lstAPI: ' + lstAPI);
        insert lstAPI;       
        
        if (!Test.isRunningTest()) {
            DateTime now = DateTIme.now();
            Database.executebatch(new batchCompleteProviderOrders(now,'study'));
        }        
        
        Pagereference p=new Pagereference('/apex/studyUploadHealth?rowCnt=' + String.valueOf(rowCnt));
        if (errmsg != '') {
            p=new Pagereference('/apex/studyUploadHealth?err=' + errmsg);
        } 
        
        p.setredirect(true);
        
        return p;
    }
    
    public static String generateAccessToken() {
        String AccessToken='';
        Integer cnt=1;
        
        MAP<Integer, Boolean> mapInvalidChars = new MAP<Integer, Boolean>();
        mapInvalidChars.put(34,False);
        mapInvalidChars.put(38,False);
        mapInvalidChars.put(39,False);
        mapInvalidChars.put(39,False);
        mapInvalidChars.put(40,False);
        mapInvalidChars.put(41,False);
        mapInvalidChars.put(44,False);
        mapInvalidChars.put(45,False);
        mapInvalidChars.put(46,False);
        mapInvalidChars.put(47,False);
        mapInvalidChars.put(58,False);
        mapInvalidChars.put(59,False);
        mapInvalidChars.put(60,False);
        mapInvalidChars.put(61,False);
        mapInvalidChars.put(62,False);
        mapInvalidChars.put(63,False);
        mapInvalidChars.put(64,False);
        mapInvalidChars.put(91,False);
        mapInvalidChars.put(92,False);
        mapInvalidChars.put(93,False);
        mapInvalidChars.put(95,False);
        mapInvalidChars.put(96,False);
        
        List<Account> lstAcct = [Select  Id, Study_Access_Key__c From Account Where Study_Access_Key__c != Null];
        MAP<String, String> mapAccessKeys = new MAP<String, String>();
        for(Account acct :lstAcct) {
            mapAccessKeys.put(acct.Study_Access_Key__c, acct.Id);
        }
        Boolean goodkey = False;
        Integer goodkeytry = 0;
        While(goodkey == False && goodkeytry < 10){
            
            
            While(cnt < 10) {
                Integer trys = 0;
                Boolean done=false;
                Double rnd;
                while(trys < 100 && done == False) {
                    rnd = Math.floor(Math.random() * ((122-35)+1) + 35);
                    done = mapInvalidChars.get(Integer.valueOf(rnd));
                    trys++;
                }
                String myChar = String.fromCharArray( new List<integer> { Integer.valueOf(rnd) } );
                AccessToken = AccessToken + myChar;
                cnt++;
            }
            //AccessToken = 'L8bo9bSgO';
            
            String fndkey = mapAccessKeys.get(AccessToken);
            system.debug('fndkey:'+fndkey);
            if(fndkey == Null){
                goodkey = True;
                
            }else{
                goodkeytry ++;
            }
        }
        system.debug('goodkey:'+goodkey);
        if(goodkey == False){
            AccessToken = 'BAD KEY';
        }
        return AccessToken;
    }    
    
    
    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        
        //contents = contents.replaceAll('\n\r','\n');
        //contents = contents.replaceAll('\r','\n');
        
        System.debug('contents clean:' + contents);
        
        
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        
        System.debug('lines:' + lines);
        if(lines.size() == 1) {
            lines = contents.split('\r');
        }
        System.debug('lines again:' + lines);        
        
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;       
    }    
}