global class scheduleBatchFontevaRemoveBadges implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchFontevaRemoveBadges batch = new batchFontevaRemoveBadges(); 
      database.executebatch(batch,200);
   }
}