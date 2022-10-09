global class scheduleexpireScholarship implements Schedulable {
   global void execute(SchedulableContext sc) {
      expireScholarship batch = new expireScholarship(); 
      database.executebatch(batch,10);
   }
}