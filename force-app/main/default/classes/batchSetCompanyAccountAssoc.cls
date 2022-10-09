global class batchSetCompanyAccountAssoc implements Database.Batchable<sObject>{

    public String mode;  
    public String testId;  
    
	global batchSetCompanyAccountAssoc(String mode, String testId){
        this.mode= mode;    
        this.testId= testId;
    }    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query;
        if(mode == 'join') {
            if(testId == null)
            	query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE (KPI_FRM_Certified__c = true OR KPI_ERP_Certified__c = true OR KPI_Current_Exam_Registration__c != null) and Company_Association_Processed__c = false AND RecordTypeId = \'' + RecordTypeHelper.GetRecordTypeId('Contact', 'Member') + '\'';
            else query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE ID = :testId and (KPI_FRM_Certified__c = true OR KPI_ERP_Certified__c = true OR KPI_Current_Exam_Registration__c != null) and Company_Association_Processed__c = false AND RecordTypeId = \'' + RecordTypeHelper.GetRecordTypeId('Contact', 'Member') + '\'';
        } else if(mode == 'joinreg2016') {
                query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE id in (Select Member__c from Exam_Attempt__c where RPT_Exam_Year__c = \'2016\') and Company_Association_Processed__c = false AND RecordTypeId = \'' + RecordTypeHelper.GetRecordTypeId('Contact', 'Member') + '\'';
        } else if(mode == 'delete') {
            if(testId == null)
            	query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE Company_Association_Processed__c = true';
			else query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE ID = :testId and Company_Association_Processed__c = true';
        } else if(mode == 'acctcount') {
            ID indvRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
            query = 'SELECT Id, Name, Alt_Company_Name__c, Clean_Company_Name__c, KPI_Employee_FRM_Certified_Count__c, KPI_Employee_ERP_Certified_Count__c, KPI_Employee_ERP_Registered_Count__c, KPI_Employee_FRM_Registered_Count__c, KPI_Employee_Total_Count__c, KPI_Employee_FRM_2016_Reg_Count__C, KPI_Employee_ERP_2016_Reg_Count__c FROM Account WHERE KPI_Employee_Total_Count__c = null and RecordTypeID != :indvRecId';
        } else if(mode == 'acctdelete') {
            query = 'SELECT Id, Name, Alt_Company_Name__c, Clean_Company_Name__c, KPI_Employee_FRM_Certified_Count__c, KPI_Employee_ERP_Certified_Count__c, KPI_Employee_ERP_Registered_Count__c, KPI_Employee_FRM_Registered_Count__c, KPI_Employee_Total_Count__c FROM Account WHERE KPI_Employee_Total_Count__c != null';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> objs){
        if(this.mode == 'acctdelete') {
            MAP<ID,Account> acctMap = new MAP<ID,Account>();
            for(sObject c: objs){
                Account acct = (Account)c;
                acct.KPI_Employee_FRM_Certified_Count__c=null;
                acct.KPI_Employee_ERP_Certified_Count__c=null;
                acct.KPI_Employee_FRM_Registered_Count__c=null;
                acct.KPI_Employee_ERP_Registered_Count__c=null;
                acct.KPI_Employee_FRM_2016_Reg_Count__C=null;
                acct.KPI_Employee_ERP_2016_Reg_Count__c=null;
                acct.KPI_Employee_Total_Count__c=null;
                acctMap.put(acct.Id,acct);
            }
            update acctMap.values();
        } else if(this.mode == 'acctcount') {
            MAP<ID,Account> acctMap = new MAP<ID,Account>();
            for(sObject c: objs){
                Account acct = (Account)c;
                acct.KPI_Employee_FRM_Certified_Count__c=0;
                acct.KPI_Employee_ERP_Certified_Count__c=0;
                acct.KPI_Employee_Total_Count__c=0;
                acct.KPI_Employee_FRM_Registered_Count__c=0;
                acct.KPI_Employee_ERP_Registered_Count__c=0;
                acct.KPI_Employee_FRM_2016_Reg_Count__C=0;
                acct.KPI_Employee_ERP_2016_Reg_Count__c=0;
                acctMap.put(acct.Id,acct);
            }
            system.debug('acctMap:' + acctMap);
            List<Contact> lstContact = [select Id, Name, AccountID, Company_Account__c, KPI_ERP_Certified__c, KPI_FRM_Certified__c, KPI_Current_Exam_Registration__c, KPI_Last_Exam_Date__c, KPI_Last_Exam_Registration__c from Contact where Company_Account__c = :acctMap.keySet()];
            for(Contact c: lstContact){
                Account acct = acctMap.get(c.Company_Account__c);
                if(acct != null) {
                    if(c.KPI_FRM_Certified__c == true)
                    	acct.KPI_Employee_FRM_Certified_Count__c++;
                    if(c.KPI_ERP_Certified__c == true)
                    	acct.KPI_Employee_ERP_Certified_Count__c++;
                    if(c.KPI_Current_Exam_Registration__c != NULL) {
                        if(c.KPI_Current_Exam_Registration__c.indexOf('FRM') > -1) {
                            acct.KPI_Employee_FRM_Registered_Count__c++;
                        }
                        if(c.KPI_Current_Exam_Registration__c.indexOf('ERP') > -1) {
                            acct.KPI_Employee_ERP_Registered_Count__c++;
                        }
                    }
                    if(c.KPI_Last_Exam_Registration__c != NULL && c.KPI_Last_Exam_Date__c != NULL) {
                        if(c.KPI_Last_Exam_Registration__c.indexOf('FRM') > -1 && c.KPI_Last_Exam_Date__c.indexOf('2016') > -1) {
                            acct.KPI_Employee_FRM_2016_Reg_Count__C++;
                        }
                        if(c.KPI_Last_Exam_Registration__c.indexOf('ERP') > -1 && c.KPI_Last_Exam_Date__c.indexOf('2016') > -1) {
                            acct.KPI_Employee_ERP_2016_Reg_Count__C++;
                        }
                    }
                    
                    acct.KPI_Employee_Total_Count__c++;
                    acctMap.put(c.Company_Account__c,acct);
                }
            }
            system.debug('acctMap:' + acctMap);
            update acctMap.values();
        } else if(this.mode == 'delete') {
            List<sObject> lstContact = new List<sObject>();
            for(sObject c: objs){
                c.put('Company_Association_Processed__c',false);
                c.put('Company_Account__c',null);
                lstContact.add(c);
            }
            update lstContact;
        } else {
            Set<Id> contactIds = new Set<Id>();
            List<Account> lstAcctNoMatch = [select Id from Account where Name = 'NO MATCH'];
            Account acctNoMatch=null;
            if(lstAcctNoMatch != null && lstAcctNoMatch.size() > 0) {
                acctNoMatch = lstAcctNoMatch[0];
            }
            for(sObject c: objs){
                if(c.get('Company_Clean_Name__c') != null){
                    contactIds.add(c.Id);
                }
            }
            batchSetCompanyAccountAssocUtil.updateInsertContactCompanyAccount(contactIds, acctNoMatch);            
        }
       
    }
    
    global void finish(Database.BatchableContext bc){
        //new EmailMessageUtil(new List<String>{'david.lappert@garp.com'}).sendBatchFinishedNotification(bc);
    }
    
}