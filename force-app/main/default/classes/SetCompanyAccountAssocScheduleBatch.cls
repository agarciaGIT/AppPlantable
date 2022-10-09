global class SetCompanyAccountAssocScheduleBatch implements Schedulable{
	global void execute(SchedulableContext sc) {
		SetCompanyAccountAssocBatch batch = new SetCompanyAccountAssocBatch('frm');
		Database.executeBatch(batch);
	}
}