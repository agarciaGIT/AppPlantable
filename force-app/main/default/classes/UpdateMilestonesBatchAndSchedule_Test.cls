@isTest
public class UpdateMilestonesBatchAndSchedule_Test {

    Public static testMethod void MyUnitTest(){
        List<Milestone__c> milestoneList = new List<Milestone__c>();
        Milestone__c milestone1 = new Milestone__c();
        milestone1.Due_Date__c = system.today().addDays(10);
        milestone1.Status__c = 'Active';
        milestone1.Name = 'Test Milestone';
        milestoneList.add(milestone1);
        
        Milestone__c milestone2 = new Milestone__c();
        milestone2.Due_Date__c = system.today().addDays(20);
        milestone2.Status__c = 'Draft';
        milestone2.Name = 'Test Milestone 2';
        milestoneList.add(milestone2);
        
        Milestone__c milestone3 = new Milestone__c();
        milestone3.Due_Date__c = system.today();
        milestone3.Status__c = 'Completed';
        milestone3.Name = 'Test Milestone 3';
        milestoneList.add(milestone3);
        
        insert milestoneList;
        
        test.starttest();
        scheduleUpdateMilestonesBatch s1= new scheduleUpdateMilestonesBatch();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
    }
}