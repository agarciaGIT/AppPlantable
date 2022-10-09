global class sendPearsonErrorEmailNotificationBatch implements Database.Batchable<sObject>, Database.Stateful{
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        Id SCRRecId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('SCR_Program').getRecordTypeId();
		 Id ICBRRRecId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ICBRR_Program').getRecordTypeId();
        //Query all Contract records.
        String query = 'SELECT Id FROM Contract where (RecordTypeId =:SCRRecId OR RecordTypeId =:ICBRRRecId) AND Status =\'Activated\' And Createddate = today';
        
        return Database.getQueryLocator(query);
    }
   //contract num, inte, eventtype,aut type 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> contractId = new Set<Id>();
		for(Contract con:(List<Contract>) scope){
			contractId.add(con.Id);
		}
		
		Map<String,Integration_Data__c> integrationSuccessMap = new Map<String,Integration_Data__c>();
		Map<String,Integration_Data__c> integrationErrorMap = new Map<String,Integration_Data__c>();
		for(Integration_Data__c intdata:[SELECT Contract__c,Call_out_Status__c,Outbound_Event_Types__c,Contract__r.ContractNumber,Id,Name,CreatedDate,Call_out_Type__c FROM Integration_Data__c where Contract__c In:contractId And Call_out_Type__c ='Out-bound' ORDER BY Call_out_Status__c DESC]){ 
			String Key = intdata.Contract__c+''+intdata.Outbound_Event_Types__c; 
			if(intdata.Call_out_Status__c == 'Error' && !integrationErrorMap.containsKey(Key)){
				integrationErrorMap.put(Key,intdata);
			}
			if(intdata.Call_out_Status__c == 'Processed' && !integrationSuccessMap.containsKey(Key) && integrationErrorMap.containsKey(key)){
				if(intdata.CreatedDate > integrationErrorMap.get(Key).CreatedDate)
				integrationSuccessMap.put(Key,intdata); 
			}
		}
		
		for(String s:integrationErrorMap.KeySet()){
			if(integrationSuccessMap.containsKey(s)){
				integrationErrorMap.remove(s);
			}
		}
		
		for(String s:integrationErrorMap.KeySet()){
            Integration_Data__c Pearson = integrationErrorMap.get(s);
            String contractrecId = Pearson.Contract__c != null ? Pearson.Contract__c : '';
            String contractName = Pearson.Contract__r.ContractNumber != null ? Pearson.Contract__r.ContractNumber : '';
            String recId = Pearson.Id != null ? String.valueOf(Pearson.Id).escapeCsv() : '';
            String RecName = Pearson.Name != null ? Pearson.Name : ''; 
            String EventType = Pearson.Outbound_Event_Types__c != null ? Pearson.Outbound_Event_Types__c : ''; 
            String formattedDate = '';
            if(Pearson.CreatedDate != null)
                formattedDate = Pearson.CreatedDate.format('MM/dd/yyyy h:mm:ss a z');
            String rowStr = contractrecId + ',' + contractName + ',' + recId + ',' + RecName + ','+ EventType +','+ formattedDate;
            csvRowValues.add(rowStr); 
            
		}  
        
    }
   
    global void finish(Database.BatchableContext BC){
        try{
            Pearson_Ping_Error_Notification__c emailnotificaion = Pearson_Ping_Error_Notification__c.getInstance();
            if(emailnotificaion.Email__c != null){
                List<String> toAddresses = emailnotificaion.Email__c.split(',');
                String subject = emailnotificaion.Subject__c;
                csvColumnHeader = 'contract, contract Name, recId, RecName, Event Type, CreatedDate\n';
                String csvFile = csvColumnHeader + String.join(csvRowValues,'\n'); 
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(csvFile);
                string csvname= 'Pearson Error.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                
                email.setSubject(subject);
                email.setToAddresses( toAddresses );
                email.setPlainTextBody('Error CSV ');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }catch(Exception ex){
            
        }
    } 
}