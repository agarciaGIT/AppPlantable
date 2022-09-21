global class scheduleLoadCariiTracking implements Schedulable {
   global void execute(SchedulableContext sc) {
       Date tdy = Date.today();
       tdy = tdy.addDays(-1);
       cariiClass.loadTracking(tdy.format(),null);
   }
}