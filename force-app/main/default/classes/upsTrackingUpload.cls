public class upsTrackingUpload {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}
    public Shipment__c  shipment {get;set;}
    public String  results {get;set;}
    
    public upsTrackingUpload() {
        shipment = new Shipment__c();
        shipment.Scheduled_Date__c = Date.today();
        
        System.debug('shipment.Scheduled_Date__c: ' + shipment.Scheduled_Date__c);
        
        String rows = ApexPages.currentPage().getParameters().get('rows');
		String updates = ApexPages.currentPage().getParameters().get('updates');
        results = '';
        if(rows != NULL) {
            results = rows + ' rows uploaded. ';
            results += updates + ' shipments upated with tracking numbers.';            
        }

    }

    public PageReference ReadFile() {
        
        
        if(contentFile == null) return null;

         String doc = contentFile.toString();
         //system.debug('doc == '+doc);
        
        List<List<String>> csvArray = new List<List<String>>();
        csvArray = parseCSV(doc, true);
        system.debug('csvArray == '+csvArray);
        
        MAP<String,String> emailMap = new MAP<String,String>();
        Set<String> emails = new Set<String>();
        Integer rowCnt=0;
        for(List<String> arrOut :csvArray) {   
            Integer colCnt=0;
            String trackingNumber;
            String referenceNumber;            
            for(String strCol :arrOut) {
                if(colCnt == 0) {
                    trackingNumber = strCol;
                }
                if(colCnt == 3) {
                    referenceNumber = strCol;
                }
                colCnt++;
            }
            System.debug('trackingNumber: ' + trackingNumber);
            System.debug('referenceNumber: ' + referenceNumber);
            emailMap.put(referenceNumber,trackingNumber);
            emails.add(referenceNumber);
            rowCnt++;
        }        
        
        List<Shipment__c> lstShips = [select Id, Name, Shipment_Code__c, Tracking_Number__c, Scheduled_Date__c from Shipment__c where Scheduled_Date__c = :shipment.Scheduled_Date__c AND Shipping_Type__c = 'UPS'];
        System.debug('lstShips: ' + lstShips);
        
		List<Shipment__c> updateShip = new List<Shipment__c>();
        for(Shipment__c ship :lstShips) {
            String fndTrack = emailMap.get(ship.Shipment_Code__c);
            System.debug('fndTrack: ' + fndTrack);
            if(fndTrack != NULL) {
                ship.Tracking_Number__c = fndTrack;
                updateShip.add(ship);
            }
        }        
        System.debug('updateShip: ' + updateShip);
        update updateShip;
                
        Pagereference p=new Pagereference('/apex/upsTrackingUpload?rows=' + String.valueOf(rowCnt) + '&updates=' + String.valueOf(updateShip.size()));
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
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
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