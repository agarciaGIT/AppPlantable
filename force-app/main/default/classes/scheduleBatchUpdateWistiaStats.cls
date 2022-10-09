global class scheduleBatchUpdateWistiaStats implements Schedulable {
   global void execute(SchedulableContext sc) {
		Database.executebatch(new batchUpdateWistiaStats(),10);
   }
}