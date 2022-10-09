public class TagManagerController {

    @RemoteAction
    public static List<Tag_Manager__c> getTagManagerData(){
        return [
          SELECT Id, Type__c, Category__c, Send_To__c, Route_Pattern__c, Event_Type__c
          FROM Tag_Manager__c
        ];
    }
 
    public TagManagerController(sfdcAppRemoter ctrl){}
    
}