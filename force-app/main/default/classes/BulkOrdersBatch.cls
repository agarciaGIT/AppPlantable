global class BulkOrdersBatch {
  WebService static void invokeBulkOrdersBatch (){
    ID batchprocessid = Database.executeBatch(new BulkorderBatchclass());
  }
 }