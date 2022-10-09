global class scheduleBatchMoveUserPhotos implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchMoveUserPhotos batch = new batchMoveUserPhotos(null); 
      database.executebatch(batch,1);
   }
}