@isTest
private with sharing class TagManagerControllerTest {

    @TestSetup
    private static void setup(){
        INSERT new Tag_Manager__c(Route_Pattern__c = '/test/*', Event_Type__c = 'conversion');
    }

    @isTest
    private static void getTags() {
        new TagManagerController(new sfdcAppRemoter());
        TagManagerController.getTagManagerData();
    }
}