global class SageDailySyncUpdatesBatch implements Database.Batchable<sObject>, Database.Stateful {
    global String csvColumnHeaderOK;
    global List<String> csvRowValuesOK = new List<String>();
    global String csvColumnHeaderError;
    global List<String> csvRowValuesError = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        DATE today = system.today();
        if(test.isRunningTest()){
            query = 'SELECT Id,Sage_Order_Approved__c,ia_crm__Intacct_Sync_Errors_1__c,Display_Invoice_Number__c,Amount,ia_crm__Intacct_Sync_Status_1__c '+ 
                'FROM Opportunity LIMIT 2   ';
        } else {
            query = 'SELECT Id,ia_crm__Intacct_Sync_Errors_1__c,Display_Invoice_Number__c,Amount,Sage_Order_Approved__c,ia_crm__Intacct_Sync_Status_1__c '+ 
                'FROM Opportunity where Sage_Order_Approved__c = TRUE AND (ia_crm__Intacct_Sync_Status_1__c = \'OK\' OR ia_crm__Intacct_Sync_Status_1__c = \'Error\' )  ';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        system.debug(scope.size()+'   <<::scope::>>   '+scope);
        String IntacctSyncErrors = '';
        String RecordID = '';
        string InvoiceNumber ='';
        Double AmountOK = 0;
        Double GrandTotalOK =0;
        Double AmountError = 0;
        Double GrandTotalError =0;
        
        for(Opportunity oppData : scope){
            RecordID = oppData.Id; 
            InvoiceNumber =oppData.Display_Invoice_Number__c != null ? oppData.Display_Invoice_Number__c : '';
            if(oppData.ia_crm__Intacct_Sync_Status_1__c == 'OK'){
                AmountOK =oppData.Amount != null ? oppData.Amount : null;
                String rowStr = RecordID +','+InvoiceNumber+','+AmountOK;  
                csvRowValuesOK.add(rowStr);
            }
            
            if(oppData.ia_crm__Intacct_Sync_Status_1__c == 'Error'){
                AmountError =oppData.Amount != null ? oppData.Amount : null;
                IntacctSyncErrors = oppData.ia_crm__Intacct_Sync_Errors_1__c != null ? oppData.ia_crm__Intacct_Sync_Errors_1__c.replaceAll('<br>','').replaceAll('&',' and ').replaceAll('<[^>]+>',' ') : '';
                String rowStr = RecordID +','+InvoiceNumber+','+AmountError+','+IntacctSyncErrors.stripHtmlTags();  
                csvRowValuesError.add(rowStr);
            }
            
        }
        
        for(Opportunity oppData : scope){
            if(oppData.ia_crm__Intacct_Sync_Status_1__c == 'OK'){
                GrandTotalOK = GrandTotalOK + oppData.Amount;
            }
            if(oppData.ia_crm__Intacct_Sync_Status_1__c == 'Error'){
                GrandTotalError = GrandTotalError + oppData.Amount;
            }
        }
        
        if(csvRowValuesOK.size() > 0){
            String rowStrOK = '' +','+'Grand Total'+','+GrandTotalOK;  
            csvRowValuesOK.add(rowStrOK);
        }
        
        if(csvRowValuesError.size() > 0){
            String rowStr = '' +','+'Grand Total'+','+GrandTotalError;  
            csvRowValuesError.add(rowStr);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        if(!csvRowValuesError.isEmpty() || !csvRowValuesOK.isEmpty()){
            List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
            if(!csvRowValuesOK.isEmpty()){
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                string csvname= 'SageSyncDataOKGrandTotal.csv';
                csvAttc.setFileName(csvname);
                csvColumnHeaderOK = 'RecordID,InvoiceNumber,Amount, \n';
                String csvFileOK = csvColumnHeaderOK + String.join(csvRowValuesOK,'\n');
                system.debug('csvFileOK::>>    '+csvFileOK); 
                blob csvBlobOK = Blob.valueOf(csvFileOK);
                csvAttc.setBody(csvBlobOK);
                lstEmailAttachments.add(csvAttc);
            }
            
            if(!csvRowValuesError.isEmpty()){
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                string csvname= 'SageSyncDataErrorGrandTotal.csv';
                csvAttc.setFileName(csvname);
                csvColumnHeaderError = 'RecordID,InvoiceNumber,Amount,IntacctSyncErrors, \n';
                String csvFileError = csvColumnHeaderError + String.join(csvRowValuesError,'\n');
                system.debug('csvFileError::>>    '+csvFileError); 
                blob csvBlobError = Blob.valueOf(csvFileError);
                csvAttc.setBody(csvBlobError);
                lstEmailAttachments.add(csvAttc);
            }
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String receipientList = system.label.Exception_Recipient_List;
            List<String> toAddresses = new list<string>();
            toAddresses.addall(receipientList.split(','));
            String subject ='Sage Sync Data GrandTotal CSV';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Sage Sync Data GrandTotal CSV ');
            
            email.setFileAttachments(lstEmailAttachments);
            if(!test.isRunningTest()){
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    }
    
}