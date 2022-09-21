global class scheduleBatchUpdateShipmentDayBefore implements Schedulable {    
   global void execute(SchedulableContext sc) {       
       DateTime now = DateTime.now();
       Database.executebatch(new batchUpdateShipmentStatus(now,'Day Before Email',NULL),1);
   }
}