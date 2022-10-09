public class SwtichFeesForErptoFrm
{
   
   
   public Contact ct;
  public list<contact>lstContact;
  public id accid;
  Private Contact objContact;
    
    public SwtichFeesForErptoFrm(Apexpages.StandardController std)
    {
       
        ct = (Contact)std.getRecord();
               List < Contact > lstContact = [SELECT Id, Name,Accountid, FirstName, LastName, Email, HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, GARP_Member_ID__c, Membership_Type__c FROM Contact WHERE Id = :ct.id];

      accid = lstContact[0].accountid;
      objContact= lstContact[0];
        
    }

    public pageReference CreateOpp()
    {
       Opportunity objOpp = new Opportunity();
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');   
       

            List < Account > lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c from Account where Id = : accid];

            system.debug('* * * lstAcct ...'+ lstAcct);
            
            if (lstAcct != null && lstAcct.size() > 0) {
                objOpp.Name = 'Switch Fees';
                objOpp.accountId = accid;
                objOpp.stagename = 'New Lead';
                objOpp.CloseDate = System.today();
                objOpp.RecordTypeId = recordTypeID;
                objOpp.ChargentSFA__Billing_Email__c = objContact.Email;
                objOpp.ChargentSFA__Billing_First__c = objContact.FirstName;
                objOpp.ChargentSFA__Billing_Last__c = objContact.LastName;
                objOpp.ChargentSFA__Billing_Phone__c = objContact.HomePhone;
                objOpp.ChargentSFA__Billing_Company__c = lstAcct[0].Billing_Address_Company__c;
                objOpp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                objOpp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                objOpp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                objOpp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                objOpp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
                objOpp.Shipping_First_Name__c = objContact.FirstName;
                objOpp.Shipping_Last_Name__c = objContact.LastName;
                objOpp.Shipping_E_mail__c = objContact.Email;
                objOpp.Shipping_Company_Name__c = objContact.Company__c;
                objOpp.Shipping_Phone_No__c = objContact.HomePhone;
                objOpp.Shipping_Street__c = objContact.MailingStreet;
                objOpp.Shipping_City__c = objContact.MailingCity;
                objOpp.Shipping_State__c = objContact.MailingState;
                objOpp.Shipping_Postal_Code__c = objContact.MailingPostalCode;
                objOpp.Shipping_Country__c = objContact.MailingCountry;

            

              insert objOpp;
              system.debug('objOpp:'+objOpp);
        
         createOppLineItems(objOpp.id, 'FRMSW');
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Switch invoice has been created.let the customer know to pay from the portal.');
            ApexPages.addMessage(myMsg);
    
    }
    
    return null;
    }
    
    
     public  void createOppLineItems(Id oppId, String strProdCode)
    {
        
        String strNameByProdcutCode  = '';
        PriceBookEntry PricebookEntryId = [select unitprice,productcode,Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProdCode and isActive =: true and Product2.GL_Code__c='4001'];
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppId;
        oppLineItem.PricebookEntryId = PricebookEntryId.Id;
        oppLineItem.Quantity = 1;
       // oppLineItem.description = 'ERP to Frm Charges';
        oppLineItem.UnitPrice = 75.00;
       
        system.debug('* * * oppLineItem:'+ oppLineItem);
        
        insert oppLineItem;
    }
    
    
    
    
    
    }