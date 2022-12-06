@isTest
public class OrderTransactionLineItemsClass_test {

    public static Account account;
    public static Contact contact;
    
    
    public static Product2 CHLF;
    public static Product2 OSTA;
    public static Product2 FRMRET1;
    public static Product2 FRMRET2;
    public static Product2 ERPRET1;
    public static Product2 ERPRET2;
    
    public static PricebookEntry CHLFPBE;
    public static PricebookEntry OSTAPBE;
    public static PricebookEntry FRMRET1PBE;
    public static PricebookEntry FRMRET2PBE;
    public static PricebookEntry ERPRET1PBE;
    public static PricebookEntry ERPRET2PBE;
    
    public static Opportunity opportunity;
    
        public static void setup(){
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;  
        
        Id pricebookId = activePricebook.Id;
        
        //FEES      
        CHLF = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CHLF', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        OSTA = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'OSTA', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        FRMRET1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'FRMRET1', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        FRMRET2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'FRMRET2', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        ERPRET1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'ERPRET1', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        ERPRET2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'ERPRET2', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        
        INSERT CHLF;
        INSERT OSTA;
        INSERT FRMRET1;
        INSERT FRMRET2;
        INSERT ERPRET1;
        INSERT ERPRET2;
        
        CHLFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CHLF.Id, UnitPrice = 10000, IsActive = true);
        OSTAPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = OSTA.Id, UnitPrice = 10000, IsActive = true);
        FRMRET1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRMRET1.Id, UnitPrice = 10000, IsActive = true);
        FRMRET2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRMRET2.Id, UnitPrice = 10000, IsActive = true);
        ERPRET1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERPRET1.Id, UnitPrice = 10000, IsActive = true);
        ERPRET2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERPRET2.Id, UnitPrice = 10000, IsActive = true);
        
        INSERT CHLFPBE;
        INSERT OSTAPBE;
        INSERT FRMRET1PBE;
        INSERT FRMRET2PBE;
        INSERT ERPRET1PBE;
        INSERT ERPRET2PBE;
        
        
        account = new Account();
        account.Name = 'TEST CO';
        INSERT account;
        
        contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account.Id;
        INSERT contact;
        
        opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
                
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=1;
        oppli1.OpportunityId=opportunity.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = CHLFPBE.Id;
        insert oppli1;
            
            
                
        ChargentBase__Gateway__c gateway = new ChargentBase__Gateway__c(Name = 'paypal garp');
        insert gateway; 
                
                
       ChargentSFA__Transaction__c trans =  new ChargentSFA__Transaction__c(
            ChargentSFA__Gateway_Date__c = DateTime.now(), 
            ChargentSFA__Gateway_Response__c = 'RESULT=0&PNREF=AL3A6D51F72C&RESPMSG=Approved&AUTHCODE=538166&AVSADDR=X&AVSZIP=X&IAVS=X', 
            ChargentSFA__Payment_Method__c = 'Credit Card',
            ChargentSFA__Amount__c = 100, 
            ChargentSFA__Type__c = 'Charge', 
           ChargentSFA__Credit_Card_Type__c = 'Amex',
           ChargentSFA__Response_Status__c = 'Approved',
           ChargentSFA__Gateway__c = gateway.Id,
            ChargentSFA__Opportunity__c = opportunity.Id);
        INSERT trans;
            
        Order_Transaction_Item__c orderTransItems = new Order_Transaction_Item__c(
            Status__c = 'Approved',
            Paid_Date_Time__c = Date.today(),
            Opportunity__c = opportunity.Id, 
            Transaction__c = trans.Id);
        
    }
    
    @isTest
    public static void test1(){
        
        setup();
                
        Test.startTest();
        
        Set<String> oppIds = new Set<String>();
        oppIds.add(opportunity.Id);
        
        OrderTransactionLineItemsClass.onSetStatus(oppIds);
        OrderTransactionLineItemsClass.setOrders(oppIds);

        Test.stopTest();
        
    }
}