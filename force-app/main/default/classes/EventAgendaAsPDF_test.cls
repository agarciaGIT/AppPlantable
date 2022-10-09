@isTest
public class EventAgendaAsPDF_test {

    
    static Event__c event;
    
    static void testData(){ 

        EventMobiApiBatch.disableBatch = true;
        
        event = new Event__c(Name='Event');
        insert event;
        
        Event_Session_Track__c est = new Event_Session_Track__c(Name='Track 1');
        insert est;
        
        Event_Speaker__c es = new Event_Speaker__c(Name='Spreaker',Byline__c='Company X');
        insert es;
        
              
        Event_Sessions__c es1 = new Event_Sessions__c(Title__c = 'Session1', Start_Date_Time__c = DateTime.newInstance(2018, 1, 1, 8, 0, 0)
                                                      ,End_Date_Time__c = DateTime.newInstance(2018, 1, 1, 9, 0, 0), Session_Type__c=NULL, Status__c='Active',
                                                     Event__c=event.Id);        
        insert es1;
        
        Event_Speaker_Session_Track__c esst = new Event_Speaker_Session_Track__c(Event_Session__c=es1.Id, Event_Session_Track__c=est.Id,Event_Speaker__c=es.Id);
        insert esst;

    }
    
    @isTest
    public static void unitTest_1(){
        
        testData();
        test.startTest(); 
        
        ApexPages.currentPage().getParameters().put('id',event.id);
        
        EventAgendaAsPDF gp = new EventAgendaAsPDF();
        gp.fecthData(event.id);        
        
        test.stopTest();
    }

}