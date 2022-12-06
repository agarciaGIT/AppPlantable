@isTest
public class batchUpdateOpportunityChargevalues_Test {

 static Account acc;
 static Opportunity opp; 

  static testmethod void test(){
      Acc = new Account(Name = 'test');
        insert acc;
      
     opp = new Opportunity(Name = 'Test', stageName = 'Closed', closedate = system.today(), Billing_First_Name__c = 'Test First', Billing_Last_Name__c ='Test Last' ,Billing_Email__c='test123@gmail.com' , Billing_Phone__c='9988776644', Billing_Company__c='Company', Billing_Address__c='18 groover road', Billing_Address_Line_2__c='Address',Billing_City__c='city',Billing_State__c='New Jersey',Billing_Country__c='USA',
     Billing_Zip_Postal__c = '48197', Billing_Fax__c='7788');        
        insert opp;
        
       Test.startTest();
      batchUpdateOpportunityChargentvalues c = new batchUpdateOpportunityChargentvalues();
      Database.executeBatch(c);
      Test.stopTest();     
     
			      
    }
    

}