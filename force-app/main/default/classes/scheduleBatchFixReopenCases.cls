global class scheduleBatchFixReopenCases implements Schedulable {
   global void execute(SchedulableContext sc) {
       DateTime now = DateTime.now();       
       batchFixReopenCases batch = new batchFixReopenCases(now, null); 
       database.executebatch(batch);
   }
}