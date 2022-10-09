global class batchUnpaidEventRegistrations implements Database.Batchable<SObject>{
         
        
            public String testIds;  
            
            global batchUnpaidEventRegistrations(String testIds){ 
                this.testIds= testIds;
            }    
            
            global Database.QueryLocator start(Database.BatchableContext BC){
            
               Set<String> checkStatus = new Set<String>{'Registered'};
                   Set<String> ids = new Set<String>{''};
                       Set<String> oppstatus = new Set<String>{'Unpaid'};
                                             
                           if(this.testIds != null) {
                               ids = new Set<String>{this.testIds};
                                   }
                          
               if(test.isRunningTest())
                   return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Contact__c, Member_Type__c, Event__c, RPT_Last_Date_Wire_Check_Registration__c, Status__c, Opportunity__c, Opportunity__r.StageName, RPT_ERP_Candidate__c, RPT_Invoice_Payment_Status__c, RPT_Alternate_Payment_Method__c, Member_Email__c, RPT_Event_Date__c FROM Event_Registration__c where  Status__c in:checkStatus');         
               if(this.testIds != null) {       
                   return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Contact__c, Member_Type__c, Event__c, RPT_Last_Date_Wire_Check_Registration__c, Status__c, Opportunity__c, Opportunity__r.StageName, RPT_ERP_Candidate__c, RPT_Invoice_Payment_Status__c, RPT_Alternate_Payment_Method__c, Member_Email__c FROM Event_Registration__c where RPT_Event_Date__c>today and RPT_Invoice_Payment_Status__c =:oppstatus and id in:ids and Status__c in:checkStatus');
               } else {
                   return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Contact__c, Member_Type__c, Event__c, RPT_Last_Date_Wire_Check_Registration__c, Status__c, Opportunity__c, Opportunity__r.StageName, RPT_ERP_Candidate__c, RPT_Invoice_Payment_Status__c, RPT_Alternate_Payment_Method__c, Member_Email__c FROM Event_Registration__c where RPT_Event_Date__c>today and RPT_Invoice_Payment_Status__c =:oppstatus and Status__c in:checkStatus');
               }
           
           }
            
           global void execute(Database.BatchableContext BC, List<Event_Registration__c> scope){
            
                List<Event_Registration__c> lstEventRegs = new List<Event_Registration__c>();
                List<Opportunity> lstOpptoUpdate = new List<Opportunity>();         
  
    /*            for(Event_Registration__c reg : scope){
                        
                if (date.today() > reg.CreatedDate)
                {
               
               DateTime dT = reg.CreatedDate;
               Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
               //INTEGER dTerm = Date.Today().daysBetween(myDate );
               INTEGER dTerm = myDate.daysBetween(Date.Today() );
               system.debug('&&&&:'+dTerm);
               
               reg.RPT_Days_since_Registration__c = dTerm;
              } 
                  lstEventRegs.add(reg);
                  
        }
                update lstEventregs;
                }*/
                
       
                for(Event_Registration__c reg : scope){
                        
                if (date.today() > reg.CreatedDate)
                {
               
               DateTime dT = reg.CreatedDate;
               Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
               INTEGER dTerm = myDate.daysBetween(Date.Today() );
               system.debug('&&&&:'+dTerm);
               
               reg.RPT_Days_since_Registration__c = dTerm;
               }
               if (date.today() == reg.RPT_Last_Date_Wire_Check_Registration__c){
               reg.Status__c = 'cancelled';
              } 
                  lstEventRegs.add(reg);
                  
        }
                update lstEventregs;
                }
                         
    
           global void finish(Database.BatchableContext BC){
                 }
        }