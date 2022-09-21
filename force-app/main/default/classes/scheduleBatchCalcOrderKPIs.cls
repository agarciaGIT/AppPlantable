global class scheduleBatchCalcOrderKPIs implements Schedulable {
   global void execute(SchedulableContext sc) {
       DateTime now = DateTime.now();       
       batchCalcOrderKPIs batch = new batchCalcOrderKPIs(now, null); 
       database.executebatch(batch);
   }
}