trigger TeamRegistrationTrigger on Team_Registration__c (before insert, before update) {
	TeamRegistrationTriggerHandler.checkAccessCode(trigger.new);
}