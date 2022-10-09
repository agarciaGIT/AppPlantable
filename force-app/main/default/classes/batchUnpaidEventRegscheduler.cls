global class batchUnpaidEventRegscheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchUnpaidEventRegistrations batch = new batchUnpaidEventRegistrations(NULL); 
      database.executebatch(batch,10);
   }
}