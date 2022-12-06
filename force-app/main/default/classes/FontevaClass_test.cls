@isTest
public class FontevaClass_test {
    
    static Account account;
    static Account account1;
    static Contact contact;

    static EventApi__Event__c event;
    static OrderApi__Sales_Order__c salesOrder;
    static EventApi__Attendee__c attendee;
    static Set<String> recIds = new Set<String>();
        
    static void setup(){
        Id BusRecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Business');
        Id BusContRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        
        account = new Account();
        account.Name = 'Fonteva GUEST Account';
        account.RecordTypeId = BusRecordTypeId;
        INSERT account;

        account1 = new Account();
        account1.Name = 'UNMATCHED-BUSINESS-ACCOUNT';
        account1.RecordTypeId = BusRecordTypeId;
        INSERT account1;
        
        contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account1.Id;
        contact.First_Name_as_it_Appears_on_ID__c = 'Test';
        contact.Middle_Name_as_it_Appears_on_ID__c = 'T';
        contact.Last_Name_as_it_Appears_on_ID__c = 'Test';
        contact.RecordTypeID = BusContRecordTypeId;
        INSERT contact;
                
        Default_Record_References__c drf = new Default_Record_References__c();
        drf.Name = 'UNMATCHED-BUSINESS-ACCOUNT';
        drf.sObjectType__c = 'Account';
        drf.Record_Reference_ID__c = account1.Id;
        INSERT drf;
        
        EventApi__Event_Category__c eventCat = new EventApi__Event_Category__c(
            Name = 'Event Cat'
        );
        INSERT eventCat;
        
        EventApi__Event__c event = new EventApi__Event__c(
            Name = 'Event',
            EventApi__Status__c = 'Active',
            EventApi__Event_Category__c = eventCat.Id,
            EventApi__Time_Zone__c = '(GMT-04:00) America/New_York',
            Affiliate_Membership_Required__c = True,
            EventApi__Ticket_Sales_Start_Date__c = Date.newInstance(2021, 11, 1),
            EventApi__Registration_Style__c = 'Simple',
            EventApi__Event_Key__c = '112'
        );
        INSERT event;
    
        salesOrder = new OrderApi__Sales_Order__c(
            OrderApi__Overall_Total__c = 100,
            OrderApi__Is_Voided__c = False,
            OrderApi__Is_Closed__c = True,
            OrderApi__Is_Posted__c = True,
            OrderApi__Amount_Paid__c = 0
        );
        INSERT salesOrder;
                
        OrderApi__Item__c item1 = new OrderApi__Item__c (
            Name = 'Event',
            Event_Product_Code__c = 'CRTM:4060'
        );
        INSERT item1;

        OrderApi__Item__c item2 = new OrderApi__Item__c (
            Name = 'Individual Membership',
            Is_Individual_Membership__c = True
        );
        INSERT item2;
        
        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c(
            Name = 'Item Class'
        );
        INSERT itemClass;
        
        OrderApi__Sales_Order_Line__c line1 = new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Item__c = item1.Id,
            OrderApi__Item_Class__c = itemClass.Id
        );
        INSERT line1;

