public class EmailMessageUtil {
    
    public List<String> emailAddresses {get; set;}
    
    public void sendBatchFinishedNotification(Database.BatchableContext bc){

		AsyncApexJob job = [SELECT Id, ApexClassId, NumberOfErrors, TotalJobItems FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		ApexClass apexClass = [SELECT Id, Name FROM ApexClass WHERE Id =: job.ApexClassId];
       
		if(job.NumberOfErrors > 0){
			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
			msg.setToAddresses(this.emailAddresses);
			msg.setSubject(apexClass.Name + ' scheduled batch job encountered an error.');
			msg.setPlainTextBody('Processed ' + job.TotalJobItems + ' batches and encountered ' + job.NumberOfErrors + ' failures.');
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ msg });
		} 
        
    }

    public EmailMessageUtil(List<String> emailAddresses){
        this.emailAddresses = emailAddresses;
    }
    
}