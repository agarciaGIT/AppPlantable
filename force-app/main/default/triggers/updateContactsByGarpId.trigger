trigger updateContactsByGarpId on certificate_shipping__c (before insert,before update) {
    Set<String> setGarpIds = new Set<String>();
    for(certificate_shipping__c obj : trigger.new)
    {
         if(obj.Do_not_fire__c) continue;
                    
        if(obj.Garp_id__c != null)
            setGarpIds.add(obj.Garp_id__c);
    }
    if(!setGarpIds.isEmpty())
    {
        Map<String,Contact> mapGarpContactIds = new Map<String,Contact>();
        for(Contact ct : [select id,GARP_Member_ID__c,MailingCountry from Contact where GARP_Member_ID__c in: setGarpIds])
        {
            mapGarpContactIds.put(ct.GARP_Member_ID__c,ct);
        }
        
        for(certificate_shipping__c obj : trigger.new)
        {
            Id contactID = mapGarpContactIds == null || mapGarpContactIds.size() <= 0  ? null : mapGarpContactIds.get(obj.Garp_id__c).id;
            if(contactID != null)
            {
                CountryCodes__c countryCodes = CountryCodes__c.getValues(mapGarpContactIds.get(obj.Garp_id__c).MailingCountry);
                obj.Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';
                 
                      if (obj.Shipping_Address1__c != null) {
                      String[] strAddress = obj.Shipping_Address1__c.split('\n');
                     
                        if (strAddress != null) {
                            
                                obj.Shipping_Adress1__c = strAddress != null && strAddress.size() >=1 ? strAddress[0] : '';
                                 obj.Shipping_Address2__c = strAddress != null && strAddress.size() >=2 ? strAddress[1] : '';
                                obj.Shipping_Address3__c = strAddress != null && strAddress.size() >=3 ? strAddress[2] : '';
                          }}}
                
                         else
                          obj.addError('No valid Garp ID found on contact.');
                
             } }}