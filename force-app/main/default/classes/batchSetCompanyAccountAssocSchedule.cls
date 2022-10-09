global class batchSetCompanyAccountAssocSchedule implements Schedulable{
	global void execute(SchedulableContext sc) {
		batchSetCompanyAccountAssoc batch = new batchSetCompanyAccountAssoc('join',null);
		Database.executeBatch(batch);
	}
}