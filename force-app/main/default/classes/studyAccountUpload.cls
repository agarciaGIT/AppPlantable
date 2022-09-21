public class studyAccountUpload {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}
    public Shipment__c  shipment {get;set;}
    public String  results {get;set;}
    public String  errors {get;set;}
    public String  warnings {get;set;}
    
    public studyAccountUpload () {
        shipment = new Shipment__c();
        shipment.Scheduled_Date__c = Date.today();
        
        System.debug('shipment.Scheduled_Date__c: ' + shipment.Scheduled_Date__c);
        
        String errmsg = ApexPages.currentPage().getParameters().get('err');
         String warning = ApexPages.currentPage().getParameters().get('warn');
        String rowCnt = ApexPages.currentPage().getParameters().get('rowCnt');
        results = '';
        if(errmsg != NULL) {
            errors = errmsg;         
        } else if (rowCnt != NULL) {
            results = 'Processed ' + rowCnt + ' Rows.';
            if(warning != NULL) {
                warnings = warning;
            }
        }

    }

    public PageReference tryagain() {
        errors = '';
        results = '';
        return new Pagereference('/apex/studyAccountUpload');
    }
    
    public PageReference ReadFile() {
        
        String errmsg = '';
        String warningmsg = '';
        String doc;
        
        if(contentFile == null) {
            if (Test.isRunningTest()) {
                doc = 'ABC,Bob,Frank,bf@gmail.com,1234567890,134,156,Aaaa,Aaaaa,Aaaa,Aaaa,Aaaa,Aaaa,Aaaa,Aaaa,90,Aaa,Aaa,1,2,3,4,1,20\nABC,Bob,Frank,bf@gmail.com,1234567890,134,156,Aaaa,Aaaaa,Aaaa,Aaaa,Aaaa,Aaaa,Aaaa,Aaaa,90,Aaa,Aaa,1,2,3,4,1,20';
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
            apir.Request_Type__c = 'Customer Update';
            apir.Batch__c = True;
            apir.Study_Account_Owner_ID__c = UserInfo.getUserId();
            
            for(String strCol :arrOut) {
                strCol = strCol.replaceAll('(\\r|\\n)+', '');
                strCol = strCol.replaceAll('"', '');
                
                System.debug('strCol:' + strCol + ':');
                String sRowCount = String.valueOf(rowCnt+1);
                
                
                if(colCnt == 0) {
                    apir.Study_ID__c = strCol;
                }
                if (colCnt == 1) {
                    if (strCol.length() > 0) {
                        apir.First_Name__c = strCol;
                    } else {
                        errmsg += '~First Name Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 2) {
                    if (strCol.length() > 0) {
                        apir.Last_Name__c = strCol;
                    } else {
                        errmsg += '~Last Name Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 3) {
                    if (strCol.length() > 0) {
                        if(strCol.indexOf('@') == -1) {
                            errmsg += '~Email invalid format in Row ' + sRowCount;
                        } else {
                            apir.Customer_Email__c = strCol;    
                        }
                        
                    } else {
                        errmsg += '~Email Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 4) {
                    if (strCol.length() == 10) {
                        apir.Phone__c = strCol;
                    } else if (strCol.length() == 0){
                        errmsg += '~Phone Number Missing in Row ' + sRowCount;
                    } else {
                        errmsg += '~Phone Number Not 10 Digits in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 5) {
                    if (strCol.length() > 0) {
                        try { 
                            apir.Study_Height__c = Integer.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Height is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Height Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 6) {
                    if (strCol.length() > 0) {
                        try {  
                            apir.Study_Weight__c = Integer.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Weight is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Weight Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 7) {
                    if (strCol.length() > 0) {
                        apir.Study_Allergies__c = strCol;
                    } else {
                        warningmsg += '~Allergies Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 8) { 
                    if (strCol.length() > 0) {
                        apir.Study_Breakfast__c = strCol;
                    } else {
                        warningmsg += '~Breakfast Foods Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 9) { 
                    if (strCol.length() > 0) {
                        apir.Study_Lunch__c = strCol;
                    } else {
                        warningmsg += '~Lunch Foods Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 10) { 
                    if (strCol.length() > 0) {
                        apir.Study_Dinner__c = strCol;
                    } else {
                        warningmsg += '~Dinner Foods Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 11) { 
                    if (strCol.length() > 0) {
                        apir.Study_Water__c = strCol;
                    } else {
                        warningmsg += '~Water Consumption Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 12) { 
                    if (strCol.length() > 0) {
                        apir.Study_Between_Meals__c = strCol;
                    } else {
                        warningmsg += '~Food Between Meals Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 13) { 
                    if (strCol.length() > 0) {
                        apir.Study_After_Dinner__c = strCol;
                    } else {
                        warningmsg += '~Food After Dinner Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 14) { 
                    if (strCol.length() > 0) {
                        apir.Study_Sugar__c = strCol;
                    } else {
                        warningmsg += '~Sugar Consumption Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 15) { 
                    if (strCol.length() > 0) {
                        try { 
                            apir.Study_BMI__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~BMI is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~BMI Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 16) { 
                    if (strCol.length() > 0) {
                        apir.Study_Diets__c = strCol;
                    } else {
                        warningmsg += '~Diets Missing in Row ' + sRowCount;
                    }
                }   
                if (colCnt == 17) { 
                    if (strCol.length() > 0) {
                        apir.Study_Physical_Activity__c = strCol;
                    } else {
                        warningmsg += '~Physical Activity Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 18) { 
                    if (strCol.length() > 0) {
                        apir.Study_Exercises__c = strCol;
                    } else {
                        warningmsg += '~Exercise Programs Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 19) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Strenuous_Exercise_per_Week__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Strenuous Exercise per Week is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Strenuous Exercise per Week Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 20) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Duration_Strenuous_Exercise__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Strenuous Exercise Duration is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Strenuous Exercise Duration Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 21) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Moderate_Exercise_per_Week__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Moderate Exercise per Week is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Moderate Exercise per Week Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 22) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Duration_Moderate_Exercise__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Moderate Exercise Duration is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Moderate Exercise Duration Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 23) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Mild_Exercise_per_Week__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Mild Exercise per Week is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Mild Exercise per Week Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 24) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Duration_Mild_Exercise__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Mild Exercise Duration is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Mild Exercise Duration Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 25) { 
                    if (strCol.length() > 0) {
                        if (strCol == '1') {
                            apir.Study_Opt_Out_Communications__c = True;
                        } else {
                            apir.Study_Opt_Out_Communications__c = False;
                        }
                        
                    } else {
                        warningmsg += '~Opt Out Missing in Row ' + sRowCount;
                        apir.Study_Opt_Out_Communications__c = False;
                    }
                }
                if (colCnt == 26) { 
                    if (strCol.length() > 0) {
                        try {
                            apir.Study_Initial_RMR__c = Decimal.valueOf(strCol);
                        } catch(exception e){
                            errmsg += '~Initial RMR is not a number in Row ' + sRowCount;
                        }
                    } else {
                        warningmsg += '~Initial RMR Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 27) {
                    if (strCol.length() > 0) {
                        apir.Study_Initial_Calorie_Goal_Food_Deficit__c = Integer.valueOf(strCol);
                    } else {
                        errmsg += '~Initial Calorie Goal Food Deficit Missing in Row ' + sRowCount;
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
        try {
        	insert lstAPI;       
        } catch(exception ex){
            errmsg += '~There was an error processing your account upload! ' + ex.getMessage();
            App_Error__c ae = new App_Error__c(Details__c = ex.getMessage());
            insert ae;
        }
        
        if (!Test.isRunningTest()) {
            DateTime now = DateTIme.now();
            Database.executebatch(new batchCompleteProviderOrders(now,'study'));
        }        
        
        Pagereference p=new Pagereference('/apex/studyAccountUpload?rowCnt=' + String.valueOf(rowCnt));
        if (errmsg != '' || warningmsg != '') {
            if(errmsg != '' && warningmsg == '') {
                p=new Pagereference('/apex/studyAccountUpload?err=' + errmsg);
            }
            if(errmsg != '' && warningmsg != '') {
                p=new Pagereference('/apex/studyAccountUpload?err=' + errmsg + '&warn=' + warningmsg);
            }            
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
    
        System.debug('contents:' + contents);
    
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
        
        System.debug('line:' + line);
        
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            
            System.debug('fields:' + fields);
            
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