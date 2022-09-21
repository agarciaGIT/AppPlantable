global class scheduleLoadCariiChat implements Schedulable {
   global void execute(SchedulableContext sc) {
       Date tdy = Date.today();
       tdy = tdy.addDays(-1);
       cariiClass.loadChat(tdy.format(),null);
   }
}