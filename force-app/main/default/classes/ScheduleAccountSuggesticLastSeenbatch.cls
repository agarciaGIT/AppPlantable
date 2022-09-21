global class ScheduleAccountSuggesticLastSeenbatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      AccountSuggesticLastSeenbatch  b = new AccountSuggesticLastSeenbatch (); 
      database.executebatch(b,1);
   }
}