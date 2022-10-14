/*  Apex Trigger for flowing values from Exam Registration to Contact KPI fields
*  01/22/2019 Xiang - Added Comments for Case 00198535
*  01/24/2019 AG - Made changes for Case 00198535
*/
trigger examRegistration2ContactSync on Exam_Attempt__c (after insert, after update) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ExamAttemptMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        
        Map<Id,Exam_Attempt__c> mapEAIds = new Map<Id,Exam_Attempt__c>();
        map< id, Exam_Attempt__c > ContactID2EA = new map< id, Exam_Attempt__c > () ;
        for(Exam_Attempt__c obj : trigger.New)
        {        
            mapEAIds.put(obj.Member__c,obj);
            ContactID2EA.put( obj.member__c, obj ) ;
        }
        
        Map<String,String> examNameMap = new Map<String,String>();
        examNameMap.put('FRM Part 1','FRM Exam Part I');
        examNameMap.put('FRM Part 2','FRM Exam Part II');
        
        system.debug('* * * mapEAIds: ' + mapEAIds.keySet());
        
        List<Exam_Attempt__c> lstExamAttempt = [
            SELECT 
            Id, 
            Name, 
            Exam_Date__c, 
            Section__c, 
            Icbrr_Exam_Date__c, 
            ICBRR_Submission_Status__c,
            Registered_On__c, 
            Opportunity__r.CloseDate, 
            Opportunity__r.StageName, 
            CreatedDate, 
            ADA_Status__c, 
            RAD_Status__c, 
            Scholarship_Status__c, 
            Cancelled__c, 
            hasViolation__c, 
            Checked_In__c, 
            Result__c, 
            Defered__c, 
            Exam_Site__r.Site__r.Display_Address__c, 
            Exam_Site__r.Name, 
            Exam_Site__r.Exam__r.Exam__c, 
            Exam_Site__r.Exam_Date__c, 
            Exam_Site__r.Exam__r.Exam_Date__c, 
            Exam_Site__r.Exam__r.Exam_Group__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c,
            Session__c, 
            Member__r.GARP_ID__c, 
            Member__r.name, 
            Exam_Site__r.Site__r.Site_Code__c, 
            Room__r.name, 
            Seat_No__c, 
            Reg_Status__c,
            RPT_Registration_Type__c,
            Integration_Data_Status__c
            FROM Exam_Attempt__c 
            WHERE 
            Member__C in :mapEAIds.keySet() AND 
            Reg_Status__c != 'Cancelled' 
            ORDER BY Exam_Site__r.Exam_Date__c
        ];
        
        system.debug('* * * lstExamAttempt: ' + lstExamAttempt);
        
        List<Contact> lstActiveContacts = new List<Contact>();
        for(Contact objContact : [select id, KPI_First_FRM_Part_I_Exam_Date__c, KPI_First_FRM_Part_II_Exam_Date__c, KPI_First_ERP_Part_I_Exam_Date__c, KPI_First_ERP_Part_II_Exam_Date__c, KPI_First_FRM_Part_I_Exam_Result__c,
                                  KPI_First_FRM_Part_II_Exam_Result__c, KPI_First_ERP_Part_I_Exam_Result__c, KPI_First_ERP_Part_II_Exam_Result__c, KPI_ERP_Part_I_Attempts__c, KPI_ERP_Part_II_Attempts__c, KPI_FRM_Part_I_Attempts__c,
                                  KPI_FRM_Part_II_Attempts__c, KPI_ERP_Part_I_Pass_Exam_Date__c, KPI_ERP_Part_II_Pass_Exam_Date__c, KPI_FRM_Part_I_Pass_Exam_Date__c, KPI_FRM_Part_II_Pass_Exam_Date__c,Membership_Type__c,Scholarship_Status__c,
                                  KPI_Last_Exam_Registration_Scholarship__c,KPI_Last_Exam_Registration_RA__c,KPI_Last_Exam_Registration_ADA__c,KPI_Last_Exam_Registration_Type__c,KPI_Last_Exam_Location__c,KPI_Last_Exam_Registration__c,
                                  KPI_Last_Exam_Violation__c,KPI_Last_Exam_Result__c,KPI_Last_Exam_Check_In__c, KPI_Last_Exam_Deferral_Status__c, KPI_Current_Exam_Reg_Business_Type__c, KPI_Exam_Deferral_Status__c, KPI_Current_Exam_Date__c,
                                  KPI_Current_Exam_Location__c,KPI_Current_Exam_Reg_Scholarship__c,KPI_Current_Exam_Registration_RA__c, KPI_Current_Exam_Registration_ADA__c,KPI_Current_Exam_Registration_Date__c,KPI_Current_Exam_Registration__c,
                                  KPI_Current_Exam_Registration_Type__c, KPI_FRM_Last_Registration_Date__c,KPI_ERP_Last_Registration_Date__c,KPI_ICBRR_Result__c,KPI_ICBRR_Registration_Count__c,KPI_Membership_Since__c,KPI_Exam_Attempt_ID_2__c, 
                                  RPT_First_FRM_Part_II_Registration_Exam__c,RPT_First_ERP_Part_II_Registration_Exam__c,
                                  KPI_SCR_Attempts__c, KPI_SCR_Last_Integration_Data_Status__c,KPI_Exam_Attempt_ID__c, accountId from contact where Id in: mapEAIds.keySet()])
        {
            
            objContact.KPI_SCR_Attempts__c = null;
            objContact.KPI_SCR_Last_Integration_Data_Status__c = null;
            
            objContact.KPI_ICBRR_Exam_Date__c = null;
            objContact.KPI_ICBRR_Result__c = null;
            objContact.KPI_ICBRR_Registration_Count__c = 0;
            objContact.KPI_Current_Exam_Registration__c = null;
            
            // Now save for Part I and II
            objContact.KPI_Current_Exam_Registration_Type__c = null;
            objContact.KPI_Current_Exam_Registration_II_Type__c = null;
            
            objContact.KPI_Current_Exam_Registration_I_Status__c = null;
            objContact.KPI_Current_Exam_Registration_II_Status__c = null;
            
            objContact.KPI_Current_Exam_Location__c = null;
            objContact.KPI_Current_Exam_Reg_Business_Type__c = null;
            objContact.KPI_Current_Exam_Registration_ADA__c = false;
            objContact.KPI_Current_Exam_Registration_RA__c = false;
            objContact.KPI_Current_Exam_Reg_Scholarship__c = false;
            objContact.Scholarship_Status__c = null;
            objContact.KPI_Current_Exam_Registration_Date__c = null;
            objContact.KPI_Current_Exam_Date__c = null;
            objContact.KPI_Exam_Deferral_Status__c = null;
            
            objContact.KPI_Last_Exam_Result__c = null;
            objContact.KPI_Last_Exam_Violation__c = false;
            objContact.KPI_Last_Exam_Registration__c = null;
            objContact.KPI_Last_Exam_Location__c = null;
            objContact.KPI_Last_Exam_Registration_Type__c = null;
            objContact.KPI_Last_Exam_Registration_ADA__c = false;
            objContact.KPI_Last_Exam_Registration_RA__c = false;
            objContact.KPI_Last_Exam_Registration_Scholarship__c = false;
            objContact.KPI_Last_Exam_Date__c = null;
            objContact.KPI_Last_Exam_Deferral_Status__c = null;
            
            objContact.KPI_Exam_Attempt_ID__c = null;
            objContact.KPI_Exam_Attempt_ID_2__c = null; 
            
            objContact.KPI_Last_Exam_Check_In__c = false;
            
            objContact.RPT_First_FRM_Registration_Exam_Date__c = null;
            objContact.RPT_First_ERP_Registration_Exam_Date__c = null;
            
            objContact.RPT_First_FRM_Part_II_Registration_Exam__c = null;
            objContact.RPT_First_ERP_Part_II_Registration_Exam__c  = null;
            
            objContact.KPI_FRM_Last_Registration_Date__c = null;
            objContact.KPI_ERP_Last_Registration_Date__c = null;
            
            objContact.KPI_First_FRM_Exam_Date__c = null;
            objContact.KPI_First_ERP_Exam_Date__c = null;
            
            objContact.KPI_First_FRM_Part_I_Exam_Date__c = null;
            objContact.KPI_First_FRM_Part_II_Exam_Date__c = null;
            objContact.KPI_First_ERP_Part_I_Exam_Date__c = null;
            objContact.KPI_First_ERP_Part_II_Exam_Date__c = null;
            objContact.KPI_First_FRM_Part_I_Exam_Result__c = null;
            objContact.KPI_First_FRM_Part_II_Exam_Result__c = null;
            objContact.KPI_First_ERP_Part_I_Exam_Result__c = null;
            objContact.KPI_First_ERP_Part_II_Exam_Result__c = null;
            objContact.KPI_ERP_Part_I_Attempts__c = null;
            objContact.KPI_ERP_Part_II_Attempts__c = null;
            objContact.KPI_FRM_Part_I_Attempts__c = null;
            objContact.KPI_FRM_Part_II_Attempts__c = null;
            objContact.KPI_ERP_Part_I_Pass_Exam_Date__c = null;
            objContact.KPI_ERP_Part_II_Pass_Exam_Date__c = null;
            objContact.KPI_FRM_Part_I_Pass_Exam_Date__c = null;
            objContact.KPI_FRM_Part_II_Pass_Exam_Date__c = null;
            
            objContact.FRM_Part_I_Last_Registration_Exam_Date__c = null;
            objContact.FRM_Part_I_Last_Exam_Result__c = null;
            objContact.FRM_Part_I_Last_Exam_Violation__c = false;
            objContact.FRM_Part_II_Last_Registration_Exam_Date__c = null;
            objContact.FRM_Part_II_Last_Exam_Result__c = null;
            objContact.FRM_Part_II_Last_Exam_Violation__c = false;
            objContact.ERP_Last_Registration_Exam_Date__c = null;
            objContact.ERP_Last_Exam_Result__c = null;
            objContact.ERP_Last_Violation__c = false;
            objContact.ERP_Part_II_Last_Registration_Exam_Date__c = null;
            objContact.ERP_Part_II_Last_Exam_Result__c = null;
            objContact.ERP_Part_II_Last_Exam_Violation__c = false;
            
            
            Boolean activeFound=false;
            Boolean activeDeferal=false;
            Integer activeCnt=0;
            Exam_Attempt__c lastResult=null;
            
            Exam_Attempt__c lastFRMResult=null;
            Exam_Attempt__c lastERPResult=null;
            
            Exam_Attempt__c ICBRRLastResult=null;
            
            List<Exam_Attempt__c> lstLastExam = new List<Exam_Attempt__c>();
            List<Exam_Attempt__c> lstCurrentExam = new List<Exam_Attempt__c>();
            
            for(Exam_Attempt__c ea : lstExamAttempt) {
                if(ea.Member__C == objContact.Id && ea.Exam_Site__r != NULL && ea.Exam_Site__r.Exam__r != NULL && ea.Exam_Site__r.Exam__r.Exam__c != NULL && 
                   ea.Exam_Site__r.Exam__r.Exam_Group__r != NULL && ea.Exam_Site__r.Exam_Date__c != NULL && ea.Opportunity__r != NULL) {
                       
                       system.debug('* * * Exam Attempt: ' + ea.Id);
                       
                       // Find most recent previous Exam Registrations
                       if(ea.Exam_Site__r.Exam__r.Exam__c != 'ICBRR' && (ea.Opportunity__r.StageName == 'Closed' || ea.Opportunity__r.StageName == 'Closed Won') &&  
                          ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c != True) {
                              if(lstLastExam.size() > 0) {
                                  Exam_Attempt__c lea = lstLastExam.get(0);
                                  if(lea.Exam_Site__r.Exam_Date__c != ea.Exam_Site__r.Exam_Date__c) {
                                      lstLastExam = new List<Exam_Attempt__c>();
                                  }
                              }
                              lstLastExam.add(ea);  
                          }
                       
                       // SCR
                       if(ea.Exam_Site__r.Exam__r.Exam__c == 'SCR') {
                           if(objContact.KPI_SCR_Attempts__c  == Null){
                               objContact.KPI_SCR_Attempts__c = 1;
                           } else {
                               objContact.KPI_SCR_Attempts__c++;
                           }
                           
                           if(ea.Integration_Data_Status__c != 'Expired'&& ea.Integration_Data_Status__c != 'Lapsed'){
                               objContact.KPI_SCR_Last_Integration_Data_Status__c  = ea.Integration_Data_Status__c;
                           }
                       }
                       
                       // Find current Exam Registrations
                       if(ea.Exam_Site__r.Exam__r.Exam__c != 'ICBRR' && 
                          ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True) {
                              if(lstCurrentExam.size() > 0) {
                                  Exam_Attempt__c lea = lstCurrentExam.get(0);
                                  if(lea.Exam_Site__r.Exam_Date__c != ea.Exam_Site__r.Exam_Date__c) {
                                      lstCurrentExam = new List<Exam_Attempt__c>();
                                  }
                              }
                              lstCurrentExam.add(ea);  
                          }
                       
                       
                       if(ea.Exam_Site__r.Exam__r.Exam__c == 'ICBRR') {
                           if(ea.Result__c != null && (ICBRRLastResult == null || ea.Exam_Site__r.Exam_Date__c > ICBRRLastResult.Exam_Site__r.Exam_Date__c))
                               ICBRRLastResult = ea;
                           
                           if(ea.ICBRR_Submission_Status__c != NULL)
                               objContact.KPI_ICBRR_Registration_Count__c++;                    
                       }
                       
                       system.debug('ea.Exam_Site__r.Exam__r.Exam__c==========>'+ea.Exam_Site__r.Exam__r.Exam__c);              
                       system.debug('ea.Exam_Date__c ==========>'+ea.Exam_Date__c );              
                       
                       if(ea.Exam_Date__c != NULL) {
                           if((ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' || ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Full Program') && objContact.RPT_First_FRM_Registration_Exam_Date__c == NULL) {
                               objContact.RPT_First_FRM_Registration_Exam_Date__c = ea.Exam_Date__c;
                           }
                           if((ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I' || ea.Exam_Site__r.Exam__r.Exam__c == 'ERP') && objContact.RPT_First_ERP_Registration_Exam_Date__c == NULL) {
                               objContact.RPT_First_ERP_Registration_Exam_Date__c = ea.Exam_Date__c;
                           }
                           
                           system.debug('Already? ea.RPT_First_FRM_Part_II_Registration_Exam__c ==========>'+objContact.RPT_First_FRM_Part_II_Registration_Exam__c );                                  
                           
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' && objContact.RPT_First_FRM_Part_II_Registration_Exam__c == NULL) {  
                               objContact.RPT_First_FRM_Part_II_Registration_Exam__c = ea.Exam_Date__c;
                               system.debug('UPDATE ea.Exam_Date__c ==========>'+objContact.RPT_First_FRM_Part_II_Registration_Exam__c );                                  
                               
                           }
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II' && objContact.RPT_First_ERP_Part_II_Registration_Exam__c == NULL) {
                               objContact.RPT_First_ERP_Part_II_Registration_Exam__c = ea.Exam_Date__c;
                           }
                       }
                       
                       // Only collect these stats once the entire exam admin is over
                       if(ea.result__c != NULL && ea.Exam_Date__c != NULL) {
                           
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                               
                               // Save most recent Info
                               objContact.FRM_Part_I_Last_Registration_Exam_Date__c = ea.Exam_Date__c;
                               objContact.FRM_Part_I_Last_Exam_Violation__c = ea.hasViolation__c;                       
                               objContact.FRM_Part_I_Last_Exam_Result__c = ea.result__c;
                               
                               if(objContact.KPI_FRM_Part_I_Attempts__c == Null)
                                   objContact.KPI_FRM_Part_I_Attempts__c=1;
                               else objContact.KPI_FRM_Part_I_Attempts__c++;                        
                               
                               // If earliest Attempt set First Attempt Info
                               if(objContact.KPI_First_FRM_Part_I_Exam_Date__c == NULL) {
                                   objContact.KPI_First_FRM_Part_I_Exam_Date__c = ea.Exam_Date__c;
                                   objContact.KPI_First_FRM_Exam_Date__c = ea.Exam_Date__c;
                               }
                               
                               // If earliest Result set First Attempt Info
                               if(objContact.KPI_First_FRM_Part_I_Exam_Result__c == NULL) {
                                   objContact.KPI_First_FRM_Part_I_Exam_Result__c = ea.Result__c;                                
                               }
                               
                               // If Result is Pass set
                               if(ea.Result__c == 'Pass') {
                                   objContact.KPI_FRM_Part_I_Pass_Exam_Date__c = ea.Exam_Date__c;
                               }                        
                               
                           }
                           
                           // If a valid FRM Part II Exam Attempt
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                               
                               // Save most recent Info
                               objContact.FRM_Part_II_Last_Registration_Exam_Date__c = ea.Exam_Date__c;
                               objContact.FRM_Part_II_Last_Exam_Violation__c = ea.hasViolation__c;
                               objContact.FRM_Part_II_Last_Exam_Result__c = ea.Result__c;
                               
                               if(objContact.KPI_FRM_Part_II_Attempts__c == Null)
                                   objContact.KPI_FRM_Part_II_Attempts__c=1;
                               else objContact.KPI_FRM_Part_II_Attempts__c++;
                               
                               // If earliest Attempt set First Attempt Info
                               if(objContact.KPI_First_FRM_Part_II_Exam_Date__c == NULL) {
                                   objContact.KPI_First_FRM_Part_II_Exam_Date__c = ea.Exam_Date__c;                        
                               }
                               
                               // If earliest Result set First Attempt Info
                               if(objContact.KPI_First_FRM_Part_II_Exam_Result__c == NULL) {
                                   objContact.KPI_First_FRM_Part_II_Exam_Result__c = ea.Result__c;                                
                               }
                               
                               // If Result is Pass set
                               if(ea.Result__c != NULL && ea.Result__c == 'Pass') {
                                   objContact.KPI_FRM_Part_II_Pass_Exam_Date__c = ea.Exam_Date__c;
                               }                  
                               
                           }
                           
                           // If a valid ERP Part I Exam Attempt
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I') {
                               
                               // Save most recent Info
                               objContact.ERP_Last_Registration_Exam_Date__c = ea.Exam_Date__c; 
                               objContact.ERP_Last_Violation__c = ea.hasViolation__c;
                               objContact.ERP_Last_Exam_Result__c = ea.result__c;  
                               
                               if(objContact.KPI_ERP_Part_I_Attempts__c == Null)
                                   objContact.KPI_ERP_Part_I_Attempts__c=1;
                               else objContact.KPI_ERP_Part_I_Attempts__c++;
                               
                               // If earliest Attempt set First Attempt Info
                               if(objContact.KPI_First_ERP_Part_I_Exam_Date__c == NULL) {
                                   objContact.KPI_First_ERP_Part_I_Exam_Date__c = ea.Exam_Date__c;
                                   objContact.KPI_First_ERP_Exam_Date__c = ea.Exam_Date__c;
                               }
                               
                               // If earliest Result set First Attempt Info
                               if(objContact.KPI_First_ERP_Part_I_Exam_Result__c == NULL) {
                                   objContact.KPI_First_ERP_Part_I_Exam_Result__c = ea.Result__c;                                
                               }
                               
                               // If Result is Pass set
                               if(ea.Result__c != NULL && ea.Result__c == 'Pass') {
                                   objContact.KPI_ERP_Part_I_Pass_Exam_Date__c = ea.Exam_Date__c;
                               }
                           }
                           
                           // If a valid ERP Part II Exam Attempt
                           if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II') {
                               
                               // Save most recent Info
                               objContact.ERP_Part_II_Last_Registration_Exam_Date__c = ea.Exam_Date__c; 
                               objContact.ERP_Part_II_Last_Exam_Violation__c = ea.hasViolation__c;
                               objContact.ERP_Part_II_Last_Exam_Result__c = ea.result__c;  
                               
                               if(objContact.KPI_ERP_Part_II_Attempts__c == Null)
                                   objContact.KPI_ERP_Part_II_Attempts__c=1;
                               else objContact.KPI_ERP_Part_II_Attempts__c++;
                               
                               // If earliest Attempt set First Attempt Info
                               if(objContact.KPI_First_ERP_Part_II_Exam_Date__c == NULL) {
                                   objContact.KPI_First_ERP_Part_II_Exam_Date__c = ea.Exam_Date__c;                        
                               }
                               
                               // If earliest Result set First Attempt Info
                               if(objContact.KPI_First_ERP_Part_II_Exam_Result__c == NULL) {
                                   objContact.KPI_First_ERP_Part_II_Exam_Result__c = ea.Result__c;                                
                               }
                               
                               // If Result is Pass set
                               if(ea.Result__c != NULL && ea.Result__c == 'Pass') {
                                   objContact.KPI_ERP_Part_II_Pass_Exam_Date__c = ea.Exam_Date__c;
                               }
                           }
                       }
                   }
            }
            
            // Set ICBRR Result
            if(ICBRRLastResult != null) {
                objContact.KPI_ICBRR_Result__c = ICBRRLastResult.Result__c;
                objContact.KPI_ICBRR_Exam_Date__c = ICBRRLastResult.Icbrr_Exam_Date__c;
                
            }
            
            // Set Last (non-Active) Exam Registration Data
            Integer deferCount = 0;
            String deferredLastExamName;
            for(Exam_Attempt__c ea : lstLastExam) {
                String examName = ea.Exam_Site__r.Exam__r.Exam__c;
                String niceExamName = examNameMap.get(examName);
                if(niceExamName == null) {
                    niceExamName = examName;
                }
                
                // Exam Date            
                if(ea.Exam_Site__r.Exam_Date__c != null) {
                    Datetime dt = datetime.newInstance(ea.Exam_Site__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam_Date__c.month(),ea.Exam_Site__r.Exam_Date__c.day());
                    if(objContact.KPI_Last_Exam_Date__c != dt.format('MMMM yyyy')) {
                        deferCount = 0;
                    }
                    objContact.KPI_Last_Exam_Date__c = dt.format('MMMM yyyy');                
                }            
                
                if(ea.Defered__c != NULL && ea.Defered__c.toLowerCase().indexOf('approved') > -1) {
                    //objContact.KPI_Last_Exam_Deferral_Status__c = 'Deferred';
                    deferCount++;
                    
                    // Exam Name
                    if(deferredLastExamName != null && deferredLastExamName.toLowerCase().indexOf('frm') > -1) {
                        deferredLastExamName = 'FRM Exam Part I & II';
                    } else if(deferredLastExamName != null && deferredLastExamName.toLowerCase().indexOf('erp') > -1) {
                        deferredLastExamName = 'ERP Exam Part I & II';
                    } else {
                        deferredLastExamName = niceExamName;
                    }
                    
                    
                } else {
                    
                    // Exam Name
                    if(objContact.KPI_Last_Exam_Registration__c != null && objContact.KPI_Last_Exam_Registration__c.toLowerCase().indexOf('frm') > -1) {
                        objContact.KPI_Last_Exam_Registration__c = 'FRM Exam Part I & II';
                    } else if(objContact.KPI_Last_Exam_Registration__c != null && objContact.KPI_Last_Exam_Registration__c.toLowerCase().indexOf('erp') > -1) {
                        objContact.KPI_Last_Exam_Registration__c = 'ERP Exam Part I & II';
                    } else {
                        objContact.KPI_Last_Exam_Registration__c = niceExamName;
                    }
                    
                }
                
                // FRM / ERP Exam Date
                if(ea.Exam_Site__r.Exam__r.Exam__c != null && ea.Exam_Site__r.Exam__r.Exam__c.indexOf('FRM') > -1)
                    objContact.KPI_FRM_Last_Registration_Date__c = ea.Exam_Site__r.Exam_Date__c;
                if(ea.Exam_Site__r.Exam__r.Exam__c != null && ea.Exam_Site__r.Exam__r.Exam__c.indexOf('ERP') > -1)
                    objContact.KPI_ERP_Last_Registration_Date__c = ea.Exam_Site__r.Exam_Date__c;   
                
                // Exam Location
                if(ea.Exam_Site__r.Site__r.Display_Address__c != null && ea.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                    objContact.KPI_Last_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
                else objContact.KPI_Last_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c;
                
                // Registration Type - most recent
                if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                    objContact.KPI_Last_Exam_Registration_Type__c = 'Early';
                } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                    objContact.KPI_Last_Exam_Registration_Type__c = 'Standard';
                } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                    objContact.KPI_Last_Exam_Registration_Type__c = 'Late';
                }                
                
                // Last Exam Data - Results
                objContact.KPI_Last_Exam_Check_In__c = ea.Checked_In__c;
                objContact.KPI_Last_Exam_Result__c = ea.Result__c;
                objContact.KPI_Last_Exam_Violation__c = ea.hasViolation__c;
                
                if(ea.ADA_Status__c != null && ea.ADA_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Last_Exam_Registration_ADA__c = true;    
                }
                if(ea.RAD_Status__c != null && ea.RAD_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Last_Exam_Registration_RA__c = true;    
                }
                if(ea.Scholarship_Status__c != null && ea.Scholarship_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Last_Exam_Registration_Scholarship__c = true;    
                }                        
            }
            
            
            //System.assert(false, 'BOOM!' + lstCurrentExam);
            
            // Set Active Exam Registration Data
            Integer currDeferCount = 0;
            String deferredExamName;
            for(Exam_Attempt__c ea : lstCurrentExam) {
                String examName = ea.Exam_Site__r.Exam__r.Exam__c;
                String niceExamName = examNameMap.get(examName);
                if(niceExamName == null) {
                    niceExamName = examName;
                }
                
                if(ea.Defered__c != null && ea.Defered__c.toLowerCase().indexOf('pending') > -1) {
                    currDeferCount++;
                    
                    // Exam Name
                    if(deferredExamName != null && deferredExamName.toLowerCase().indexOf('frm') > -1) {
                        deferredExamName = 'FRM Exam Part I & II';
                    } else if(deferredExamName != null && deferredExamName.toLowerCase().indexOf('erp') > -1) {
                        deferredExamName = 'ERP Exam Part I & II';
                    } else {
                        deferredExamName = niceExamName;
                    }
                    
                } else {
                    
                    // Exam Name
                    if(objContact.KPI_Current_Exam_Registration__c != null && objContact.KPI_Current_Exam_Registration__c.toLowerCase().indexOf('frm') > -1) {
                        objContact.KPI_Current_Exam_Registration__c = 'FRM Exam Part I & II';
                    } else if(objContact.KPI_Current_Exam_Registration__c != null && objContact.KPI_Current_Exam_Registration__c.toLowerCase().indexOf('erp') > -1) {
                        objContact.KPI_Current_Exam_Registration__c = 'ERP Exam Part I & II';
                    } else {
                        objContact.KPI_Current_Exam_Registration__c = niceExamName;
                    }
                }
                
                // Exam Date            
                if(ea.Exam_Site__r.Exam_Date__c != null) {
                    Datetime dt = datetime.newInstance(ea.Exam_Site__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam_Date__c.month(),ea.Exam_Site__r.Exam_Date__c.day());
                    objContact.KPI_Current_Exam_Date__c = dt.format('MMMM dd, yyyy');                
                }            
                
                // Exam Location
                if(ea.Exam_Site__r.Site__r.Display_Address__c != null && ea.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                    objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
                else objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c;
                
                // Id - most recent
                if(objContact.KPI_Exam_Attempt_ID__c == null) {
                    objContact.KPI_Exam_Attempt_ID__c = ea.id;
                } else {
                    objContact.KPI_Exam_Attempt_ID_2__c = ea.id;
                }
                
                // Regostration Date - most recent
                objContact.KPI_Current_Exam_Registration_Date__c = ea.Registered_On__c;
                
                // Registration Type - most recent
                String regType = ea.RPT_Registration_Type__c.replace(' Registration','');
                if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' || ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I') {
                    objContact.KPI_Current_Exam_Registration_Type__c = regType;
                    objContact.KPI_Current_Exam_Registration_I_Status__c = ea.Reg_Status__c;
                } else {
                    objContact.KPI_Current_Exam_Registration_II_Type__c = regType;
                    objContact.KPI_Current_Exam_Registration_II_Status__c = ea.Reg_Status__c;
                }
                
                
                
                if(ea.ADA_Status__c != null && ea.ADA_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Current_Exam_Registration_ADA__c = true;    
                }
                if(ea.RAD_Status__c != null && ea.RAD_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Current_Exam_Registration_RA__c = true;    
                }
                if(ea.Scholarship_Status__c != null && ea.Scholarship_Status__c.toLowerCase().indexOf('approved') > -1) {
                    objContact.KPI_Current_Exam_Reg_Scholarship__c = true;    
                }            
                
                if(ea.Scholarship_Status__c != NULL)
                    objContact.Scholarship_Status__c = ea.Scholarship_Status__c;            
            }
            
            if(lstCurrentExam.size() > 0 && lstLastExam.size() > 0) {
                objContact.KPI_Current_Exam_Reg_Business_Type__c = 'Renewal';
            } else if(lstCurrentExam.size() > 0) {
                objContact.KPI_Current_Exam_Reg_Business_Type__c = 'New';
            }
            if(lstCurrentExam.size() > 0 && lstCurrentExam.size() == currDeferCount) {
                objContact.KPI_Current_Exam_Reg_Business_Type__c = 'New';
                objContact.KPI_Exam_Deferral_Status__c='Defferral Pending';
                objContact.KPI_Current_Exam_Registration__c = deferredExamName;
            }
            
            //System.assert(false, 'BOOM!' + lstLastExam.size() + ':' + deferCount);
            
            if(lstLastExam.size() > 0 && lstLastExam.size() == deferCount) {
                objContact.KPI_Last_Exam_Deferral_Status__c='Defferred';
                objContact.KPI_Last_Exam_Registration__c = deferredLastExamName;
            }        
            system.debug('* * * Add Contact: ' + objContact);
            lstActiveContacts.add(objContact);        
        }    
        
        if(!lstActiveContacts.isEmpty()){
            UPDATE lstActiveContacts; 
        }
    }
}