        OrderApi__Sales_Order_Line__c line2 = new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Item__c = item2.Id,
            OrderApi__Item_Class__c = itemClass.Id
        );
        INSERT line2;
        
        OrderApi__Receipt__c rec1 = new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Contact__c = contact.Id,
            OrderApi__Account__c = account1.Id,
            OrderApi__Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Payment_Type__c = 'Charge', 
            OrderApi__Reference_Number__c = '1111',
            OrderApi__Total__c = 100,
            //OrderApi__Payment_Method_Description__c = 'VISA **1111',
            OrderApi__Posted_Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Type__c = 'Payment',
            OrderApi__Is_Posted__c = True
        );
        insert rec1;
        recIds.add(rec1.id);

        OrderApi__Receipt__c rec2 = new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Contact__c = contact.Id,
            OrderApi__Account__c = account.Id,
            OrderApi__Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Payment_Type__c = 'Charge', 
            OrderApi__Reference_Number__c = '1111',
            OrderApi__Total__c = 100,
            //OrderApi__Payment_Method_Description__c = 'VISA **1111',
            OrderApi__Posted_Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Type__c = 'Refund',
            OrderApi__Is_Posted__c = True
        );
        insert rec2;
        recIds.add(rec2.id);
        
        OrderApi__EPayment__c epay1 = new OrderApi__EPayment__c(
            OrderApi__Transaction_Token__c='123',
            OrderApi__Gateway_Token__c='ABC',
            OrderApi__Last_Four_Digits__c = '1111',
            OrderApi__Card_Type__c = 'VISA',            
            OrderApi__Refund_Receipt__c = rec1.Id,
            OrderApi__Succeeded__c = True,
            OrderApi__Payment_Method_Type__c = 'credit_card',
            OrderApi__Month__c = 1,
            OrderApi__Year__c = 2023
        );
        insert epay1;
        System.debug('epay1:' + epay1);
        
        rec1.OrderApi__EPayment__c = epay1.Id;
        update rec1;
        
        List<OrderApi__Receipt__c> lstRec = [select id, OrderApi__Payment_Method_Description__c from OrderApi__Receipt__c where id = :rec1.Id];
        System.debug('lstRec:' + lstRec[0].OrderApi__Payment_Method_Description__c);

        OrderApi__EPayment__c epay2 = new OrderApi__EPayment__c(
            OrderApi__Transaction_Token__c='123',
            OrderApi__Gateway_Token__c='ABC',
            OrderApi__Last_Four_Digits__c = '1111',
            OrderApi__Card_Type__c = 'VISA',            
            OrderApi__Refund_Receipt__c = rec2.Id,
            OrderApi__Succeeded__c = True,
            OrderApi__Payment_Method_Type__c = 'credit_card',
            OrderApi__Month__c = 1,
            OrderApi__Year__c = 2023
        );
        insert epay2;
        
        rec2.OrderApi__EPayment__c = epay2.Id;
        update rec2;

        
        attendee = new EventApi__Attendee__c(
            EventApi__Contact__c = contact.Id,
            EventApi__Account__c = account1.Id,
            EventApi__Status__c = 'Registered',
            EventApi__Sales_Order__c = salesOrder.Id,
            EventApi__Attendee_Event__c = event.Id
        );
        INSERT attendee;
        
        System.debug('attendee:' + attendee.Id);
        
        //account.Fonteva_Original_Attendee_ID__c = account.Id;
        //update account;
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;  
        
        Id pricebookId = activePricebook.Id;
        
        //FEES      
        Product2 AFF = new Product2(Company__c = 'GARP', Name = 'Affiliate', ProductCode = 'AFREE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 EVT = new Product2(Company__c = 'GARP', Name = 'Event', ProductCode = 'CRTM', GL_Code__c = '4060', Family = 'Hardware', IsActive = true);        
        Product2 MEMI = new Product2(Company__c = 'GARP', Name = 'Individual Membership', ProductCode = 'MEMI', GL_Code__c = '4040', Family = 'Hardware', IsActive = true);
        Product2 MEMC = new Product2(Company__c = 'GARP', Name = 'Certified Membership', ProductCode = 'MEMC', GL_Code__c = '4040', Family = 'Hardware', IsActive = true);
                
        INSERT AFF;
        INSERT EVT;
        INSERT MEMI;
        INSERT MEMC;
        
        PricebookEntry AFFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = AFF.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry EVTPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = EVT.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry MEMIPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMI.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry MEMCPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMC.Id, UnitPrice = 10000, IsActive = true);
        
        INSERT AFFPBE;
        INSERT EVTPBE;
        INSERT MEMIPBE;
        INSERT MEMCPBE;
     
        PagesApi__Field_Response__c fr = new PagesApi__Field_Response__c(EventApi__Attendee__c=attendee.id, PagesApi__Response__c='123');
        insert fr;
        
    }
    
    static void setup2(){
        Id BusRecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Business');
        Id BusContRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        
        account = new Account();
        account.Name = 'Fonteva GUEST Account';
        account.RecordTypeId = BusRecordTypeId;
        INSERT account;

        account1 = new Account();
        account1.Name = 'UNMATCHED-BUSINESS-ACCOUNT';
        account1.RecordTypeId = BusRecordTypeId;
        INSERT account1;
        
        contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account1.Id;
        contact.First_Name_as_it_Appears_on_ID__c = 'Test';
        contact.Middle_Name_as_it_Appears_on_ID__c = 'T';
        contact.Last_Name_as_it_Appears_on_ID__c = 'Test';
        contact.RecordTypeID = BusContRecordTypeId;
        INSERT contact;
                
        Default_Record_References__c drf = new Default_Record_References__c();
        drf.Name = 'UNMATCHED-BUSINESS-ACCOUNT';
        drf.sObjectType__c = 'Account';
        drf.Record_Reference_ID__c = account1.Id;
        INSERT drf;
        
        EventApi__Event_Category__c eventCat = new EventApi__Event_Category__c(
            Name = 'Event Cat'
        );
        INSERT eventCat;
        
        EventApi__Event__c event = new EventApi__Event__c(
            Name = 'Event',
            EventApi__Status__c = 'Active',
            EventApi__Event_Category__c = eventCat.Id,
            EventApi__Time_Zone__c = '(GMT-04:00) America/New_York',
            Affiliate_Membership_Required__c = True,
            EventApi__Ticket_Sales_Start_Date__c = Date.newInstance(2021, 11, 1),
            EventApi__Registration_Style__c = 'Simple',
            EventApi__Event_Key__c = '112'
        );
        INSERT event;
    
        salesOrder = new OrderApi__Sales_Order__c(
            OrderApi__Overall_Total__c = 100,
            OrderApi__Is_Voided__c = False,
            OrderApi__Is_Closed__c = True,
            OrderApi__Is_Posted__c = True,
            OrderApi__Amount_Paid__c = 0
        );
        INSERT salesOrder;
                
        OrderApi__Item__c item1 = new OrderApi__Item__c (
            Name = 'Event',
            Event_Product_Code__c = 'CRTM:4060'
        );
        INSERT item1;

        //OrderApi__Item__c item2 = new OrderApi__Item__c (
        //  Name = 'Individual Membership',
        //    Is_Individual_Membership__c = True
        //);
        //INSERT item2;
        
        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c(
            Name = 'Item Class'
        );
        INSERT itemClass;
        
        OrderApi__Sales_Order_Line__c line1 = new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Item__c = item1.Id,
            OrderApi__Item_Class__c = itemClass.Id
        );
        INSERT line1;

        //OrderApi__Sales_Order_Line__c line2 = new OrderApi__Sales_Order_Line__c(
        //    OrderApi__Sales_Order__c = salesOrder.Id,
        //    OrderApi__Item__c = item2.Id,
        //    OrderApi__Item_Class__c = itemClass.Id
        //);
        //INSERT line2;
        
        OrderApi__Receipt__c rec1 = new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Contact__c = contact.Id,
            OrderApi__Account__c = account1.Id,
            OrderApi__Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Payment_Type__c = 'Charge', 
            OrderApi__Reference_Number__c = '1111',
            OrderApi__Total__c = 100,
            //OrderApi__Payment_Method_Description__c = 'VISA **1111',
            OrderApi__Posted_Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Type__c = 'Payment',
            OrderApi__Is_Posted__c = True
        );
        insert rec1;
        recIds.add(rec1.id);

        OrderApi__Receipt__c rec2 = new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = salesOrder.Id,
            OrderApi__Contact__c = contact.Id,
            OrderApi__Account__c = account.Id,
            OrderApi__Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Payment_Type__c = 'Charge', 
            OrderApi__Reference_Number__c = '1111',
            OrderApi__Total__c = 100,
            //OrderApi__Payment_Method_Description__c = 'VISA **1111',
            OrderApi__Posted_Date__c = Date.newInstance(2021, 11, 1),
            OrderApi__Type__c = 'Refund',
            OrderApi__Is_Posted__c = True
        );
        insert rec2;
        recIds.add(rec2.id);
        
        OrderApi__EPayment__c epay1 = new OrderApi__EPayment__c(
            OrderApi__Transaction_Token__c='123',
            OrderApi__Gateway_Token__c='ABC',
            OrderApi__Last_Four_Digits__c = '1111',
            OrderApi__Card_Type__c = 'VISA',            
            OrderApi__Refund_Receipt__c = rec1.Id,
            OrderApi__Succeeded__c = True,
            OrderApi__Payment_Method_Type__c = 'credit_card',
            OrderApi__Month__c = 1,
            OrderApi__Year__c = 2023
        );
        insert epay1;
        System.debug('epay1:' + epay1);
        
        rec1.OrderApi__EPayment__c = epay1.Id;
        update rec1;
        
        List<OrderApi__Receipt__c> lstRec = [select id, OrderApi__Payment_Method_Description__c from OrderApi__Receipt__c where id = :rec1.Id];
        System.debug('lstRec:' + lstRec[0].OrderApi__Payment_Method_Description__c);

        OrderApi__EPayment__c epay2 = new OrderApi__EPayment__c(
            OrderApi__Transaction_Token__c='123',
            OrderApi__Gateway_Token__c='ABC',
            OrderApi__Last_Four_Digits__c = '1111',
            OrderApi__Card_Type__c = 'VISA',            
            OrderApi__Refund_Receipt__c = rec2.Id,
            OrderApi__Succeeded__c = True,
            OrderApi__Payment_Method_Type__c = 'credit_card',
            OrderApi__Month__c = 1,
            OrderApi__Year__c = 2023
        );
        insert epay2;
        
        rec2.OrderApi__EPayment__c = epay2.Id;
        update rec2;

        
        attendee = new EventApi__Attendee__c(
            EventApi__Contact__c = contact.Id,
            EventApi__Account__c = account1.Id,
            EventApi__Status__c = 'Registered',
            EventApi__Sales_Order__c = salesOrder.Id,
            EventApi__Attendee_Event__c = event.Id
        );
        INSERT attendee;
        
        System.debug('attendee:' + attendee.Id);
        
        //account.Fonteva_Original_Attendee_ID__c = account.Id;
        //update account;
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;  
        
        Id pricebookId = activePricebook.Id;
        
        //FEES      
        Product2 AFF = new Product2(Company__c = 'GARP', Name = 'Affiliate', ProductCode = 'AFREE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 EVT = new Product2(Company__c = 'GARP', Name = 'Event', ProductCode = 'CRTM', GL_Code__c = '4060', Family = 'Hardware', IsActive = true);        
        Product2 MEMI = new Product2(Company__c = 'GARP', Name = 'Individual Membership', ProductCode = 'MEMI', GL_Code__c = '4040', Family = 'Hardware', IsActive = true);
        Product2 MEMC = new Product2(Company__c = 'GARP', Name = 'Certified Membership', ProductCode = 'MEMC', GL_Code__c = '4040', Family = 'Hardware', IsActive = true);
                
        INSERT AFF;
        INSERT EVT;
        INSERT MEMI;
        INSERT MEMC;
        
        PricebookEntry AFFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = AFF.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry EVTPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = EVT.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry MEMIPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMI.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry MEMCPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMC.Id, UnitPrice = 10000, IsActive = true);
        
        INSERT AFFPBE;
        INSERT EVTPBE;
        INSERT MEMIPBE;
        INSERT MEMCPBE;
        
    }
    
    @isTest
    public static void test1(){        
        setup();
        
        Test.startTest();
        
        Set<String> registrationIds = new Set<String>();
        
        System.debug('attendee:' + attendee.Id);
        
        registrationIds.add(attendee.Id);
        
        FontevaClass.setRegistrations(registrationIds);
        ChargentSFATransactionTriggerHandler.OppListToUpdate.clear();
        FontevaClass.processRefund(recIds);
        
        FontevaClass.getFormResponses();
        
        Test.stopTest();

    }
    
    @isTest
    public static void test2(){        
        setup2();
        
        Test.startTest();
        
        Set<String> registrationIds = new Set<String>();
        
        System.debug('attendee:' + attendee.Id);
        
        registrationIds.add(attendee.Id);
        
        FontevaClass.setRegistrations(registrationIds);
        ChargentSFATransactionTriggerHandler.OppListToUpdate.clear();
        FontevaClass.processRefund(recIds);
        
        Test.stopTest();

    }
        
    /*
    @isTest
    public static void test2(){        
        setup();
        
        Test.startTest();
        
        Map<id,Contract> newlyCompletedContractMap = new Map<id,Contract>();
        Map<id,Contract> newlyActivatedContractMap = new Map<id,Contract>();
        Map<id,Contract> newlyLapsedContractMap = new Map<id,Contract>();
        Map<id,Contract> newlyCancelledContractMap = new Map<id,Contract>();

        
        //contact.Membership_type__C = 'Individual';
        //update contact;
            
        Opportunity newOpp = new Opportunity(
                        Name = 'OppName',
                        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated'),
                        AccountId = account.Id,
                        StageName = 'New Lead',
                        CloseDate = Date.today(),
                        Alternate_Method_of_Payment__c = 'CC',
                        Company__c = 'GARP',
                        //Membership_Emails__c = 'Affiliate',
                        Eligible_for_Membership_Extension__c = True,
                        ChargentSFA__Billing_First__c = 'Joe',
                        ChargentSFA__Billing_Last__c = 'Dude',
                        ChargentSFA__Billing_Email__c = 'joe.dude@garp.com'
                    );
        insert newOpp;
        
        Id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        Id ERPRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        Id FRMRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        
        Contract memCont = new Contract(Membership_Type__c='Individual',
                                                                AccountId=account.Id,
                                                                Opportunity__c=newOpp.Id,
                                                                CustomerSignedId=contact.Id,
                                                                RecordTypeId=MembershipTypeId,
                                                                StartDate=Date.today(),
                                                                ContractTerm=12
                                                                );
        insert memCont;
        
        Contract frmCont = new Contract(
            AccountId=account.Id,
            Opportunity__c=newOpp.Id,
            CustomerSignedId=contact.Id,
            RecordTypeId=FRMRecordTypeId,
            StartDate=Date.today(),
            ContractTerm=12
        );
        insert frmCont;
        
        newlyCompletedContractMap.put(memCont.id,memCont);
        newlyActivatedContractMap.put(memCont.id,memCont);
        newlyLapsedContractMap.put(memCont.id,memCont);
        newlyCancelledContractMap.put(memCont.id,memCont);

        newlyCompletedContractMap.put(frmCont.id,frmCont);
        newlyActivatedContractMap.put(frmCont.id,frmCont);
        newlyLapsedContractMap.put(frmCont.id,frmCont);
        newlyCancelledContractMap.put(frmCont.id,frmCont);

        
        FontevaClass.updateBadges(newlyCompletedContractMap,
                                  newlyActivatedContractMap,
                                  newlyLapsedContractMap,
                                  newlyCancelledContractMap);
              
        Test.stopTest();

    }
    */
    
    @isTest
    public static void test3(){        
        setup();
        
        Test.startTest();
            
        Opportunity newOpp = new Opportunity(
                        Name = 'OppName',
                        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated'),
                        AccountId = account1.Id,
                        StageName = 'New Lead',
                        CloseDate = Date.today(),
                        Alternate_Method_of_Payment__c = 'CC',
                        Company__c = 'GARP',
                        //Membership_Emails__c = 'Affiliate',
                        Eligible_for_Membership_Extension__c = True,
                        ChargentSFA__Billing_First__c = 'Joe',
                        ChargentSFA__Billing_Last__c = 'Dude',
                        ChargentSFA__Billing_Email__c = 'joe.dude@garp.com'
                    );
        insert newOpp;
        
        Id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        Id ERPRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        Id FRMRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        
        Contract memCont = new Contract(Membership_Type__c='Individual',
                                                                AccountId=account1.Id,
                                                                Opportunity__c=newOpp.Id,
                                                                CustomerSignedId=contact.Id,
                                                                RecordTypeId=MembershipTypeId,
                                                                StartDate=Date.today(),
                                                                ContractTerm=12
                                                                );
        insert memCont;
        
        Contract frmCont = new Contract(
            AccountId=account1.Id,
            Opportunity__c=newOpp.Id,
            CustomerSignedId=contact.Id,
            RecordTypeId=FRMRecordTypeId,
            StartDate=Date.today(),
            ContractTerm=12
        );
        insert frmCont;
        
        frmCont.Status = 'Completed';
        update frmCont;

        //FontevaClass.contractStatusChange(account1.Id);

        memCont.Status = 'Activated';
        update memCont;

        //FontevaClass.contractStatusChange(account1.Id);

        frmCont.Status = 'Expired';
        update frmCont;

        //FontevaClass.contractStatusChange(account1.Id);

        memCont.Membership_type__c='Affiliate';
        update memCont;

        Set<String> acts = new Set<String>();
        acts.add(account1.Id);
        FontevaClass.contractStatusChange(acts);

        Test.stopTest();

    }
    
    @isTest
    public static void test4(){
        Test.startTest();
        
        OrderApi__Sales_Order__c salesOrder = new OrderApi__Sales_Order__c(
            OrderApi__Overall_Total__c = 100,
            OrderApi__Amount_Paid__c = 0,
            OrderApi__Is_Voided__c = False,
            OrderApi__Is_Closed__c = True,
            OrderApi__Is_Posted__c = TRUE
        );
        INSERT salesOrder;
        
        EventApi__Attendee__c attendee = new EventApi__Attendee__c(
            EventApi__Contact__c = null,
            EventApi__Account__c = null,
            EventApi__Status__c = 'Registered',
            EventApi__Sales_Order__c = salesOrder.Id,
            EventApi__Attendee_Event__c = null
        );
        INSERT attendee;

        salesOrder.OrderApi__Amount_Paid__c = 100;
        update salesOrder;
        
        Test.stopTest();
    }
}