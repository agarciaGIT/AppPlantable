global class scheduleBatchUpdateShipmentStatusTouch implements Schedulable {    
   global void execute(SchedulableContext sc) {       
       DateTime now = DateTime.now();
       Database.executebatch(new batchUpdateShipmentStatus(now,'Send Email',NULL));
   }
}