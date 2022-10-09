public class BackupExamRegistrationController {
    
	public Id jobId { get; set; }   
    public String status { get; set; }
    public Boolean enabled { get; set; }
    public List<Lead> leads { get; set; }
    public String jsonString { get; set; }
    public AsyncApexJob batchJob { get; set; }

    public PageReference startJob(){
      
        this.status = 'Starting...';
        this.batchJob = null;
        
        String cleaned = this.jsonString.replaceAll('"_id":', '"id":');
        cleaned = cleaned.replaceAll('"\\$oid":', '"oid":');
        
        System.debug(cleaned);
         
        List<MongoDbExamRegistration> mongoDbExamRegistrations = (List<MongoDbExamRegistration>)JSON.deserialize(cleaned, List<MongoDbExamRegistration>.class);
        
        this.enabled = true;
        
        this.jobId = database.executeBatch(new BackupExamRegistrationBatch(mongoDbExamRegistrations), 1);
      
        return null;

    }
    
    public PageReference checkBatchStatus(){
        
        if(this.jobId != null){
        
            this.batchJob = [
                SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, ExtendedStatus 
                FROM AsyncApexJob 
                WHERE Id = :this.jobId
            ];
            
            if(this.batchJob.TotalJobItems != null){
                this.status = this.batchJob.Status + ' (' + this.batchJob.JobItemsProcessed + '/' + this.batchJob.TotalJobItems + ')';
            }else if(this.batchJob.TotalJobItems == null){
                this.status = this.batchJob.Status;
            }
            
            if(this.batchJob.Status == 'Completed'){
                this.leads = [
                  	SELECT Id, Name, Email, LastModifiedDate, Backup_Exam_Registration_MongoDB_OID__c, Backup_Exam_Registration_Import_Failed__c, Backup_Exam_Registration_Logging__c   
                    FROM Lead 
                    WHERE Backup_Exam_Registration_Batch_ID__c = :this.jobId
                ];
            }

        }
        
        return null;
        
    }
    
    public BackupExamRegistrationController(ApexPages.StandardController ctrl){}
    
}