public class ScrContractTriggerHelper {
    // will have to come back on country code
    
    Static Id SCRRecId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('SCR_Program').getRecordTypeId();
    Static Id ICBRRRecId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ICBRR_Program').getRecordTypeId();
    Static Id PearsonrecId = Schema.SObjectType.Integration_Data__c.getRecordTypeInfosByDeveloperName().get('Pearson').getRecordTypeId();
    
    public static Boolean isFirstRun = true;
    
    public static void createPearsonVueData(List<Contract> Contracts,Map<Id,Contract> oldMapObject) {
        try{
            isFirstRun = false;
            set<Id> contractIds = new set<Id>();
            Map<ID,Contract> ContractMap = new Map<ID,Contract>();
            for(Contract con:Contracts){ 
                system.debug(con);
                 system.debug( oldMapObject.get(con.Id));
                if(con.RecordTypeId == SCRRecId || con.RecordTypeId == ICBRRRecId){ 
                    ContractMap.put(con.Id,con);
                    if(((con.Status =='Activated' && oldMapObject.get(con.Id).Status !='Activated') || 
                        (con.Status =='Canceled' && oldMapObject.get(con.Id).Status !='Canceled'))                   || 
                       ((con.Pearson_Phone_No__c != oldMapObject.get(con.Id).Pearson_Phone_No__c                     || 
                         con.Pearson_Member_First_Name__c != oldMapObject.get(con.Id).Pearson_Member_First_Name__c    || 
                         con.Pearson_Member_Last_Name__c != oldMapObject.get(con.Id).Pearson_Member_Last_Name__c      ||
                         con.Pearson_Member_Middle_Name__c != oldMapObject.get(con.Id).Pearson_Member_Middle_Name__c  ||
                         con.BillingStreet != oldMapObject.get(con.Id).BillingStreet                                  ||
                         con.SCR_Deferred_Status__c != oldMapObject.get(con.Id).SCR_Deferred_Status__c                ||
                         con.Billingpostalcode != oldMapObject.get(con.Id).Billingpostalcode                          ||
                         con.Billingcountry != oldMapObject.get(con.Id).Billingcountry                                ||
                         con.BillingState != oldMapObject.get(con.Id).BillingState                                    ||
                         con.BillingCity != oldMapObject.get(con.Id).BillingCity                                      || 
                         con.Member_Email__c != oldMapObject.get(con.Id).Member_Email__c                              || 
                         con.SCR_Start_Date__c != oldMapObject.get(con.Id).SCR_Start_Date__c                          ||
                         con.SCR_End_Date__c != oldMapObject.get(con.Id).SCR_End_Date__c                              || 
                         con.ContractTerm != oldMapObject.get(con.Id).ContractTerm                                    ||
                         ((con.Pearson_Accommodation_Type__c != oldMapObject.get(con.Id).Pearson_Accommodation_Type__c && con.Pearson_Accommodation_Type_Status__c =='Approved') || 
                          (con.Pearson_Accommodation_Type__c !=null && con.Pearson_Accommodation_Type_Status__c =='Approved' && oldMapObject.get(con.Id).Pearson_Accommodation_Type_Status__c !='Approved')) ||
                         (con.Second_Attempt_FRR__c == true && oldMapObject.get(con.Id).Second_Attempt_FRR__c == false)) && oldMapObject.get(con.Id).Status !='Canceled'))
                        contractIds.add(con.Id);
                        system.debug('****:'+contractIds);
                }
            }
            Map<Id,Id> ExamRegistrationsMap = new  Map<Id,Id>();
            for(Exam_Attempt__c examreg:[Select Id,Candidate_Commitment__c,Opportunity_StageName__c,result__c,cancelled__c from Exam_Attempt__c where Candidate_Commitment__c In :ContractMap.keyset() and Opportunity_StageName__c ='closed' and result__c =null and cancelled__c =false Order by CreatedDate Desc]){
                if(!ExamRegistrationsMap.containskey(examreg.Candidate_Commitment__c))
                    ExamRegistrationsMap.put(examreg.Candidate_Commitment__c,examreg.Id); 
            }
            List<Integration_Data__c> PearsonVueDataList = new List<Integration_Data__c>();
            List<Integration_Data__c> OldPearsonVueDataList = new List<Integration_Data__c>();
            set<Id> activePearsonIds = new set<Id>();
            Map<Id,Id> oldContractMap = new Map<Id,Id>();
            if(contractIds.size()>0){
                for(Integration_Data__c ps:[
                    SELECT Id,Pearson_Vue_Candidate_ID__c, Version_Number__c,Is_Active__c, Contract__c, Registration_Status__c 
                    FROM Integration_Data__c 
                    WHERE Contract__c In:contractIds Order By Version_Number__c Desc]){  
                        if(!oldContractMap.containsKey(ps.Contract__c))
                            activePearsonIds.add(ps.Id);
                        
                        oldContractMap.put(ps.Contract__c, ps.Id);
                        if(ps.Is_Active__c == true){
                            ps.Registration_Status__c = 'Not-Valid'; 
                            ps.Is_Active__c = false;
                            OldPearsonVueDataList.add(ps);
                        }
                    }
            }
            List<Integration_Data__c> PearsonActiveCloneList = cloneActiveRecord(activePearsonIds);
            system.debug(PearsonActiveCloneList.size());
            for(Integration_Data__c ps: PearsonActiveCloneList){
                if(ContractMap.containsKey(ps.Contract__c)){ 
                    if(ContractMap.get(ps.Contract__c).RecordTypeId == ICBRRRecId){ 
                        ps.eligibilityApptDateFirst__c = datetimeformat(ContractMap.get(ps.Contract__c).StartDate); 
                        ps.eligibilityApptDateLast__c = datetimeformat(ContractMap.get(ps.Contract__c).EndDate);  
                    }else if(ContractMap.get(ps.Contract__c).RecordTypeId == SCRRecId){
                        ps.eligibilityApptDateFirst__c = datetimeformat(ContractMap.get(ps.Contract__c).SCR_Start_Date__c);  
                        ps.eligibilityApptDateLast__c = datetimeformat(ContractMap.get(ps.Contract__c).SCR_End_Date__c);
                    }
                    ps.First_Name__c = ContractMap.get(ps.Contract__c).Pearson_Member_First_Name__c; 
                    ps.Last_Name__c = ContractMap.get(ps.Contract__c).Pearson_Member_Last_Name__c;
                    ps.Middle_Name__c = ContractMap.get(ps.Contract__c).Pearson_Member_Middle_Name__c;
                    ps.Email__c = ContractMap.get(ps.Contract__c).Member_Email__c; 
                      
                    if(ContractMap.get(ps.Contract__c).Garp_Id__c != null){
                        ps.Garp_Id__c = ContractMap.get(ps.Contract__c).Garp_Id__c.leftPad(8, '0');
                    }
                    if(ps.Version_Number__c != null)
                        ps.Version_Number__c = ps.Version_Number__c+1;
                    ps.Address_Type__c = 'Work'; 
                    ps.Call_out_Type__c = 'Out-bound';
                    ps.Created_From__c = 'Contract Change'; 
                    if(ExamRegistrationsMap.containsKey(ps.Contract__c))
                          ps.Exam_Registrations__c = ExamRegistrationsMap.get(ps.Contract__c);
                    
                    if(ContractMap.get(ps.Contract__c).Second_Attempt_FRR__c == true && oldMapObject.get(ps.Contract__c).Second_Attempt_FRR__c == false){
                        ps.Pearson_Operation_Type__c= null;
                        ps.Pearson_Event_Type__c= null;
                        ps.Pearson_Event_NotificationID__c= null;
                        ps.Pearson_Event_Time__c= null;
                        ps.Appointment_Duration__c= null;
                        ps.Pearson_Appointment_Source__c= null;
                        ps.Pearson_appointmentDisplayTimeZone__c= null;
                        ps.Pearson_AppointmenDisplayTimeZoneUtc__c= null;
                        ps.Pearson_CurrentUtcOffset__c= null;
                        ps.Pearson_vueOrderNo__c= null;
                        ps.ExamDelivered__c= false;
                        ps.Assesment_Type__c= null;
                        ps.Scheduled_Date_Time__c= null;
                        ps.Exam_Status__c= null;
                        ps.Location_Name__c= null;
                        ps.Pearson_vue_Test_CenterID__c= null;
                        ps.Location_Address__c= null;
                        ps.Exam_Location_Country__c= null;
                        ps.Exam_Location_City__c= null;
                        ps.Exam_Location_State__c= null;
                        ps.Exam_Location_Postal_Code__c= null;
                        ps.Results__c= null;
                    }
                    ps.Name = ContractMap.get(ps.Contract__c).ContractNumber +' - '+ ps.Version_Number__c;  
                    ps.Registration_Status__c = 'Not-Valid'; 
                    ps.Last_updated_Time__c = system.now();
                    ps.Authorization_Type__c = 'Add'; 
                     if((ps.Is_Active__c == true && ps.Pearson_Vue_Candidate_ID__c != null && ps.Pearson_Vue_Candidate_ID__c !='') || 
                       (ContractMap.get(ps.Contract__c).SCR_Start_Date__c != oldMapObject.get(ps.Contract__c).SCR_Start_Date__c || 
                        ContractMap.get(ps.Contract__c).SCR_End_Date__c != oldMapObject.get(ps.Contract__c).SCR_End_Date__c ||
                        (ContractMap.get(ps.Contract__c).Pearson_Accommodation_Type__c != null && ContractMap.get(ps.Contract__c).Pearson_Accommodation_Type_Status__c == 'Approved'))){  
                            ps.Authorization_Type__c = 'Update';
                            ps.Outbound_Event_Types__c = 'EAD';
                        }
                    if(ContractMap.get(ps.Contract__c).status == 'Canceled'|| ContractMap.get(ps.Contract__c).SCR_Deferred_Status__c == 'Pending'){
                        ps.Authorization_Type__c = 'Delete'; 
                        ps.Outbound_Event_Types__c = 'EAD';
                        
                    }
                    if((ContractMap.get(ps.Contract__c).Status == 'Activated' && oldMapObject.get(ps.Contract__c).Status != 'Activated')||(ContractMap.get(ps.Contract__c).SCR_Deferred_Status__c != 'Pending' && oldMapObject.get(ps.Contract__c).SCR_Deferred_Status__c!= ContractMap.get(ps.Contract__c).SCR_Deferred_Status__c)|| (ContractMap.get(ps.Contract__c).Second_Attempt_FRR__c == true && oldMapObject.get(ps.Contract__c).Second_Attempt_FRR__c == false)){
                        ps.Pearson_Vue_Candidate_ID__c = null; 
                        if(ContractMap.get(ps.Contract__c).Status == 'Activated' && oldMapObject.get(ps.Contract__c).Status != 'Activated')
                            ps.Outbound_Event_Types__c  = 'Ping Database;CDD;EAD';
                        else
                            ps.Outbound_Event_Types__c  = 'EAD';   
                        ps.Authorization_Type__c = 'Add';  
                    }
                    if((ContractMap.get(ps.Contract__c).Pearson_Phone_No__c != oldMapObject.get(ps.Contract__c).Pearson_Phone_No__c                   || 
                        ContractMap.get(ps.Contract__c).Pearson_Member_First_Name__c != oldMapObject.get(ps.Contract__c).Pearson_Member_First_Name__c || 
                        ContractMap.get(ps.Contract__c).Pearson_Member_Last_Name__c != oldMapObject.get(ps.Contract__c).Pearson_Member_Last_Name__c   || 
                        ContractMap.get(ps.Contract__c).Pearson_Member_Middle_Name__c != oldMapObject.get(ps.Contract__c).Pearson_Member_Middle_Name__c   || 
                        ContractMap.get(ps.Contract__c).Member_Email__c != oldMapObject.get(ps.Contract__c).Member_Email__c                           || 
                        ContractMap.get(ps.Contract__c).BillingStreet != oldMapObject.get(ps.Contract__c).BillingStreet                               || 
                        ContractMap.get(ps.Contract__c).Billingpostalcode != oldMapObject.get(ps.Contract__c).Billingpostalcode                       || 
                        ContractMap.get(ps.Contract__c).Billingcountry != oldMapObject.get(ps.Contract__c).Billingcountry                             || 
                        ContractMap.get(ps.Contract__c).BillingState != oldMapObject.get(ps.Contract__c).BillingState                                 || 
                        ContractMap.get(ps.Contract__c).BillingCity != oldMapObject.get(ps.Contract__c).BillingCity)                                 
                      ){                   
                          ps.Outbound_Event_Types__c  = 'CDD';
                          ps.Is_Canddiate_Info_Changed__c  = true;
                          ps.Authorization_Type__c = 'Update';
                      }else{
                          ps.Is_Canddiate_Info_Changed__c  = false;
                      } 
                    ps.Call_out_Status__c = 'Initial';
                    // Mapping Address info
                    CountryCodes__c countryCodes = CountryCodes__c.getValues(ContractMap.get(ps.Contract__c).Billingcountry);
                    ps.Country__c = countryCodes != null  ? countryCodes.ISOCode__c : 'USA';
                    PS.Phone_Country_Code__c = countryCodes != null ? countryCodes.PhoneCode__c : '1';
                    // ps.Country__c = 'USA'; 
                    system.debug(ContractMap.get(ps.Contract__c).BillingState);
                    ps.State__c = (ContractMap.get(ps.Contract__c).BillingState != null && ContractMap.get(ps.Contract__c).BillingState.length() >50)? Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingState).substring(0,50):Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingState);
                    ps.Address_1__c = (ContractMap.get(ps.Contract__c).BillingStreet != null && ContractMap.get(ps.Contract__c).BillingStreet.length() > 40)?Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingStreet).substring(0,40):Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingStreet);
                    ps.Postal_Code__c = ContractMap.get(ps.Contract__c).Billingpostalcode; 
                    ps.City__c = (ContractMap.get(ps.Contract__c).BillingCity != null && ContractMap.get(ps.Contract__c).BillingCity.length() > 32) ?Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingCity).substring(0,32):Utilities.replaceChars(ContractMap.get(ps.Contract__c).BillingCity);
                    if(ContractMap.get(ps.Contract__c).Pearson_Phone_No__c != null){
                        if((ps.Country__c == 'USA' || ps.Country__c == 'CAN') && ContractMap.get(ps.Contract__c).Pearson_Phone_No__c.startsWith('1')){
                            ps.phone_Number__c = ContractMap.get(ps.Contract__c).Pearson_Phone_No__c.removeStart('1');
                        }else{
                            ps.phone_Number__c = ContractMap.get(ps.Contract__c).Pearson_Phone_No__c;
                        }                       
                    }else{
                        ps.phone_Number__c = '2017197210';
                    } 
                    ps.RecordTypeId = PearsonrecId;
                    PearsonVueDataList.add(ps); 
                } 
            }
            system.debug('PearsonVueDataList'+PearsonVueDataList.size());
            for(Contract con:Contracts){
                if(con.RecordTypeId == SCRRecId || con.RecordTypeId == ICBRRRecId){
                    if(((con.Status == 'Activated' && oldMapObject.get(con.Id).Status != 'Activated')&& !oldContractMap.containsKey(con.Id))){  
                        Integration_Data__c PearsonVueData = new Integration_Data__c();
                        PearsonVueData.RecordTypeId = PearsonrecId;
                        if(ExamRegistrationsMap.containsKey(con.Id))
                            PearsonVueData.Exam_Registrations__c = ExamRegistrationsMap.get(con.Id);
                        PearsonVueData.Registration_Status__c = 'Not-Valid';
                        PearsonVueData.Created_From__c = 'Contract Initial'; 
                        PearsonVueData.Call_out_Status__c = 'Initial';
                        PearsonVueData.Is_Canddiate_Info_Changed__c  = false;
                        PearsonVueData.Call_out_Type__c = 'Out-bound';
                        PearsonVueData.Authorization_Type__c = 'Add'; 
                        PearsonVueData.Contract__c = con.Id; 
                        PearsonVueData.Version_Number__c =1; 
                        PearsonVueData.Address_Type__c = 'Work';
                        PearsonVueData.Outbound_Event_Types__c  = 'Ping Database;CDD;EAD';
                        PearsonVueData.Last_updated_Time__c = system.now();
                        PearsonVueData.Name = con.ContractNumber + ' - ' + PearsonVueData.Version_Number__c;
                        if(con.Garp_Id__c != null){
                            PearsonVueData.Garp_Id__c = con.Garp_Id__c.leftPad(8, '0');
                        }
                        if(con.StartDate != null && con.EndDate != null && con.RecordTypeId == ICBRRRecId){
                            PearsonVueData.eligibilityApptDateFirst__c = datetimeformat(con.StartDate);  
                            PearsonVueData.eligibilityApptDateLast__c = datetimeformat(con.EndDate); 
                        }else if(con.RecordTypeId == SCRRecId){
                            PearsonVueData.eligibilityApptDateFirst__c = datetimeformat(con.SCR_Start_Date__c);  
                            PearsonVueData.eligibilityApptDateLast__c = datetimeformat(con.SCR_End_Date__c); 
                        }
                        
                        //Mapping candidate Info 
                        PearsonVueData.First_Name__c = con.Pearson_Member_First_Name__c; 
                        PearsonVueData.Last_Name__c = con.Pearson_Member_Last_Name__c;
                        PearsonVueData.Middle_Name__c = con.Pearson_Member_Middle_Name__c;
                        PearsonVueData.Email__c = con.Member_Email__c;
                        
                        //PearsonVueData.Phone_Country_Code__c = '1';
                        
                        
                        // Mapping Address info
                        CountryCodes__c countryCodes = CountryCodes__c.getValues(ContractMap.get(PearsonVueData.Contract__c).Billingcountry);
                        PearsonVueData.Country__c = countryCodes != null ? countryCodes.ISOCode__c : 'USA';
                        PearsonVueData.Phone_Country_Code__c = countryCodes != null ? countryCodes.PhoneCode__c : '1';
                        //PearsonVueData.Country__c = 'USA';
                        PearsonVueData.State__c = (con.BillingState != null && con.BillingState.length()>50)?Utilities.replaceChars(con.BillingState).substring(0,50):Utilities.replaceChars(con.BillingState);
                        PearsonVueData.Address_1__c = (con.BillingStreet != null && con.BillingStreet.length()>40)?Utilities.replaceChars(con.BillingStreet).substring(0,40):Utilities.replaceChars(con.BillingStreet); 
                        PearsonVueData.Postal_Code__c = con.Billingpostalcode;
                        PearsonVueData.City__c = (con.BillingCity != null && con.BillingCity.length()>32)?Utilities.replaceChars(con.BillingCity).substring(0,32):Utilities.replaceChars(con.BillingCity);
                        
                        if(con.RecordTypeId == SCRRecId){
                            PearsonVueData.Exam_Type__c = 'SCR';
                        }
                        if(con.RecordTypeId == ICBRRRecId){
                            PearsonVueData.Exam_Type__c = 'FRR';  
                            
                        }
                        if(ContractMap.get(PearsonVueData.Contract__c).Pearson_Phone_No__c != null){
                            if((PearsonVueData.Country__c == 'USA' || PearsonVueData.Country__c == 'CAN') && ContractMap.get(PearsonVueData.Contract__c).Pearson_Phone_No__c.startsWith('1')){
                                PearsonVueData.phone_Number__c = ContractMap.get(PearsonVueData.Contract__c).Pearson_Phone_No__c.removeStart('1');
                            }else{
                                PearsonVueData.phone_Number__c = ContractMap.get(PearsonVueData.Contract__c).Pearson_Phone_No__c;
                            }                       
                        }else{
                            PearsonVueData.phone_Number__c = '2017197210';
                        }
                        PearsonVueDataList.add(PearsonVueData);
                    }
                }
            }
           
            if(OldPearsonVueDataList.size()>0){
                upsert OldPearsonVueDataList;
            }
            if(PearsonVueDataList.size()>0){
                insert PearsonVueDataList;
            }
          
            //callout
            set<Id> PearsonId = new set<Id>();
            for(Integration_Data__c p:PearsonVueDataList){
                PearsonId.add(p.Id);
            }
            if(PearsonId.size()>0){
                if(system.isBatch()){
                    ID jobID = System.enqueueJob(new PearsonVueCallOutQueueable(PearsonId));
                 }else{
                     PearsonVueRTIDataHelper.PearsonVueDatacallout(PearsonId);
                 }
                /*List<Integration_Stream_Event__e> evts = TriggerUtilities.getIntgEvents(PearsonId, 'Contract', 'PearsonVue');
                EventBus.publish(evts);*/
                
            }
            
        }catch(Exception ex){
            system.debug(ex.getMessage());
            system.debug(ex.getLinenumber());
            system.debug(ex.getStackTraceString());
        }
    }
    
    public static string datetimeformat(Date dt){
        String dtformat;
        if(dt != null){
            Datetime dttime = datetime.newInstance(dt.year(), dt.month(),dt.day()); 
            dtformat = dttime.format('YYYY/MM/dd HH:mm:ss');
        }
        return dtformat;
    }
    
    public static List<Integration_Data__c> cloneActiveRecord(Set<Id> PearsonIds){ 
        List<Integration_Data__c> PearsonActierec = new List<Integration_Data__c>(); 
        if(PearsonIds.size()>0){
            List<String> fields = new List<String>();
            fields.addAll(Integration_Data__c.getsObjectType().getDescribe().fields.getMap().keySet());
            String soql = 'SELECT ' + String.join(fields, ',') +
                ' FROM Integration_Data__c WHERE Id IN: PearsonIds ';
            PearsonActierec = Database.query(soql).deepclone(false,false,false); 
        }
        return PearsonActierec;
    }
    
}