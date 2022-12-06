global class batchProductClassUpdateSage implements database.Batchable<sObject>{
    
	global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        return Database.getQueryLocator([Select Id,Exam_Registration_Modification__c from Opportunity where Exam_Registration_Modification__c != null and StageName = 'Closed' and CreatedDate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
        Set<Id> ermIdList = new Set<Id>();
        Map<String,Opportunity_Product_Mapping__mdt> oppProductToMethodMap = OpportunityTriggerHelper_New.getOppProductMethodMapAllProducts();
        Map<String,String> classMap = new Map<String,String>();
        
        for(ia_crm__Class__c cls : [SELECT ia_crm__Class_ID__c,ia_crm__Status__c,Id,Name FROM ia_crm__Class__c LIMIT 2000]){
			classMap.put(cls.Name,cls.Id);
		}
        
        List<Opportunity> oppList = [Select Id,Exam_Registration_Modification__c,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_State__c,GARP_Member_ID__c,AccountId,
                                     ChargentSFA__Card_Type__c,Shipping_Country__c,Shipping_State__c,ia_crm__Intacct_Transaction__c,CloseDate,
                                     (SELECT Id, Name, ProductCode,Exam_Registration__r.Member__c, Product2Id,Opportunity.OSTA_Exam_Site_Code__c,TotalPrice,
                                      Opportunity.OSTA_Opportunity_Refund__c, Opportunity.Exam_Registration_Modification__c, Product2.Family, ia_crm__Class__c,
                                      Product2.Department__c, Product2.Location__c, Product2.Class__c, Sage_Reporting_Country__c,Site_Code__c,Sage_Shipping_Country__c,
                                      Event__c, Exam_Site__r.Id, Exam_Registration__c, OpportunityId, UnitPrice, Quantity, Opportunity.AccountId,Batches_Updated__c,
                                      Opportunity.GARP_Member_ID__c, Scholarship_Application__c,Exam_Registration__r.Exam_Date__c,Description,Product_Id__c,
                                      Product2.Is_Shippable__c, Product2.Weight__c, Product2.Product_ID__c,Product2.Bookstore__c,Product2.Name, Product2.Customs_Cost__c,
                                      Product2.GL_Code__c,Opportunity.StageName,Opportunity.ChargentSFA__Billing_Email__c,Product2.Company__c,Product2.ProductCode
                                      FROM OpportunityLineItems Order By Name)
                                     from Opportunity where Id IN: scope];
        
        for(Opportunity opp : oppList){
            if(opp.Exam_Registration_Modification__c != null)
                ermIdList.add(opp.Exam_Registration_Modification__c);
        }
        
        Map<Id,Exam_Registration_Modification__c> ermMap = new Map<Id,Exam_Registration_Modification__c>([SELECT Id,Part_I_Exam_Group_From__c,Part_I_Exam_Group_To__r.Name,
                                                                                                          Part_I_Exam_Group_From__r.Name,Part_I_Exam_Group_To__c,
																										  Part_I_Exam_Admin_From__r.Exam_Group__r.Exam_Date__c,Part_II_Exam_Admin_From__r.Exam_Group__r.Exam_Date__c,
                                                                                                          Part_I_Exam_Admin_To__r.Exam_Group__r.Exam_Date__c,Part_II_Exam_Admin_To__r.Exam_Group__r.Exam_Date__c,
                                                                                                          Part_I_Exam_Registration__c,Part_II_Exam_Registration__c,
                                                                                                          Part_I_Exam_Registration__r.Exam_Site__r.Name,Part_II_Exam_Registration__r.Exam_Site__r.Name,
                                                                                                          Part_I_Exam_Admin_From__c,Part_II_Exam_Admin_From__c,
                                                                                                          Part_I_Exam_Part_From__c,Part_II_Exam_Part_From__c,
                                                                                                          Part_I_Exam_Part_From__r.Exam_Date__c,Part_II_Exam_Part_From__r.Exam_Date__c,
                                                                                                          Part_I_Exam_Part_From__r.Exam_Start_Date__c,Part_II_Exam_Part_From__r.Exam_Start_Date__c,
                                                                                                          Part_I_Exam_Part_To__c,Part_II_Exam_Part_To__c,
                                                                                                          Part_I_Exam_Part_To__r.Exam_Date__c,Part_II_Exam_Part_To__r.Exam_Date__c,
                                                                                                          Part_I_Exam_Part_To__r.Exam_Start_Date__c,Part_II_Exam_Part_To__r.Exam_Start_Date__c,
																										  Part_I_Exam_Registration__r.Opportunity__c,Part_II_Exam_Registration__r.Opportunity__c,
																										  Part_I_Exam_Registration__r.Section__c,Part_II_Exam_Registration__r.Section__c,
                                                                                                          Part_I_Exam_Registration__r.Garp_Id__c,Part_II_Exam_Registration__r.Garp_Id__c,Part_II_Exam_Registration__r.Defered__c,
                                                                                                          Part_I_Exam_Registration__r.Other_Exam_Registrations__c,Part_II_Exam_Registration__r.Other_Exam_Registrations__c,
                                                                                                          Part_I_Exam_Registration__r.Other_Exam_Registrations__r.Cancelled__c,Part_II_Exam_Registration__r.Other_Exam_Registrations__r.Cancelled__c,
                                                                                                          Part_I_Exam_Registration__r.Other_Exam_Registrations__r.Defered__c,Part_II_Exam_Registration__r.Other_Exam_Registrations__r.Defered__c,
                                                                                                          Part_I_Exam_Registration__r.Other_Exam_Registrations__r.Exam_Site__r.Name,Part_II_Exam_Registration__r.Other_Exam_Registrations__r.Exam_Site__r.Name
                                                                                                          FROM Exam_Registration_Modification__c WHERE Id IN:ermIdList]);
        
        for(Opportunity opp : oppList){
            String deferralClass;
            if(opp.Exam_Registration_Modification__c != null){
                Exam_Registration_Modification__c erm = ermMap.get(opp.Exam_Registration_Modification__c);
                if(erm.Part_I_Exam_Registration__c != null && erm.Part_I_Exam_Admin_From__c != erm.Part_I_Exam_Admin_To__c){
                    date frmDate;
                    date toDate;
                    if(erm.Part_I_Exam_Part_From__c != null){
                        frmDate = erm.Part_I_Exam_Part_From__r.Exam_Date__c != null ? erm.Part_I_Exam_Part_From__r.Exam_Date__c : erm.Part_I_Exam_Part_From__r.Exam_Start_Date__c;
                    }else{
                        frmDate = null;
                    }
                    if(erm.Part_I_Exam_Part_To__c != null){
                        toDate = erm.Part_I_Exam_Part_To__r.Exam_Date__c != null ? erm.Part_I_Exam_Part_To__r.Exam_Date__c : erm.Part_I_Exam_Part_To__r.Exam_Start_Date__c;
                    }else{
                        toDate = null;
                    }
                    
                    if(frmDate != null && (toDate == null || (toDate != null && frmDate < toDate))){
                        deferralClass = convertMonthNumberToText(frmDate.month())+' Registration';
                    }else if(toDate != null && (frmDate == null || (frmDate != null && toDate < frmDate))){
                        deferralClass = convertMonthNumberToText(toDate.month())+' Registration';
                    }
                    
                }
                if(erm.Part_II_Exam_Registration__c != null && erm.Part_II_Exam_Admin_From__c != erm.Part_II_Exam_Admin_To__c){
                    date frmDate;
                    date toDate;
                    if(erm.Part_II_Exam_Part_From__c != null){
                        frmDate = erm.Part_II_Exam_Part_From__r.Exam_Date__c != null ? erm.Part_II_Exam_Part_From__r.Exam_Date__c : erm.Part_II_Exam_Part_From__r.Exam_Start_Date__c;
                    }else{
                        frmDate = null;
                    }
                    if(erm.Part_II_Exam_Part_To__c != null){
                        toDate = erm.Part_II_Exam_Part_To__r.Exam_Date__c != null ? erm.Part_II_Exam_Part_To__r.Exam_Date__c : erm.Part_II_Exam_Part_To__r.Exam_Start_Date__c;
                    }else{
                        toDate = null;
                    }
                    
                    if(frmDate != null && (toDate == null || (toDate != null && frmDate < toDate))){
                        if(deferralClass == null)
                            deferralClass = convertMonthNumberToText(frmDate.month())+' Registration';
                    }else if(toDate != null && (frmDate == null || (frmDate != null && toDate < frmDate))){
                        if(deferralClass == null)
                            deferralClass = convertMonthNumberToText(toDate.month())+' Registration';
                    }
                }
                
                for(OpportunityLineItem oli : opp.OpportunityLineItems){
                    if((oli.ProductCode == 'FRM1' && oli.Product2.GL_Code__c == '4020') || oli.ProductCode == 'SCR'){
                        if(classMap.containskey(deferralClass) && oli.ia_crm__Class__c == null){
                            oli.ia_crm__Class__c =  classMap.get(deferralClass);
                            if(oli.Batches_Updated__c != null){
                                List<String> batches = oli.Batches_Updated__c.split(';');
                                batches.add('Class Batch');
                                oli.Batches_Updated__c = String.join(batches, ';');
                            }else{
                                oli.Batches_Updated__c = 'Class Batch';
                            }
                            oliToUpdate.add(oli);
                        }
                    }
                }
            }
        }
        
        if(!oliToUpdate.isEmpty()){
            update oliToUpdate;
        }
        
     }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    private static String convertMonthNumberToText(Integer matrixMonth){
        if(matrixMonth == 1){
            return 'Jan';   
        }else if(matrixMonth == 2){
            return 'Feb';   
        }else if(matrixMonth == 3){
            return 'Mar';   
        }else if(matrixMonth == 4){
            return 'Apr';   
        }else if(matrixMonth == 5){
            return 'May';       
        }else if(matrixMonth == 6){            
            return 'Jun';   
        }else if(matrixMonth == 7){
            return 'Jul';   
        }else if(matrixMonth == 8){
            return 'Aug';   
        }else if(matrixMonth == 9){
            return 'Sep';   
        }else if(matrixMonth == 10){
            return 'Oct';  
        }else if(matrixMonth == 11){
            return 'Nov';  
        }else{
            return 'Dec';
        }
    }
}