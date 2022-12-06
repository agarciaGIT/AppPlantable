public class formDataTriggerHelper_New {
    
    public static void beforeInsertUpdate(form_data__c formData, Map<String,String> contactIdMap, Map<String,String> leadIdMap){
        
        system.debug('beforeInsertUpdate: '+formData);
        
        try{
            form_data__c fd = formData;
            Integer randomNumber = Integer.valueof((Math.random() * 100000));
            system.debug('fd: '+fd);
            
            if(fd.Bulk_Load__c == false && fd.Status__c =='Completed'){
                String emailKey = fd.Email__c.toLowercase();  
                //  fd.Member_Contact__c = false; 
                fd.Upload_Lead_Key__c = randomNumber+' '+emailKey; // unique key for new lead insert
                if(emailKey != null && emailKey !=''){ 
                    
                    if(contactIdMap.containsKey(emailKey)){
                        if(fd.Lead_Status__c == null){
                            fd.Lead_Status__c = 'Is Contact';
                        }
                        fd.Contact__c = contactIdMap.get(emailKey);  
                        
                        system.debug('fd Is Contact: ' + fd.Contact__c + ':' + fd.Lead_Status__c);
                        
                    }else if(leadIdMap.containsKey(emailKey)){
                        if(fd.Lead_Status__c == null){
                            fd.Lead_Status__c = 'Is Lead';
                        }
                        fd.Lead__c = leadIdMap.get(emailKey); 
                        
                        system.debug('fd Is Lead: ' + fd.lead__c + ':' + fd.Lead_Status__c);
                        
                    }
                }
            }
            
        }catch(Exception e){
            system.debug(e.getMessage());
            system.debug(e.getLinenumber());
        }       
        
    }
    
    
    public static Lead beforeinsertUpdateLead(form_data__c formData){
        form_data__c fd = formData;
        Lead l = new lead();
        String emailKey = fd.Email__c.toLowercase();
        if(fd.Lead_Status__c == null){
            fd.Lead_Status__c = 'New Lead';
        }
        
        if(fd.First_Name__c != null){
            l.FirstName = fd.First_Name__c;
        }else{
            l.FirstName = 'Unknown';
        }
        
        if(fd.Last_Name__c != null){
            l.LastName = fd.Last_Name__c;
        }else{
            l.LastName = 'Unknown';
        } 
        
        if(fd.Company__c != null){
            l.company = fd.Company__c;
        }
        else{
            l.company = 'Unknown';
        } 
        if(fd.Title__c != null){
            l.Title = fd.Title__c;
        }
        else{
            l.Title = 'Unknown';
        } 
        if(fd.Mobile_Phone__c != null){
            l.Mobile_Phone__c = fd.Mobile_Phone__c; 
        }
        
        if(fd.Industry__c != null){
            l.Industry = fd.Industry__c;
        }
        
        if(fd.Mailing_Country__c != null){
            l.Country = fd.Mailing_Country__c;
        }
        if(fd.Mailing_Zip_Postal_Code__c != null){
            l.PostalCode = fd.Mailing_Zip_Postal_Code__c;
        }
        if(fd.Mailing_State_Province__c != null){
            l.State = fd.Mailing_State_Province__c;
        }
        if(fd.Mailing_Street__c != null){
            l.Street = fd.Mailing_Street__c;
        }
        if(fd.Mailing_City__c != null){
            l.City = fd.Mailing_City__c;
        }
        if(fd.Phone__c != null){
            l.Phone = fd.Phone__c;
        }
        
        l.Original_Source__c = fd.Form_Name__c;
        l.Email = emailKey; 
        l.Email_Subscription_Change_Source__c = fd.Form_Name__c;
        
        system.debug('fd New Lead: ' + fd.lead__c + ':' + fd.Lead_Status__c + '<:>' + l);
        
        return l;
        
    }
    
    
    public static List<CampaignMember> afterInsertUpdateCampaignMember(form_data__c formData, Map<Id,Campaign> lstConvCamp,MAP<String,CampaignMember> mapCampMem,MAP<Id,String> mapLeadCampByForm,Map<Id, Form__c> formsByIdMap){
        form_data__c fd = formData;
        CampaignMember cm = new CampaignMember();
        List<CampaignMember> campMemUpdate = new List<CampaignMember>();
        
        system.debug('fd: '+fd);
        
        // Update member in all campaigns with conversion form submitted
        for(Campaign c :lstConvCamp.values()) {
            
            system.debug('lstConvCamp: '+c); 
            
            CampaignMember fndConvCampMem = mapCampMem.get(fd.Email__c.toLowerCase() + '~' + c.Id);
            system.debug('fndConvCampMem: '+fndConvCampMem); 
            if(fndConvCampMem != NULL) {
                
                fndConvCampMem.Status = 'Converted';
                fndConvCampMem.Conversion_Form__c = fd.Form_Name__c;
                system.debug('update fndConvCampMem: '+fndConvCampMem);
                
                campMemUpdate.add(fndConvCampMem);
                system.debug('Conv campMemUpdate: '+campMemUpdate);
                
            }
            
        }
        
        String fndLeadCampId = mapLeadCampByForm.get(fd.Form__c);
        system.debug('fndLeadCampId: '+fndLeadCampId);
        
        CampaignMember fndLeadCampMem;
        if(fndLeadCampId != NULL) {
            fndLeadCampMem = mapCampMem.get(fd.Email__c.toLowerCase() + '~' + fndLeadCampId);
        }
        system.debug('fndLeadCampMem: '+fndLeadCampMem);                
        
        if(fndLeadCampMem != NULL) {
            // Update Lead Camp Member
            if(fndLeadCampMem.Status != 'Converted') {
                fndLeadCampMem.Status = 'Filled Out Form';                    
            }
            if(fndLeadCampMem.Original_Form__c == NULL) {
                fndLeadCampMem.Original_Form__c = fd.Form_Name__c;                    
            }
            system.debug('update fndLeadCampMem: '+fndLeadCampMem);
            
            campMemUpdate.add(fndLeadCampMem);
            system.debug('Lead campMemUpdate: '+campMemUpdate);
            
        } else {
            // Add new Camp Member
            CampaignMember newCM = new CampaignMember();
            system.debug('Lead Add new');
            
            // Create Campaign Member from Lead
            if(fd.Lead__c != null && fd.Form_Name__c!=null){
                
                Form__c fm = formsByIdMap.get(fd.Form__c);
                system.debug('Lead fm: '+fm);
                newCM.CampaignId = fm.Campaign__c;
                newCM.Status = 'Filled Out Form';
                
                system.debug('Lead newCM: '+newCM);
                
                if(newCM.CampaignId != NULL) {
                    newCM.LeadId = fd.Lead__C;
                    newCM.Lead_Status__c = fd.Lead_Status__c; 
                    newCm.Original_Form__c = fd.Form_Name__c;
                    campMemUpdate.add(newCM);
                    system.debug('Lead newCM add: '+newCM);
                    //subscriptionChangeLeadMap.put(fd.Lead__c,fd.Form_Name__c);    - Confirm from Spuran
                }
                
            } else if(fd.Contact__c != null && fd.Form_Name__c != null){
                
                Form__c fm = formsByIdMap.get(fd.Form__c);
                system.debug('Contact Lead fm: '+fm);
                
                newCM.CampaignId = fm.Campaign__c;
                newCM.Status = 'Filled Out Form';
                if(newCM.CampaignId != NULL) {
                    newCM.ContactId = fd.Contact__c;
                    newCM.Lead_Status__c = fd.Lead_Status__c; 
                    newCm.Original_Form__c = fd.Form_Name__c;
                    campMemUpdate.add(newCM);
                    system.debug('Contact newCM: '+newCM);
                    //subscriptionChangeConMap.put(fd.Contact__c,fd.Form_Name__c);    - Confirm from Spuran
                }
            }
        }
        return campMemUpdate;
    }
    
    
    public static List<Contact> afterInsertUpdateContact(form_data__c formData,Map<Id,String> statusMap,Map<string,SubscriptionManagement__c> settingMap){
        
        Map<Id, List<String>> contactToUpdateMap = new Map<Id, List<String>>();
        List<string> statuslist = new List<string> ();
        List<Contact> conList = new List<Contact>();
        form_data__c pro = formData;
        if(pro.Contact__c != null){ 
            Contact c = new Contact();
            c.Id = pro.Contact__c; 
            if(pro.Subscription__c == 'Do Not Email'){
                c.HasOptedOutOfEmail = true;
            } 
            
            if(pro.Overwrite_Contact__c){
                if(pro.First_Name__c != null){
                    c.Business_Contact_First_Name__c = pro.First_Name__c;
                }
                if(pro.Last_Name__c != null){
                    c.Business_Contact_Last_Name__c = pro.Last_Name__c;
                }
                if(pro.Email__c != null){
                    c.Business_Contact_Email__c = pro.Email__c;
                }
                if(pro.Mailing_Street__c != null){
                    c.Business_Contact_Address_1__c = pro.Mailing_Street__c;
                }
                if(pro.Mailing_City__c != null){
                    c.Business_Contact_City__c = pro.Mailing_City__c;
                }
                if(pro.Mailing_State_Province__c != null){
                    c.Business_Contact_State__c = pro.Mailing_State_Province__c;
                }
                if(pro.Mailing_Zip_Postal_Code__c != null){
                    c.Business_Contact_Zip_Code__c = pro.Mailing_Zip_Postal_Code__c;
                }
                if(pro.Mailing_Country__c != null){
                    c.Business_Contact_Country__c = pro.Mailing_Country__c;
                }
                if(pro.Title__c != null){
                    c.Business_Contact_Title__c = pro.Title__c;
                }
                if(pro.Company__c != null){
                    c.Business_Contact_Company__c = pro.Company__c;
                }
                if(pro.Phone__c != null){
                    c.Business_Contact_Phone__c = pro.Phone__c;
                } 
                if(pro.Mobile_Phone__c != null){
                    c.MobilePhone = pro.Mobile_Phone__c;
                } 
                if(pro.Form_Name__c != null){
                    c.Email_Subscription_Change_Source__c = pro.Form_Name__c; 
                }         
            } 
            conList.add(c);  
        }
        
        if((statusMap.containsKey(pro.form__c))|| (statusMap.containsKey(pro.id))){
            // splitting the status field
            if(statusMap.containsKey(pro.form__c)){
                statuslist = statusMap.get(pro.form__c).split(';');
                system.debug('statuslist123==:'+statuslist);
            }
            if(statusMap.containsKey(pro.id)){
                statuslist = statusMap.get(pro.id).split(';');
                system.debug('statuslist==:'+statuslist);
            }
            
            for(String s:statuslist){   
                // Comparing custom setting record name with status value
                if(settingMap.containsKey(s) && (pro.Subscription__c != 'No'&& pro.Subscription__c != 'Do Not Email')){   
                    if(settingMap.get(s).Contact_Field_Mapping__c != null && pro.Contact__c !=null ){   
                        if(pro.Subscription__c =='Yes' || (pro.Subscription__c =='Non-Member' && pro.Existing_Business_Contact__c )){
                            if(contactToUpdateMap.containsKey(pro.Contact__c)){
                                List<String> conl = contactToUpdateMap.get(pro.Contact__c); 
                                conl.addAll(settingMap.get(s).Contact_Field_Mapping__c.split(','));
                                contactToUpdateMap.put(pro.Contact__c,conl);  
                            }else{
                                List<String> conFields=settingMap.get(s).Contact_Field_Mapping__c.split(',');  
                                contactToUpdateMap.put(pro.Contact__c,conFields);    
                            }  
                            
                        }
                    } 
                } 
            } 
        }
        
        List<SObject> contactToUpdateList = new List<SObject>();
        List<Contact> contactList = new List<Contact>();
        Map<Id,String> subscriptionChangeConMap = new Map<Id,String>();  // Spuran to Confirm - Originates from Campaign  

        for(Id idkey:contactToUpdateMap.keySet()){
            SObject o1 = idkey.getSObjectType().newSObject(idkey);
            for(String s:contactToUpdateMap.get(idkey)){
                o1.put(s,true);
                system.debug('%%%%%%:'+o1);
            } 
            if(subscriptionChangeConMap.containsKey(idkey)){
                o1.put('Email_Subscription_Change_Source__c', subscriptionChangeConMap.get(idkey));     
            }
            contactToUpdateList.add(o1); 
        }
        if(contactToUpdateList.size() > 0){
            contactList = (List<Contact>)contactToUpdateList;
        }
        conList.addAll(contactList);
        return conList;
    }
    
    public static List<Lead> afterInsertUpdateLead(form_data__c formData,Map<Id,String> statusMap,Map<string,SubscriptionManagement__c> settingMap){
        
        List<string> statuslist = new List<string> ();
        List<Lead> LeadList = new List<Lead>();
        Map<Id, List<String>> leadToUpdateMap = new Map<Id, List<String>>();
        form_data__c pro = formData;
        
        if(pro.Lead__C != null){ 
            lead l = new lead();
            l.Id = pro.lead__C; 
            if(pro.Form_Name__c != NULL){
                l.Original_Source__c = pro.Form_Name__c;
            }
            if(pro.Subscription__c == 'Do Not Email'){
                l.HasOptedOutOfEmail = true;
            } 
            if(pro.Overwrite_Lead__c){
                if(pro.First_Name__c != null){
                    l.FirstName = pro.First_Name__c;
                }
                if(pro.Last_Name__c != null){
                    l.LastName = pro.Last_Name__c;
                }
                if(pro.Mailing_Street__c != null){
                    l.street = pro.Mailing_Street__c;
                }
                if(pro.Mailing_City__c != null){
                    l.City = pro.Mailing_City__c;
                }
                if(pro.Mailing_State_Province__c != null){
                    l.State = pro.Mailing_State_Province__c;
                }
                if(pro.Mailing_Zip_Postal_Code__c != null){
                    l.PostalCode = pro.Mailing_Zip_Postal_Code__c;
                }
                if(pro.Mailing_Country__c != null){
                    l.Country = pro.Mailing_Country__c;
                }
                if(pro.Title__c != null){
                    l.Title = pro.Title__c;
                }
                if(pro.Company__c != null){
                    l.company = pro.Company__c;
                }
                if(pro.Phone__c != null){
                    l.phone = pro.Phone__c; 
                }
                if(pro.Mobile_Phone__c != null){
                    l.Mobile_Phone__c = pro.Mobile_Phone__c; 
                }
                if(pro.Form_Name__c != null){
                    l.Email_Subscription_Change_Source__c = pro.Form_Name__c;
                }
            } 
            LeadList.add(l);  
        }
        
        
        
        if(pro.Bulk_Load__c == false && pro.Status__c=='Completed'){
            if(statusMap.containsKey(pro.form__c)){
                statuslist = statusMap.get(pro.form__c).split(';');
                system.debug('statuslist123==:'+statuslist);
            }
            if(statusMap.containsKey(pro.id)){
                statuslist = statusMap.get(pro.id).split(';');
                system.debug('statuslist==:'+statuslist);
            }
            
            if((statusMap.containsKey(pro.form__c))|| (statusMap.containsKey(pro.id))){
                for(String s:statuslist){
                    if(settingMap.containsKey(s) && pro.Lead__c !=null && pro.Subscription__c != 'Do Not Email' ){
                        if(settingMap.get(s).Lead_Field_Maapping__c != null && pro.Lead__c !=null && pro.Subscription__c !='No' ){   
                            if(leadToUpdateMap.containsKey(pro.Lead__c)){
                                List<String> ldl = leadToUpdateMap.get(pro.Lead__c); 
                                system.debug('ldl231231==:'+ldl);
                                ldl.addAll(settingMap.get(s).Lead_Field_Maapping__c.split(','));
                                leadToUpdateMap.put(pro.Lead__c,ldl);  
                                system.debug('leadToUpdateMap==:'+leadToUpdateMap);
                            }else{
                                List<String> leadfields=settingMap.get(s).Lead_Field_Maapping__c.split(',');  
                                leadToUpdateMap.put(pro.Lead__c,leadfields);  
                                system.debug('leadToUpdateMap123==:'+leadToUpdateMap);  
                            }
                        } 
                    }
                }
            }
        }
        
        List<SObject> LeadSobjectList = new List<SObject>();
        List<Lead> ldList = new List<Lead>();
        Map<Id,String> subscriptionChangeLeadMap = new Map<Id,String>();   // Spuran to Confirm - Originates from Campaign  

        for(Id idkey:leadToUpdateMap.keySet()){
            SObject o1 = idkey.getSObjectType().newSObject(idkey);
            for(String s:leadToUpdateMap.get(idkey)){
                o1.put(s, true); 
            } 
            if(subscriptionChangeLeadMap.containsKey(idkey)){
                o1.put('Email_Subscription_Change_Source__c', subscriptionChangeLeadMap.get(idkey));    
            }
            LeadSobjectList.add(o1); 
        }
        
        if(LeadSobjectList.size() > 0){
            ldList = (List<Lead>)LeadSobjectList;
        }
        LeadList.addAll(ldList);
        
        return LeadList;
    }
    
}