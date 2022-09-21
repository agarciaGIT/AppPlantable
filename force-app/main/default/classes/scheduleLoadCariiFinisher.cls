global class scheduleLoadCariiFinisher implements Schedulable {
   global void execute(SchedulableContext sc) {
       Date tdy = Date.today();
       tdy = tdy.addDays(-1);
       cariiClass.loadSurvey(tdy.format(),'Finisher',null);
   }
}