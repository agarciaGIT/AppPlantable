global class scheduleBatchCleanAPISessions implements Schedulable {
   global void execute(SchedulableContext sc) {
       DateTime now = DateTime.now();       
       batchCleanAPISessions batch = new batchCleanAPISessions(now, null); 
       database.executebatch(batch);
   }
}