global class ScheduleAutoConvertLead implements Schedulable {
   global void execute(SchedulableContext sc) {
      AutoConvertLeadsbatch b = new AutoConvertLeadsbatch(); 
      database.executebatch(b,10);
   }
}