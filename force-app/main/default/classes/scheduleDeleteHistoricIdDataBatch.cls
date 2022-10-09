global class scheduleDeleteHistoricIdDataBatch implements Schedulable {
    private String examType;
    public scheduleDeleteHistoricIdDataBatch(string examType){
        this.examType = examType;
    }
	global void execute(SchedulableContext sc) {
    	deleteHistoricIdDataBatch batch = new deleteHistoricIdDataBatch(examType); 
      	database.executebatch(batch,10);
    }
}