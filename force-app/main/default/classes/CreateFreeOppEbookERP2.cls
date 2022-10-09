global class CreateFreeOppEbookERP2 implements Database.Batchable<sObject>,Database.StateFul,Database.AllowsCallouts{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //run this batch for only one record at once.
         List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
        String StrDefered = 'Approved';       
        String oppstatus = 'closed';
        date datExam = lstDate[0].Date__c;
          Set<String> sitecode =new Set<String>{'814','838'};
          Set<String> id =new Set<String>{'a1a1W000008ijQ5'};
        Set<String> strSection = new Set<String>{'ERP Exam Part II'};
            
            string strQuery = 'select id,Section__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c where  Defered__c =: StrDefered  and Opportunity_StageName__c =:oppstatus and cancelled__c !=true and Section__c in: strSection and Exam_Date__c =:datExam and Site_Code__c in:sitecode';
            
        if(test.isRunningTest()){
            strQuery = 'select id,Section__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c where  Defered__c =: StrDefered  and Opportunity_StageName__c =:oppstatus and cancelled__c !=true';
        }
        return Database.getQueryLocator(strQuery); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        Set<Id> Conids = new Set<Id>();
        
        for(Exam_Attempt__c EA : scope)
        {
            Conids.add(EA.Member__c);
            
            
        }
        
        Contact objContact = [select id,name,Email,account.BillingStreet,Account.BillingState,Account.BillingCountry,Company_Clean_Name__c,Account.BillingCity, FirstName, HomePhone, LastName, Mailing_Address_Company__c, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode,accountId from Contact where id =: Conids];
        
        Opportunity Newopp = new opportunity();
        if(objContact != null )
        {
            List<Opportunity> lstNewOpps = new List<Opportunity>();
            
            Map<Id,Opportunity> mapOppByAccount = new Map<Id,Opportunity>();
            Newopp.Name = 'Free Ebook Extension';
            Newopp.accountid = objContact.accountid;
            Newopp.StageName = 'New Lead';
            Newopp.CloseDate=system.today();
            Newopp.ChargentSFA__Billing_Address__c = objContact.account.BillingStreet;
            Newopp.ChargentSFA__Billing_City__c    = objContact.account.BillingCity;
            Newopp.ChargentSFA__Billing_Company__c = objContact.Company_Clean_Name__c;
            Newopp.ChargentSFA__Billing_Country__c = objContact.account.BillingCountry;
            Newopp.ChargentSFA__Billing_Email__c   = objContact.Email;
            Newopp.ChargentSFA__Billing_Last__c    = objContact.LastName;
            Newopp.ChargentSFA__Billing_First__c   = objContact.FirstName;
            Newopp.ChargentSFA__Billing_Phone__c   = objContact.HomePhone;
            Newopp.ChargentSFA__Billing_Postcode__c= objContact.MailingPostalCode;
            Newopp.ChargentSFA__Billing_State__c   = objContact.account.BillingState;
            
            
            Newopp.Shipping_Last_Name__c           = objContact.LastName;
            Newopp.Shipping_First_Name__c          = objContact.FirstName;
            Newopp.Shipping_Street__c              = objContact.account.BillingStreet;
            Newopp.Shipping_City__c                = objContact.account.BillingCity;
            Newopp.Shipping_Country__c             = objContact.account.BillingCountry;
            Newopp.Shipping_E_mail__c              = objContact.Email;
            Newopp.Shipping_Phone_No__c            = objContact.HomePhone;
            Newopp.Shipping_Postal_Code__c         = objContact.MailingPostalCode;
            Newopp.Shipping_State__c               = objContact.account.BillingState;
            
            Newopp.Give_Ebook_for_Free__c = true;
            Newopp.E_book_Type__c ='ERP Part II';
            lstNewOpps.add(Newopp);

             insert lstNewOpps;
            if(lstNewOpps.size() > 0){
               
                PriceBookEntry PricebookEntryId = [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = 'ENC2X' and product2.Gl_Code__c = '4030' and isActive = true];
                List<OpportunityLineItem> lstOppLines = new List<OpportunityLineItem>();
                for(Opportunity opp : lstNewOpps)
                {
                    mapOppByAccount.put(opp.accountId,opp);
                    OpportunityLineItem oppLine = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId  = PricebookEntryId.Id,Quantity =1,TotalPrice =0);
                    lstOppLines.add(oppLine);
                }
                
                if(lstOppLines.size() > 0)
                    insert lstOppLines;
                
                ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
                trans.ChargentSFA__Opportunity__c = Newopp.Id;
                trans.ChargentSFA__Amount__c = 0.00;
                trans.ChargentSFA__Response_Message__c = 'Approved';
                trans.ChargentSFA__Response_Status__c = 'Approved';
                trans.ChargentSFA__Type__c = 'Charge';
                trans.ChargentSFA__Gateway_Date__c =system.now();
                 insert trans;
            }
     
        }
    }
   
   
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}