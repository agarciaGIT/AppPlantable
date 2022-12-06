global class SageDailySyncUpdatesBatchScheduler implements Schedulable{
	global void execute(SchedulableContext sc) {
      SageDailySyncUpdatesBatch batch = new SageDailySyncUpdatesBatch(); 
      database.executebatch(batch);
   }
}