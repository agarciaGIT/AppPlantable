global without sharing class reportsGARP {
    
    public reportsGARP() { 
    }
    
    global class projectData {
        public List<Initiative__c> projects { get; set; }
        public List<Project_Resource__c> resources { get; set; }
    }
    
    global class rptData {
        public List<Product_Refunds__c> refunds { get; set; }
        public List<Opportunity> opps { get; set; }
        public List<ChargentSFA__Transaction__c> trans { get; set; }
    }
    
    global class returnSettingsInfo { 
        public String userId { get; set; }
        //public List<Exam_Report_Settings__c> settings { get; set; }
        public Exam_Stats_Version__c version { get; set; }
    }
    
    @RemoteAction
    global static Boolean updateStats() {
        //Database.executeBatch(new batchSnapExamStats('version'));
        return true;
    }
    
    @RemoteAction
    global static Boolean deleteSettings(String settingId) {
        /*
		List<Exam_Report_Settings__c> settings = [select Id, Name, User__c, ReportID__c, Display_Options_JSON__c, Color_Options_JSON__c, Chart_Options_JSON__c from Exam_Report_Settings__c where id = :settingId];
        if(settings != null && settings.size() > 0) {
            delete settings;
            return true;
        }
		*/
        return false;
    }
    
    @RemoteAction
    global static returnSettingsInfo getSettings() {
        returnSettingsInfo retInfo = new returnSettingsInfo();
        retInfo.userId = UserInfo.getUserId(); 
        //retInfo.settings = [select Id, Name, User__c, ReportID__c, Display_Options_JSON__c, Color_Options_JSON__c, Chart_Options_JSON__c from Exam_Report_Settings__c];
        List<Exam_Stats_Version__c> examStatsVersion = [SELECT Name, Version__c, Last_Updated__c, Mode__c FROM Exam_Stats_Version__c];
        if(examStatsVersion != null && examStatsVersion.size() > 0) {
            retInfo.version = examStatsVersion[0];
        }        
        return retInfo;
    }
    
    
    @RemoteAction
    global static String setSettings(String userId, String setingsId, String Name, String ReportId, String displayOptions, String colorOptions, String chartOptions) {
        /*
		Exam_Report_Settings__c settingsInfo = new Exam_Report_Settings__c();
        Boolean updateSettings = false;
        if(setingsId != null) {
            List<Exam_Report_Settings__c> retInfos = [select Id, Name, User__c, ReportID__c, Display_Options_JSON__c, Color_Options_JSON__c, Chart_Options_JSON__c from Exam_Report_Settings__c where Id = :setingsId];    
            if(retInfos != NULL && retInfos.size() > 0) {
                settingsInfo = retInfos[0];
                updateSettings = true;
            }    
        } else if(userId != NULL && ReportId == NULL) {
            List<Exam_Report_Settings__c> retInfos = [select Id, Name, User__c, ReportID__c, Display_Options_JSON__c, Color_Options_JSON__c, Chart_Options_JSON__c from Exam_Report_Settings__c where User__c = :userId AND ReportID__c = NULL];
            if(retInfos != NULL && retInfos.size() > 0) {
                settingsInfo = retInfos[0];
                updateSettings = true;
            }                
        }
        if(settingsInfo != NULL) {
            settingsInfo.User__c = userId;
            settingsInfo.Name = Name;
            settingsInfo.ReportID__c = ReportId;
            settingsInfo.Display_Options_JSON__c = displayOptions;
            settingsInfo.Color_Options_JSON__c = colorOptions;
            settingsInfo.Chart_Options_JSON__c = chartOptions;
            if(updateSettings == True) {
                update settingsInfo;
            } else {
                insert settingsInfo;
            }
            return settingsInfo.Id;
        }
		*/
        return null;
    }
    
    @RemoteAction
    global static Boolean setInitiativesRank(String rankOrder) {
        
        Map<String,Integer> mapRankId = new Map<String,Integer>();
        String[] arrVals = rankOrder.split('~');
        
        system.debug('arrVals:' + arrVals);
        
        for(String str :arrVals) {
            String[] arrStrVals = str.split(':');    
            if(arrStrVals.size() > 1) {
                mapRankId.put(arrStrVals[0],Integer.ValueOf(arrStrVals[1]));
            }
        }
        
        system.debug('mapRankId:' + mapRankId);
        
        List<Initiative__c> lstInit = [select Id, Name, Target_End_Date__c, Rank_In_End_Quarter__c from Initiative__c where Id in :mapRankId.keySet()];
        
        system.debug('lstInit:' + lstInit);
        
        for(Initiative__c init :lstInit) {
            Integer rank = mapRankId.get(String.ValueOf(init.Id));
            system.debug('rank:' + rank + ':' + String.ValueOf(init.Id));
            if(rank != null) {
                init.Rank_In_End_Quarter__c = rank;
            }
        }
        system.debug('lstInit:' + lstInit);
        update lstInit;
        
        return false;   
        
    }
    
    @RemoteAction
    global static Boolean setInitiatives(String initiativeId, String endQuarter) {
        
        String[] arrStrVals = endQuarter.split(' '); 
        if(arrStrVals.size() > 1) {
            String quarter = arrStrVals[0];
            Integer yr = Integer.ValueOf(arrStrVals[1]);
            Integer endMonth;
            Integer startMonth;
            
            if(quarter == 'Q1') {           
                startMonth = 1;
                endMonth = 3;
            } else if(quarter == 'Q2') {
                startMonth = 4;
                endMonth = 6;
            } else if(quarter == 'Q3') {
                startMonth = 7;
                endMonth = 9;
            } else {
                startMonth = 10;
                endMonth = 12;
            }
            
            Integer numberOfDays = Date.daysInMonth(yr, endMonth);
            Date lastDayOfMonth = Date.newInstance(yr, endMonth, numberOfDays);
            
            Date newEndDate = Date.newInstance(yr, endMonth, lastDayOfMonth.day());
            
            List<Initiative__c> lstInit = [select Id, Name, Start_Date__c, End_Date__c from Initiative__c where Id = :initiativeId];
            if(lstInit != null && lstInit.size() > 0) {
                lstInit[0].End_Date__c = newEndDate;
                if(lstInit[0].Start_Date__c > lstInit[0].End_Date__c) {
                    Date newStartDate = Date.newInstance(yr, startMonth, 1);
                }
                update lstInit;
                return true;
            }
        }
        return false;
    }
    
    @RemoteAction
    global static List<Initiative__c> getInitiatives() {
        return [select Id, Name, Department__c, Is_Campaign__c, Project_Type__c, Resource_Types__c, Level_Of_Effort__c, Priority__c, Product_Line__c, Status__c, Dev_Resource__c, Target_Date_of_Completion__c, Target_Start_Date__c, Target_End_Date__c, Rank_In_End_Quarter__c, Type__c, Start_Date__c, Start_Quarter__c, End_Date__c, End_Quarter__c, Stage__c from Initiative__c order by Rank_In_End_Quarter__c];
    }
    
    @RemoteAction
    public static projectData getInitiativesResources() {
        projectData pd = new projectData();
        
        pd.projects = [select Id, Name, Department__c, Is_Campaign__c, Project_Type__c, Resource_Types__c, Level_Of_Effort__c, Priority__c, Product_Line__c, Status__c, Dev_Resource__c, Target_Date_of_Completion__c, Target_Start_Date__c, Target_End_Date__c, Rank_In_End_Quarter__c, Type__c, Start_Date__c, Start_Quarter__c, End_Date__c, End_Quarter__c, Stage__c from Initiative__c order by Rank_In_End_Quarter__c];
        pd.resources = [select Id, Name, Project__c, Resource__c, Start_Date__c, End_Date__c from Project_Resource__c];
        
        return pd;
    }
    
    
    @RemoteAction
    public static List<Exam_Sites__c> getExamSites() {
        
        List<Exam_Sites__c> lstExamSites;
        
        lstExamSites= [select Id, Name, Country__c, Site__r.Name, Exam_Date__c from Exam_Sites__c where 
                       CALENDAR_YEAR(Exam_Date__c) >= 2010 and Exam__r.Exam__c != 'ICBRR'];    
        return lstExamSites;
    }
    
    @RemoteAction
    public static List<Deployment__c> getDeploymentData(Integer month, Integer year) {
        
        List<Deployment__c> lstDeployments;
        
        lstDeployments = [select Id, Name, Target_Deployment_Date__c, Target_Deployment_Time__c, Type__c, Email_Recipient_Size__c from Deployment__c where 
                          CALENDAR_YEAR(Target_Deployment_Date__c) = :year and CALENDAR_MONTH(Target_Deployment_Date__c) = :month];
        
        List<Milestone__c> lstMilestones = [select Id, Name, Due_Date__c FROM Milestone__c where Status__c = 'Active'];
        for(Milestone__c m :lstMilestones) {
            Deployment__c d = new Deployment__c(Name=m.Name+'~'+m.Id, Target_Deployment_Date__c=m.Due_Date__c,Type__c='Milestone');
            lstDeployments.add(d);
        }
        
        return lstDeployments;
    }
    
    
    @RemoteAction
    public static rptData getReportData(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        List<Opportunity> pdes;
        Id autoRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id FROM OpportunityLineItems) from Opportunity where RecordTypeID = :autoRecId and Inst_Sale_Opp__c = null and Id in :ids];
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
        
        //List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where Id in :pIds];
        //List<ChargentSFA__Transaction__c> trs = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :pIds];
        
        rd.refunds = prs; 
        rd.opps = pdes;
        rd.trans = tres;
        
        return rd ;
    }     
    
    
    @RemoteAction
    public static rptData getReportDataTrans(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        rd.trans = tres;
        
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataOpp(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        List<Opportunity> pdes;
        pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
        
        rd.opps = pdes;
        
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataRefunds(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
        
        rd.refunds = prs;
        
        return rd ;
    }         
    
    @RemoteAction
    public static rptData getReportDataTransFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds, Boolean teamReg) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day());
        
        system.debug('* * * getReportDataTransFilters Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
                
        if(teamReg) {
            List<Opportunity> pdes;
            if(!GARP && !GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'                               
                       ];
            else if(GARP && !GRA && !NJ)    
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GARP' and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
                
            else if(!GARP && GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GRA'and Team_Registration__c != NULL  AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(!GARP && !GRA && NJ) 
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey')  and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'                             
                       ];
            
            else if(GARP && GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and (Company__c = 'GARP' OR Company__c = 'GRA')  and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(GARP && !GRA && NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GARP' AND (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(!GARP && GRA && NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate  and Company__c = 'GRA' AND (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            system.debug('pdes:' + pdes);
            
            List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
            MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
            for(Opportunity opp :pdes) {
                for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                    
                    Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                    
                    system.debug('fndId:' + fndId);
                    
                    if(fndId != null || filterProdIds == null) {
                        fndOpp.put(opp.Id,Opp);
                    }                
                }
            }
            for(Opportunity opp :fndOpp.values()) {           
                ChargentSFA__Transaction__c newTrans = new ChargentSFA__Transaction__c(
                    ChargentSFA__Gateway_ID__c=opp.Id, ChargentSFA__Tokenization__c=opp.Id, ChargentSFA__Opportunity__c=opp.Id, ChargentSFA__Amount__c=opp.Amount, ChargentSFA__Gateway_Date__c=opp.CloseDate, ChargentSFA__Type__c='Credit', ChargentSFA__Response_Status__c='Approved', ChargentSFA__Payment_Method__c='Credit Card', ChargentSFA__Gateway_Response__c='PNREF='+opp.Id);
                finalTrans.add(newTrans);
            }
            rd.trans = finalTrans;
            
        } else {
            
            if(!GARP && !GRA && !NJ)
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && !GRA && !NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && GRA && !NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && !GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && GRA && !NJ)
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP') AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && !GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            
            List<Id> ids = new List<Id>();
            List<Id> transIds = new List<Id>();
            if(tres != null) {
                for(ChargentSFA__Transaction__c t :tres) {
                    ids.add(t.ChargentSFA__Opportunity__c);
                    transIds.add(t.Id);
                }        
                
                if(filterProdIds != null) {
                    List<Opportunity> pdes;
                    List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                    MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                    pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                    for(Opportunity opp :pdes) {
                        for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                            
                            //system.debug('oli:' + oli + ':' + oli.Product2Id);
                            //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                            Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                            
                            system.debug('fndId:' + fndId);
                            
                            if(fndId != null) {
                                fndOpp.put(opp.Id,Opp);
                            }                
                        }
                    }
                    
                    system.debug('fndOpp:' + fndOpp);
                    
                    for(ChargentSFA__Transaction__c t :tres) {
                        Opportunity fnd = fndOpp.get(t.ChargentSFA__Opportunity__c);
                        if(fnd != null)
                            finalTrans.add(t);
                    }
                    
                    system.debug('finalTrans:' + finalTrans);
                    
                    rd.trans = finalTrans;
                } else {
                    rd.trans = tres;            
                }
                
            }
            
            
        }

        
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataOppFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds, Boolean teamReg) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day());
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {                
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(teamReg) {
            List<Opportunity> pdes;
            if(!GARP && !GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            else if(GARP && !GRA && !NJ)    
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GARP' and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(!GARP && GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GRA' and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(!GARP && !GRA && NJ) 
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(GARP && GRA && !NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and (Company__c = 'GARP' OR Company__c = 'GRA') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(GARP && !GRA && NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate and Company__c = 'GARP' AND (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            else if(!GARP && GRA && NJ)
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity
                        where  CloseDate >= :stDate and CloseDate <= :edDate  and Company__c = 'GRA' AND (Shipping_State__c = 'NJ' or Shipping_State__c = 'New Jersey') and Team_Registration__c != NULL AND ChargentSFA__Payment_Method__c != 'Free'
                       ];
            
            system.debug('pdes:' + pdes);
            
            List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
            MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
            for(Opportunity opp :pdes) {
                for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                    
                    Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                    
                    system.debug('fndId:' + fndId);
                    
                    if(fndId != null || filterProdIds == null) {
                        fndOpp.put(opp.Id,Opp);
                    }                
                }
            }
            rd.opps = fndOpp.Values();
            
        } else {
            
            if(!GARP && !GRA && !NJ)
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && !GRA && !NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && GRA && !NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && !GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && GRA && !NJ)
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP') AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(GARP && !GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            else if(!GARP && GRA && NJ)    
                tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Opportunity__r.Team_Registration__c = NULL AND ChargentSFA__Payment_Method__c != 'Free'];
            
            List<Id> ids = new List<Id>();
            List<Id> transIds = new List<Id>();
            if(tres != null) {
                for(ChargentSFA__Transaction__c t :tres) {
                    ids.add(t.ChargentSFA__Opportunity__c);
                    transIds.add(t.Id);
                }        
                
                if(filterProdIds != null) {
                    List<Opportunity> pdes;
                    List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                    MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                    pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                    for(Opportunity opp :pdes) {
                        for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                            
                            //system.debug('oli:' + oli + ':' + oli.Product2Id);
                            //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                            Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                            
                            system.debug('fndId:' + fndId);
                            
                            if(fndId != null) {
                                fndOpp.put(opp.Id,Opp);
                            }                
                        }
                    }
                    
                    system.debug('fndOpp:' + fndOpp);
                    
                    rd.opps = fndOpp.Values();
                } else {
                    List<Opportunity> pdes;
                    pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                    
                    rd.opps = pdes;            
                }
                
            }
        }
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataRefundsFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds, Boolean teamReg) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day());
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {                
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP') AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP' AND ChargentSFA__Payment_Method__c != 'Free'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA' AND ChargentSFA__Payment_Method__c != 'Free'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null && teamReg == False) {
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
            
            if(filterProdIds != null) {
                List<Opportunity> pdes;
                List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                for(Opportunity opp :pdes) {
                    for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                        
                        //system.debug('oli:' + oli + ':' + oli.Product2Id);
                        //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                        Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                        
                        system.debug('fndId:' + fndId);
                        
                        if(fndId != null) {
                            fndOpp.put(opp.Id,Opp);
                        }                
                    }
                }
                
                system.debug('fndOpp:' + fndOpp);
                
                List<Id> finalTransIds = new List<Id>();                
                for(ChargentSFA__Transaction__c t :tres) {
                    Opportunity fnd = fndOpp.get(t.ChargentSFA__Opportunity__c);
                    if(fnd != null)
                        finalTransIds.add(t.Id);
                }
                
                system.debug('finalTrans:' + finalTransIds);
                
                List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :finalTransIds];
                rd.refunds = prs;
                
            } else {
                List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
                rd.refunds = prs;
            }
            
        }
        
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getRefunds(String startDate,String endDate) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);
        
        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();
        
        List<ChargentSFA__Transaction__c> tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        List<Id> ids = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
            }        
        
        List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id FROM OpportunityLineItems) from Opportunity where Id in :ids];
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids];
        
        //List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where Id in :pIds];
        //List<ChargentSFA__Transaction__c> trs = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :pIds];
        
        rd.refunds = prs; 
        rd.opps = pdes;
        rd.trans = tres;
        
        return rd ;
    }     
    
    @RemoteAction
    public static List<PriceBookEntry> getProducts(String priceBookId) {
        
        List<PriceBookEntry> pdes = [select Id, Name, Product2.RPT_Sort_Order__c, Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.Company__c, Product2.ProductCode, Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Product2.FRM_1_Book__c, Product2.FRM_2_Book__c, Product2.ERP_Study_Center__c, Product2.FBR_Study_Center__c, Product2.ICBRR_Study_Center__c, pricebook2.IsActive, UnitPrice, UseStandardPrice from PriceBookEntry where Pricebook2.Id = :priceBookId order by Product2.RPT_Sort_Order__c];
        return pdes ;
    }     
    
}