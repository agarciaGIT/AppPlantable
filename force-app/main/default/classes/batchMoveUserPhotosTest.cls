@isTest(SeeAllData=true)
public class batchMoveUserPhotosTest {

    static testMethod void unitTest_1(){
    
        //insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        test.startTest();
    
        batchMoveUserPhotos sv = new batchMoveUserPhotos (NULL);
        Database.executebatch(sv);
        
        schedulebatchMoveUserPhotos s1= new schedulebatchMoveUserPhotos();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);

        
        test.stopTest();
    }   
    
}