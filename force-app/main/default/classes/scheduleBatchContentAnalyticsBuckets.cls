global class scheduleBatchContentAnalyticsBuckets implements Schedulable {
    global void execute(SchedulableContext sc) {
        
        integer weekNum = integer.valueof(System.Now().Format('w'));
        system.debug('weekNum:' + String.valueOf(weekNum));
        
        integer bucketNumber = 2;
        integer mod = Math.mod(weekNum, 2);
        
        system.debug('mod:' + String.valueOf(mod));
        
        if(mod == 0) {
            bucketNumber = 1;
        }
        
        system.debug('bucketNumber:' + String.valueOf(bucketNumber));
        
        batchContentAnalyticsBuckets batch = new batchContentAnalyticsBuckets(bucketNumber,'swap',NULL); 
        database.executebatch(batch);
    }
}