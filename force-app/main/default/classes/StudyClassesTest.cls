@isTest 
public class StudyClassesTest {

    Static API_Request__c ar;
    Static Account account;
    Static Shipment__c ship;
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    Static Opportunity opp2;
    static Meal__c m;
    Static Meal_Line_Item__c mli;
    
    public static void setup(){
                
        acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C',Study_Access_Key__c='123');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;

        Date shipDate = Date.newInstance(2020, 3, 2);
        
        opp1 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2016, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = True, Ship_Date__c=shipDate, How_did_you_hear_Long__c = 'aaa');
        insert opp1;

        opp2 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2017, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = False, Ship_Date__c=shipDate, How_did_you_hear_Long__c = 'aaa');
        insert opp2;
        
        Product2 prod1 = new Product2(Name='Prod1', ProductCode='EALC');
        insert prod1;
        Product2 prod2 = new Product2(Name='Prod2', ProductCode='EHF');
        insert prod2;
        Product2 prod3 = new Product2(Name='Prod3', ProductCode='E28');
        insert prod3;
        Product2 prod4 = new Product2(Name='Prod4', ProductCode='E28 Finish Me');
        insert prod4;
        Product2 prod5 = new Product2(Name='Prod5', ProductCode='E28TM');
        insert prod5;
        Product2 prod6 = new Product2(Name='Prod6', ProductCode='ETWS');
        insert prod6;
        Product2 prod7 = new Product2(Name='Prod6', ProductCode='ETWB');
        insert prod7;

        Product2 prod8 = new Product2(Name='Prod6', ProductCode='E28ZJ', Shopify_Product_Id__c = '2610863767616', IsActive = True);
        insert prod8;

        Product2 prod9 = new Product2(Name='Prod6', ProductCode='QSZJ', Shopify_Product_Id__c = '2610861178944', IsActive = True);
        insert prod9;
        
        String standardPBId =  Test.getStandardPricebookId();        
        
        PricebookEntry pe1 = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = prod1.Id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        insert pe1;

        OpportunityLineItem oppLine1 = new OpportunityLineItem(Product2Id=prod1.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe1.Id);            
        insert oppLine1;
        
        
        PricebookEntry pe2 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod2.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe2;

        OpportunityLineItem oppLine2 = new OpportunityLineItem(Product2Id=prod2.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe2.Id);
        insert oppLine2;
        
        PricebookEntry pe3 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod3.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe3;
        
        OpportunityLineItem oppLine3 = new OpportunityLineItem(Product2Id=prod3.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe3.Id);
        insert oppLine3;

        PricebookEntry pe4 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod4.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe4;

        OpportunityLineItem oppLine4 = new OpportunityLineItem(Product2Id=prod4.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe4.Id);
        insert oppLine4;

        PricebookEntry pe5 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod5.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe5;
        
        OpportunityLineItem oppLine5 = new OpportunityLineItem(Product2Id=prod5.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe5.Id);
        insert oppLine5;
        
        PricebookEntry pe6 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod6.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe6;

        OpportunityLineItem oppLine6 = new OpportunityLineItem(Product2Id=prod6.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe6.Id);
        insert oppLine6;


        PricebookEntry pe7 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod7.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe7;

        OpportunityLineItem oppLine7 = new OpportunityLineItem(Product2Id=prod7.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe7.Id);
        insert oppLine7;


        PricebookEntry pe8 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod8.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe8;

        OpportunityLineItem oppLine8 = new OpportunityLineItem(Product2Id=prod8.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe8.Id);
        insert oppLine8;

		opp1.Main_Product__c = prod8.id;
        update opp1;
        
        
        PricebookEntry pe9 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod9.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe9;

        OpportunityLineItem oppLine9 = new OpportunityLineItem(Product2Id=prod8.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe9.Id);
        insert oppLine9;


        
        ar = new API_Request__c(Batch__c = true, Created_At__c=DateTime.now());
        insert ar;
        
        ship = new Shipment__c(Name='Ship', Delivery_Date__c=Date.newInstance(2016, 1, 1), Scheduled_Date__c = shipDate, Type__c = 'OnFleet', Status__c = 'Pending', Opportunity__c=opp1.Id);
        insert ship;
                
        m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616');
        insert m;
        
        Menu_Program__c mp = new Menu_Program__c(Name='MP', Number_of_Cycles__c=1, Start_Date__c=Date.newInstance(2016, 1, 1), Order_Cut_Off_Day__c='Friday', Order_Cut_Off_Time__c='06:00', Status__c = 'Active');
        insert mp;
                    
        Menu__c mu = new Menu__c(Name='Menu', Cycle__c=1, Menu_Program__c = mp.Id, Status__c = 'Active');
        insert mu;
                    
        Menu_Entry__c me = new Menu_Entry__c(Name='ME', Meal__c = m.Id, Menu__c = mu.Id);
        insert me;
     
        Case c = new Case(Status='Closed', Last_Email_Date_Sent__c=DateTime.newInstance(2019, 1, 1, 1, 0, 0), Last_Email_Date_Received__c=DateTime.now(), Reply__c=False);
        insert c;
        
        mli = new Meal_Line_Item__c(Name='MLI', EOrder__c=opp1.Id);
        insert mli;
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();   
        
        studyMealsByOrderDownload smbo = new studyMealsByOrderDownload();
        studyShipmentsDownload ssd = new studyShipmentsDownload();
        
        studyShipmentDownloadPicker ssp = new studyShipmentDownloadPicker();
        ssp.x_date = Date.newInstance(2020, 3, 2);
        ssp.setDateString();
        ssp.shipmentDownload();
        ssp.mealsDownload();
        
        studyAccountUpload sau = new studyAccountUpload();
        sau.ReadFile();
        sau.tryagain();
        
        studyShipmentUpload ssu = new studyShipmentUpload();
        ssu.ReadFile();
        ssu.tryagain();
        

        studyUploadHealth shu = new studyUploadHealth();
        shu.ReadFile();
        shu.tryagain();

        
        Test.stopTest();        
    }
    
}