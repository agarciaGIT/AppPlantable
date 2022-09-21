global class scheduleBatchCompleteProviderOrders implements Schedulable {
   global void execute(SchedulableContext sc) {
       DateTime now = DateTime.now();       
       batchCompleteProviderOrders batch = new batchCompleteProviderOrders(now, null); 
       database.executebatch(batch,1);
   }
}