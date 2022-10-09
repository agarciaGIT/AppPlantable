@isTest
public class batchJobUpdateOpp_Test {

    Static String mode;  
    
    Static Account acc;
    Static Account acc1;
    Static Opportunity opp;
    Static Opportunity opp1;
    Static Opportunity opp2;
    Static Opportunity opp3;
    Static Opportunity opp4;
    Static Opportunity opp5;
    
    Static Exam_Attempt__c ea;
    Static Exam_Attempt__c ea1;
    Static Exam_Attempt__c ea2;
    Static Exam_Attempt__c ea3;
    Static Exam_Attempt__c ea4;
    Static Exam_Attempt__c ea5;
    
    Static Exam_Sites__c es;
    
     static void testData()
     {
        acc = new Account(name = 'Test Account1', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        insert acc;
    
        es = new Exam_Sites__c(name = 'Test ES1');
        insert es;
         
        opp = new Opportunity(name = 'Test Opp1', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', FRM_1_Registration_Fee__c = 350.00);
        insert opp;
         
        ea = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp.Id);
        insert ea;

        opp1 = new Opportunity(name = 'Test Opp2', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', FRM_2_Registration_Fee__c = 350.00);
        insert opp1;

        ea1 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp1.Id );
        insert ea1;

        opp2 = new Opportunity(name = 'Test Opp3', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', EA_Id__c = String.valueOf(ea.Id));
        insert opp2;

        ea2 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp2.Id );
        insert ea2;

        opp3 = new Opportunity(name = 'Test Opp4', AccountId = acc.Id, CloseDate = system.today(), StageName = 'Closed', Undefred_EA_Id__c = String.valueOf(ea.Id));
        insert opp3;

        ea3 = new Exam_Attempt__c(name = 'Test EA1', Exam_Site__c = es.Id, Opportunity__c =opp3.Id );
        insert ea3;

        acc1 = new Account(name = 'Test Account2', Calculated_Expire_Date__c = system.today().adddays(-900), Last_Contract_Exp_Calc__c = system.today().adddays(-900));
        insert acc1;
        
        opp4 = new Opportunity(name = 'Test Opp4', AccountId = acc1.Id, CloseDate = system.today().adddays(-845), StageName = 'Closed', Deferred_Exam_Registration__c  = String.valueOf(ea.Id));
        insert opp4;

        ea4 = new Exam_Attempt__c(name = 'Test EA4', Exam_Site__c = es.Id, Opportunity__c =opp4.Id, Defered__c ='Approved');
        insert ea4;
        
        opp5 = new Opportunity(name = 'Test Opp5', AccountId = acc1.Id, CloseDate = system.today(), StageName = 'Closed', ERP_Registration_Fee__c = 300.00);
        insert opp5;
        
        ea5 = new Exam_Attempt__c(name = 'Test EA5', Exam_Site__c = es.Id, Opportunity__c =opp5.Id );
        insert ea5;
        
     }
     
     static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchJobUpdateOpp b = new batchJobUpdateOpp('mode');
        database.executeBatch(b);
        batchJobUpdateOpp b1 = new batchJobUpdateOpp('2014');
        database.executeBatch(b1);
        batchJobUpdateOpp b2 = new batchJobUpdateOpp('2015');
        database.executeBatch(b2);
        batchJobUpdateOpp b3 = new batchJobUpdateOpp('2013');
        database.executeBatch(b3);
        batchJobUpdateOpp b4 = new batchJobUpdateOpp('2012');
        database.executeBatch(b4);
        batchJobUpdateOpp b5 = new batchJobUpdateOpp('2011');
        database.executeBatch(b5);
        batchJobUpdateOpp b6 = new batchJobUpdateOpp('2010');
        database.executeBatch(b6);
        batchJobUpdateOpp b7 = new batchJobUpdateOpp('defer');
        database.executeBatch(b7);
        test.stopTest();
    }

}