global class scheduleBatchUpdateShipmentStatus implements Schedulable {
   global void execute(SchedulableContext sc) {       
       DateTime now = DateTime.now();
       Database.executebatch(new batchUpdateShipmentStatus(now,'Set Status',NULL),1);
   }
}