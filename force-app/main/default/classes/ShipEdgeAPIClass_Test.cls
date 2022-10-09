@isTest
private class ShipEdgeAPIClass_Test { 
    
    
    @isTest static void getShipEdgeAddOrder(){
       
        Account acc=new Account(name='Test');
        insert acc;
       
        
		Opportunity Opp=new Opportunity(Name = 'Test',stageName = 'New Lead', CloseDate = Date.today(),accountid=acc.id,Display_Invoice_Number__c = '7896',Customs_Cost__c = '1200',
                                               ChargentSFA__Payment_Method__c = 'Check',Products_SKU__c = '111-01950',Shipping_E_mail__c = 'test@testmail.com',Shipping_Phone_No__c = '5345353453',
                                               Shipping_First_Name__c = 'test', Shipping_Last_Name__c = 'last name test', Shipping_Company_Name__c = 'test1',
                                               Shipping_Address1__c = 'address 1',Shipping_Address2__c = 'address 2',Shipping_City__c = 'test city',Shipping_State__c = 'test state',Shipping_Postal_Code__c = '4234342',
                                               Shipping_Country__c = 'test coun',ChargentSFA__Billing_First__c = 'test first',ChargentSFA__Billing_Last__c = 'test last',ChargentSFA__Billing_Company__c = 'comp test',ChargentSFA__Billing_Address__c = 'add1',
            ChargentSFA__Billing_Address_Line_2__c ='add line1',ChargentSFA__Billing_City__c = 'test bill city',ChargentSFA__Billing_State__c = 'Alaska',ChargentSFA__Billing_Zip__c = '2321',ChargentSFA__Billing_Country__c = 'test countr');
        insert Opp;
        Set<id> SetOpp=new Set<id>{Opp.id};
        
        Test.startTest();
        
        ShipEdgeAPIClass.getShipEdgeAddOrder(SetOpp);
        ShipEdgeAPIClass.getShipEdgeGetOrder((String)Opp.Id);
        ShipEdgeAPIClass.cancelOrder((String)Opp.Id);
        ShipEdgeAPIClass.getShipEdgePing();
        
        Test.stopTest();
    }
}