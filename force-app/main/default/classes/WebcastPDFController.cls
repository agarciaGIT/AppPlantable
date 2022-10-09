public class WebcastPDFController {
    public  Webcast__c web;
    
    public String moderator{get;set;}
    public String speaker{get;set;}
  
    
    
    public webcastPDFController(ApexPages.StandardController stdController){
        this.web = (webcast__c)stdController.getRecord();
        List<Presenter__c> allPresenters = [Select id, Contact__r.title, Contact__r.company__c, name, role__c from Presenter__c where webcast__c =:web.id];
        
        web = [Select title__c, Description__c, Start_Date__c, Duration__c, End_Date__c, Prerecorded_Clips__c, Is_Auto_Registration_Required__c, Start_Time__c,
               End_Time__c, format__c
               from webcast__c Where id =:web.id];
        
        
        moderator='';
        speaker='';
        //Make sure to ask if a speaker will always have a contact connected. If not then this code needs to know what to do when one does not exist or the relevant fields are empty
        for(presenter__c currentPresenter : allPresenters){
            if(currentPresenter.Role__c == 'Moderator'){
                moderator+= currentPresenter.name + ', ' +currentPresenter.Contact__r.title + ', ' + currentPresenter.contact__r.company__c;
            }
            else{
                speaker+= currentPresenter.name + ', ' +currentPresenter.Contact__r.title + ', ' + currentPresenter.contact__r.company__c;
            }
        }
    }
    
}