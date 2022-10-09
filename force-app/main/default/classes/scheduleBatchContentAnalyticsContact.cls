global class scheduleBatchContentAnalyticsContact implements Schedulable {
    global void execute(SchedulableContext sc) {
        batchContentAnalyticsContact batch = new batchContentAnalyticsContact(NULL); 
        database.executebatch(batch);
    }
}