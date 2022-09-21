public class emailTracker {

    // Usage
    // Campaign is required in all cases
    // Campaign Account OR Account is required in all cases

    // Click:
    
    // Use Camp Acct ID:
    // ?campaignAcctid=a0M0x000001uw1j&meta1=Day1&meta2=banner&url=https%3A%2F%2Fwww.plantable.com
    
    // Use Camp Acct Name + Email:
    // ?campname=New%20ZJ%20Coach%2028%20Days&emailaddr=garcia.alberto.crespo@gmail.com&meta1=Day1&meta2=banner&url=https%3A%2F%2Fwww.plantable.com
    
    
    // Open:
    
    // <img src="http://euphebe.force.com/emailTracker?campname=New%20Launch%20InActive&acctid={!Contact.AccountID__c}&meta1=New%20Launch%20InActive" width="10" height="10" style="display:none" alt="" title="">
    
    // Use Camp Acct ID:
    // ?campaignAcctid=a0M0x000001uw1j
    
    // Use Camp Acct Name + Email:
    // ?campname=New%20ZJ%20Coach%2028%20Days&emailaddr=garcia.alberto.crespo@gmail.com
    
    
    // Unsubscribe:
    
    // ?campname=One%20Off%20Test&emailaddr=garcia.alberto.crespo@gmail.com&meta1=Unsubscribe&donotemail=true
    



    Public String logo {get; set;}
    
    public PageReference emailTracker() {
        
        String acctIdval = ApexPages.currentPage().getParameters().get('acctid');
        String campIdval = ApexPages.currentPage().getParameters().get('campaignid');
        
        // Allow no Account, use Email and Campaint Name to find Campaing Account
        String emailaddr = ApexPages.currentPage().getParameters().get('emailaddr');
        
        String campAcctIdval = ApexPages.currentPage().getParameters().get('campaignAcctid');
        String campNameVal = ApexPages.currentPage().getParameters().get('campname');
        String meta1 = ApexPages.currentPage().getParameters().get('meta1');
        String meta2 = ApexPages.currentPage().getParameters().get('meta2');
        String url = ApexPages.currentPage().getParameters().get('url');
        String donotemail = ApexPages.currentPage().getParameters().get('donotemail');
        String emailsub = ApexPages.currentPage().getParameters().get('emailsub');        
        
        system.debug('acctIdval: ' + acctIdval);
        system.debug('campIdval: ' + campIdval);
        system.debug('emailaddr: ' + emailaddr);
        system.debug('campAcctIdval: ' + campAcctIdval);
        system.debug('campNameVal: ' + campNameVal);
        system.debug('meta1: ' + meta1);
        system.debug('meta2: ' + meta2);
        system.debug('donotemail: ' + donotemail);
        system.debug('emailsub : ' + emailsub);        

        Campaign_Activity__c ca = new Campaign_Activity__c();
        ca.Euphebe_Campaign__c = null;
        ca.Campaign_Account__c = null;
        
        
        if(campAcctIdval != null && campAcctIdval.indexOf('!') == -1) {
            ca.Campaign_Account__c = campAcctIdval;
        }
        if(acctIdval != null) {
            ca.Account__c = acctIdval;            
        }
        if(campIdval != null) {
            ca.Euphebe_Campaign__c = campIdval;            
        }        
        if(meta1 != null) {
            ca.MetaData1__c = meta1;            
        }        
        if(meta2 != null) {
            ca.MetaData2__c = meta2;            
        }        
                
        
        // Campaign is required in all cases
        // Can get via Campaign Name (must pass email also see below) or Campaign Account ID
        
        
        // If Needed, If Send Campaign Name, Get Campaign ID
        if(ca.Euphebe_Campaign__c == NULL && campNameVal != null && campNameVal.indexOf('!') == -1) {
            List<Euphebe_Campaign__c> lstCamp = [select id from Euphebe_Campaign__c where name = :campNameVal];
            if(lstCamp != null && lstCamp.size() > 0) {
                ca.Euphebe_Campaign__c = lstCamp[0].id; 
            }
        }

        // If Needed, If Send Campaign Account ID, Get Campaign ID
        if(ca.Euphebe_Campaign__c == NULL && campAcctIdval != null && campAcctIdval.indexOf('!') == -1) {
            List<Campaign_Account__c> lstCampActt = [select Id, Account__c, Euphebe_Campaign__c from Campaign_Account__c where Id = :campAcctIdval];
            if(lstCampActt != null && lstCampActt.size() > 0) {
                ca.Euphebe_Campaign__c = lstCampActt[0].Euphebe_Campaign__c; 
                ca.Account__c = lstCampActt[0].Account__c;
            }                    
        }
        
        // Campaign Account OR Account is required in all cases
        // Can get via Campaign Account ID or Email address + Campaign Name


        // If Needed, If Send Email and have Campaign, Get Campaign Account
        if(campAcctIdval == NULL && emailaddr != NULL && emailaddr.indexOf('!') == -1 && ca.Euphebe_Campaign__c != NULL) {
            List<Campaign_Account__c> lstCampActt = [select Id, Account__c from Campaign_Account__c where Euphebe_Campaign__c = :ca.Euphebe_Campaign__c and Recipient_Email_Address__c = :emailaddr];
            if(lstCampActt != null && lstCampActt.size() > 0) {
                ca.Campaign_Account__c = lstCampActt[0].Id;
                ca.Account__c = lstCampActt[0].Account__c;
            }
        }

        // If Needed, If Send Email get Account
        if(ca.Account__c == NULL && emailaddr != NULL && emailaddr.indexOf('!') == -1) {
            List<Account> lstAcct = [select Id, Name from Account where Email__c = :emailaddr];
            if(lstAcct != null && lstAcct .size() > 0) {
                ca.Account__c = lstAcct[0].Id;
            }                            
        }


        if(url != NULL) {
            ca.Type__c = 'Click Email';
            ca.Name = 'Email Click';
            
            system.debug('insert ca: ' + ca);
            //if(ca.Campaign_Account__c!=NULL) {                
                insert ca;
            //}
            PageReference retURL = new PageReference(url);
            retURL.setRedirect(true);
            return retURL;
            
        } if(donotemail != NULL) {
            Boolean setval = NULL;
            if(donotemail=='true') {
                ca.Type__c = 'Unsubscribe';
                ca.Name = 'Unsubscribe';
                ca.MetaData1__c = emailsub;
                setval=true;
            } else {
                ca.Type__c = 'Subscribe';
                ca.Name = 'Subscribe';       
                ca.MetaData1__c = emailsub;
                setval=false;
            }
            if(emailaddr != null) {
                List<Contact> lstCont = [select Id, HasOptedOutOfEmail, Email_Opt_Out_Coaching__c from Contact where email = :emailaddr];
                if(lstCont != null && lstCont.size() > 0) {
                    if(emailsub == NULL || emailsub.length() == 0) {
                        lstCont[0].HasOptedOutOfEmail = setval;
                    } else {
                        lstCont[0].Email_Opt_Out_Coaching__c = setval;                    
                    }
                    update lstCont;
                }
            }
            insert ca;
            PageReference retURL = new PageReference('/apex/Unsubscribe?donotemail=' + donotemail);
            retURL.setRedirect(true);
            return retURL;
            
        }else {
            ca.Type__c = 'Open Email';
            ca.Name = 'Email Open';
            insert ca;
        }
        return null;
    }

}