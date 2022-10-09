global class scheduleBatchUpdateContractKPIs implements Schedulable {
   global void execute(SchedulableContext sc) {
   
        Database.executeBatch(new batchUpdateContractKPIs ('inc'),50);
   
   }
}