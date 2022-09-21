global class scheduleBatchUpdateShipmentCoach28Days implements Schedulable {    
   global void execute(SchedulableContext sc) {       
       DateTime now = DateTime.now();
       Database.executebatch(new batchUpdateShipmentStatus(now,'Coach 28 Days',NULL),1);
   }
}