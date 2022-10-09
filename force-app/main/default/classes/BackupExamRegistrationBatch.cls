global class BackupExamRegistrationBatch implements Database.Batchable<MongoDbExamRegistration>, Database.Stateful{

    public List<MongoDbExamRegistration> mongoDbExamRegistrations { get; set; }
    
    public BackupExamRegistrationBatch(List<MongoDbExamRegistration> mongoDbExamRegistrations){
        this.mongoDbExamRegistrations = mongoDbExamRegistrations;
    }
    
    public Iterable<MongoDbExamRegistration> start(Database.BatchableContext bc) {                
        return this.mongoDbExamRegistrations;
    }

    public void execute(Database.BatchableContext bc, List<MongoDbExamRegistration> mongoDbExamRegistrations) {
        for(MongoDbExamRegistration mongoDbExamRegistration: mongoDbExamRegistrations){
            BackupExamRegistrationHelper.createExamRegistration(bc.getJobId(), mongoDbExamRegistration);
        }
                
    }

    public void finish(Database.BatchableContext bc) {
        
    }
    
}