public class studyShipmentUpload {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}
    public Shipment__c  shipment {get;set;}
    public String  results {get;set;}
    public String  errors {get;set;}
    public String  warnings {get;set;}
    
    
    public studyShipmentUpload () {
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
        return new Pagereference('/apex/studyShipmentUpload');
    }
    

    public PageReference ReadFile() {
        
        String errmsg = '';
        String warningmsg = '';
        String doc;
        
        if(contentFile == null) {
            if (Test.isRunningTest()) {
                doc = 'ABC,ABC,ABC,ABC,ABC,ABC,ABC,ABC,ABC,1234567890,ABC,ABC\nABC,ABC,ABC,ABC@abc.com,ABC,ABC,ABC,ABC,ABC,1234567890,10/21/2019,ABC';
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
            apir.Request_Type__c = 'Create Order';
            apir.Created_At__c = DateTime.now();
            apir.Batch__c = True;
            
            for(String strCol :arrOut) {
                strCol = strCol.replaceAll('(\\r|\\n)+', '');
                strCol = strCol.replaceAll('"', '');
                System.debug('strCol:' + strCol + ':');
                String sRowCount = String.valueOf(rowCnt+1);
                
                if(colCnt == 0) {
                    if (strCol.length() > 0) {
                         apir.Study_ID__c = strCol;
                    } else {
                        errmsg += '~Study ID Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 1) {
                    if (strCol.length() > 0) {
                         apir.First_Name__c = strCol;
                         apir.Shipping_First_Name__c = strCol;
                    } else {
                        errmsg += '~First Name Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 2) {
                    if (strCol.length() > 0) {
                         apir.Last_Name__c = strCol;
                        apir.Shipping_Last_Name__c = strCol;

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
                     if (strCol.length() >0) {
                         apir.Shipping_Street1__c = strCol;
                    } else {
                        errmsg += '~Shipping Address Line 1 Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 5) {
                    if (strCol.length() > 0) {
                         apir.Shipping_Street2__c = strCol;
                    }
                    
                }
                if (colCnt == 6) {
                     if (strCol.length() > 0) {
                         apir.Shipping_City__c = strCol;
                    } else {
                        errmsg += '~Shipping City Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 7) {
                    if (strCol.length() > 0) {
                         apir.Shipping_State__c = strCol;
                    } else {
                        errmsg += '~Shipping State Missing in Row ' + sRowCount;
                    }
                    
                }
                if (colCnt == 8) {
                    if (strCol.length() > 0) {
                         apir.Shipping_Zip__c = strCol;
                    } else {
                        errmsg += '~Shipping Zip Missing in Row ' + sRowCount;
                    }
                
                }
                if (colCnt == 9) {
                     if (strCol.length() == 10) {
                         apir.Phone__c = strCol;
                    } else if (strCol.length() == 0) {
                        errmsg += '~Phone Number Missing in Row ' + sRowCount;
                    } else {
                        errmsg += '~Phone Number Not 10 Digits in Row ' + sRowCount;
                    }
                }
                if (colCnt == 10) {
                    if (strCol.length() > 0) {
                        try {
                            Date sd = date.parse(strCol);
                            if(sd < date.today()) {
                                errmsg += '~Ship Date needs to be in the future';
                            } else {
                                apir.Ship_Date__c = sd;    
                            }
                            
                        } catch(exception e) {
                            errmsg += '~Ship Date is wrong format, must be m/d/yyyy';
                        }
                        
                    } else {
                        errmsg += '~Ship Date Missing in Row ' + sRowCount;
                    }
                }
                if (colCnt == 11) {
                    if (strCol.length() > 0) {
                        apir.Study_Order_Reference_Number__c = strCol;
                    } else {
                        errmsg += '~MSK Reference Number Missing in Row ' + sRowCount;
                    }
                }
                colCnt++;
            }
            System.debug('apir: ' + apir);
            
            if(errmsg == '') {
                lstAPI.add(apir);    
            }
            
            
            rowCnt++;
        }    
        
        System.debug('lstAPI: ' + lstAPI);
        
        MAP<String,Date> shipEmails = new MAP<String,Date>();
        for(API_Request__c apr :lstAPI) {
            shipEmails.put(apr.Customer_Email__c, apr.Ship_Date__c);
        }
        
        System.debug('shipEmails: ' + shipEmails);        
        
        Integer dupeShipmentfound = 0;
        List<Shipment__c> ships = [select Id, Email_Address__c, Scheduled_Date__c from Shipment__c where Email_Address__c in :shipEmails.keySet() AND Status__c = 'Pending' AND Product_Code__c = 'OTCM'];
        System.debug('ships:' + ships);       
        
        for(Shipment__c s :ships) {
            Date fndShip = shipEmails.get(s.Email_Address__c);
            if(fndShip != NULL) {
                if(fndShip == s.Scheduled_Date__c) {
                    dupeShipmentfound++;
                }
            }
        }
        System.debug('dupeShipmentfound:' + dupeShipmentfound);  
        
        if(dupeShipmentfound > 0) {
            errmsg +=  + '~' + dupeShipmentfound + ' Duplicate shipments found. You cannot upload a shipment for someone that has already been uploaded for the same ship date. To update shipment info please contact hello@platable.com';
        }
        System.debug('errmsg:' + errmsg);  
        
        
        if(errmsg == '') {            
            try {
                insert lstAPI;
            } catch(exception ex){
                errmsg += '~There was an error processing your shipment upload! ' + ex.getMessage();
                App_Error__c ae = new App_Error__c(Details__c = ex.getMessage());
                insert ae;
            }
            
            if (!Test.isRunningTest() && errmsg == '') {
                DateTime now = DateTIme.now();
                Database.executebatch(new batchCompleteProviderOrders(now,'study'));
            }
        }
        
        Pagereference p=new Pagereference('/apex/studyShipmentUpload?rowCnt=' + String.valueOf(rowCnt));
        if (errmsg != '' || warningmsg != '') {
            if(errmsg != '' && warningmsg == '') {
                p=new Pagereference('/apex/studyShipmentUpload?err=' + errmsg);
            }
            if(errmsg != '' && warningmsg != '') {
                p=new Pagereference('/apex/studyShipmentUpload?err=' + errmsg + '&warn=' + warningmsg);
            }            
        } 
        
        p.setredirect(true);
        
        return p;
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