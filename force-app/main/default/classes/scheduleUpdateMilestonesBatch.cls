global class scheduleUpdateMilestonesBatch implements Schedulable {
	global void execute(SchedulableContext sc) {
    	updateMilestonesDays_Batch batch = new updateMilestonesDays_Batch(); 
      	database.executebatch(batch);
    }
}