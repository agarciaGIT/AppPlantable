public without sharing class GBI_Study_Info {
    @AuraEnabled(cacheable = true)
    public static List<Study__c> getStudies(){
        return GBI_BC_Studies.getAllActiveStudies();
    }
    

}