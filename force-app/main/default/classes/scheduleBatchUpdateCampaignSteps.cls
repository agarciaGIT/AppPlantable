global class scheduleBatchUpdateCampaignSteps implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchUpdateCampaignSteps batch = new batchUpdateCampaignSteps(null); 
      database.executebatch(batch,1);
   }
}