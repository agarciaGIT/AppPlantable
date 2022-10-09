global class scheduleBatchDeDupeLeads implements Schedulable {
   string recordId;
   global void execute(SchedulableContext sc) {
      batchDeDupeLeads b = new batchDeDupeLeads(null); 
      database.executebatch(b);
   }
}