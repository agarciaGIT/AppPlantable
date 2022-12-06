global class batchUpdateOpportunityChargentvalues implements Database.Batchable<SObject>
{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,ChargentSFA__Billing_Email__c, ChargentSFA__Tokenization__c,ChargentSFA__Gateway__c,ChargentSFA__Payment_Method__c,ChargentSFA__Billing_Address__c,ChargentSFA__Billing_Address_Line_2__c,ChargentSFA__Billing_City__c,ChargentSFA__Billing_Company__c ,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_Fax__c,ChargentSFA__Billing_First__c,	ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c from Opportunity');
     }


    global void execute(Database.BatchableContext BC, List<Opportunity> scope){

        for(opportunity objOpp : scope)
        {
           objOpp.Billing_Email__c = objOpp.ChargentSFA__Billing_Email__c;
           objOpp.Token__c = objopp.ChargentSFA__Tokenization__c;
		   objOpp.Payment_Method_New__c = objOpp.ChargentSFA__Payment_Method__c ;
		   objOpp.Gateway__c = objOpp.ChargentSFA__Gateway__c;
		   objOpp.Billing_Address__c = objOpp.ChargentSFA__Billing_Address__c;
		   objOpp.Billing_Address_Line_2__c = objOpp.ChargentSFA__Billing_Address_Line_2__c;
           objOpp.Billing_City__c = objOpp.ChargentSFA__Billing_City__c;
		   objOpp.Billing_Company__c= objOpp.ChargentSFA__Billing_Company__c;
		   objOpp.Billing_Country__c= objOpp.ChargentSFA__Billing_Country__c;
           objOpp.Billing_Fax__c = objOpp.ChargentSFA__Billing_Fax__c;
		   objOpp.Billing_First_Name__c =objOpp.ChargentSFA__Billing_First__c;
		   objOpp.Billing_Last_Name__c= objOpp.ChargentSFA__Billing_Last__c;
		   objOpp.Billing_Phone__c = objOpp.ChargentSFA__Billing_Phone__c;
           objOpp.Billing_State__c= objOpp.ChargentSFA__Billing_State__c ;
           objOpp.Billing_Zip_Postal__c= objOpp.ChargentSFA__Billing_Zip__c;
        }
        update scope;

    }
    

    Global void finish(Database.BatchableContext BC){


    }

}