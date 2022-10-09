@isTest
public class OpptyfromAccountContactExtension_Test{
    public static testmethod void createOpportunityFromAccount(){
        Account acc = new Account(name='test account');
        insert acc;
        Contact con = new Contact(lastname='test contact', AccountId=acc.Id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert con;
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'MISC',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        OpptyfromAccountContactExtension opAcc = new OpptyfromAccountContactExtension(sc);
        opAcc.createOpportunity();
    }
    public static testmethod void createOpportunityFromContact(){
        Account acc = new Account(name='test account');
        insert acc;
        Contact con = new Contact(lastname='test contact', AccountId=acc.Id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert con;
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        OpptyfromAccountContactExtension opAcc = new OpptyfromAccountContactExtension(sc);
        opAcc.createOpportunity();
    }
    public static testmethod void testNegativeScenarios(){
        Account acc = new Account(name='test account');
        insert acc;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        OpptyfromAccountContactExtension opAcc = new OpptyfromAccountContactExtension(sc);
        Opportunity opp = new Opportunity();
        sc = new ApexPages.StandardController(opp);
        opAcc = new OpptyfromAccountContactExtension(sc);
    }
}