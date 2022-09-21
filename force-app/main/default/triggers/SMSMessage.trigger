trigger SMSMessage on SMS_Message__c (after insert) {
	if(Trigger.isAfter) {
         SMSSupportAppController.publishNewSMSNotifications(Trigger.new);
    }
}