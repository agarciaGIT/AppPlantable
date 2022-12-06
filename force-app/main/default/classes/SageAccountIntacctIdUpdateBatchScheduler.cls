global class SageAccountIntacctIdUpdateBatchScheduler implements Schedulable{
	global void execute(SchedulableContext sc) {
      SageAccountIntacctIdUpdateBatch batch = new SageAccountIntacctIdUpdateBatch(); 
      database.executebatch(batch);
   }
}