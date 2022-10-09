global class schedulebatchjobtodeleterecords implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchjobtodeleterecords batch = new batchjobtodeleterecords(); 
      database.executebatch(batch,10);
   }
}