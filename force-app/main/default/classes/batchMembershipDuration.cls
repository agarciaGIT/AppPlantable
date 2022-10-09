global class batchMembershipDuration implements Database.Batchable<sObject>{
    
    public Integer year;  
    public String mode;  
    
    global batchMembershipDuration(Integer year, String mode){
        this.year = year;
        this.mode= mode;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        String mtype = 'Individual';
        String payStat = 'In Good Standing';
        String strNull = '%' + 'null' + '%';
        if(mode == 'batch') {
            return Database.getQueryLocator('select Id, Name, AccountID, KPI_Membership_Business_Type__c, KPI_Current_Exam_Registration__c, KPI_Current_Exam_Date__c, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified_Date__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c = null AND Batch__c = True');    
        } else if(mode == 'reset') {
            //return Database.getQueryLocator('select Id, Name, AccountID, KPI_Membership_Business_Type__c, KPI_Current_Exam_Registration__c, KPI_Current_Exam_Date__c, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified_Date__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c like :strNull');    
            return Database.getQueryLocator('select Id, Name, AccountID, KPI_Membership_Business_Type__c, KPI_Current_Exam_Registration__c, KPI_Current_Exam_Date__c, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified_Date__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c != null');
        } else if(mode != null && mode != 'batch') {
            return Database.getQueryLocator('select Id, Name, AccountID, KPI_Membership_Business_Type__c, KPI_Current_Exam_Registration__c, KPI_Current_Exam_Date__c, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified_Date__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c = null AND Id = :mode');    
        } else {
            return Database.getQueryLocator('select Id, Name, AccountID, KPI_Membership_Business_Type__c, KPI_Current_Exam_Registration__c, KPI_Current_Exam_Date__c, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified_Date__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c = null');
        }
        

    }    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){


        if(mode == 'reset') {
            for(Contact c :scope) {
               c.Membership_2015_Status__c=null;
               c.Membership_2016_Status__c=null;
               c.Membership_2017_Status__c=null;
               c.Membership_2018_Status__c=null;      
               c.Membership_Status_By_Year__c=null;
               c.Membership_Duration__c=null;                                       
            }
            update scope;        
        
        } else {

            MAP<String, String> mapContAcct = new MAP<String, String>();
            MAP<String, String> mapContExam = new MAP<String, String>();
            for(Contact c :scope) {
                mapContAcct.put(c.Id, c.AccountID);
                if(c.KPI_Membership_Business_Type__c != NULL) {
                    mapContExam.put(c.AccountID,c.KPI_Membership_Business_Type__c);
                } else {
                    if(c.KPI_Current_Exam_Registration__c != NULL || c.KPI_Current_Exam_Date__c != NULL) {
                        mapContExam.put(c.AccountID,'Individual New Comp');
                    }
	            }
                   
            }
        
            String membershipContractId = recordtypehelper.getRecordtypeID('Contract','Membership');
            List<Contract> lstIndvContracts = [select AccountId, Account_Country__c, Opp_Member_Type__c, StartDate, EndDate, Opp_Mem_Is_Certified__c from Contract where Status != 'Canceled' AND Status != 'Draft' AND Membership_Type__c = 'Individual' AND ContractTerm != NULL AND RecordTypeId=:membershipContractId AND AccountId in :mapContAcct.Values() Order by StartDate];
    
            List<Opportunity> lstOpps = [select Id, AccountId, Member_Status__c, CloseDate from Opportunity where (StageName = 'Closed' OR StageName = 'Close Won') AND Member_Status__c != NULL AND AccountId in :mapContAcct.Values() Order by CloseDate];
            if(test.isRunningTest()){
            	system.debug('lstOpps:' + lstOpps);
            }
            
            MAP<String, LIST<Contract>> mapCont = new MAP<String, LIST<Contract>>();
            MAP<String, LIST<Opportunity>> mapAcctOpp = new MAP<String, LIST<Opportunity>>();
            
            for(Contract c :lstIndvContracts) {                
                LIST<Contract> lstCont = mapCont.get(c.AccountId);
                if(lstCont==null) {
                    LIST<Contract> newLstCont = new LIST<Contract>();
                    newLstCont.add(c);
                    mapCont.put(c.AccountId,newLstCont);
                } else {
                    lstCont.add(c);
                    mapCont.put(c.AccountId,lstCont);
                }
            }
            system.debug('mapCont:' + mapCont);
            
            for(Opportunity o :lstOpps) {                
                LIST<Opportunity> lstOpp = mapAcctOpp.get(o.AccountId);
                if(lstOpp==null) {
                    LIST<Opportunity> newLstOpp = new LIST<Opportunity>();
                    newLstOpp.add(o);
                    mapAcctOpp.put(o.AccountId,newLstOpp);
                } else {
                    lstOpp.add(o);
                    mapAcctOpp.put(o.AccountId,lstOpp);
                }
            }
            system.debug('mapAcctOpp:' + mapAcctOpp);

            
            for(Contact c :scope) {
                
                System.debug('Cont~' + c);            
                LIST<Contract> lstCont = mapCont.get(c.AccountId);
                if(lstCont!=null) {
                    
                    System.debug('lstCont Found~' + lstCont);
                    
                    String contYearStatus='';    
                    Integer totalDuration=0;
                    Integer totalPayDuration=0;
                    Integer lastYear=null;
                    String prevStatus;
                    for(Contract ct :lstCont) {                                                            
                        
                        System.Debug('ct:' + ct);
                        
                        Integer monthDiff = ct.StartDate.monthsBetween(ct.EndDate);
                        system.debug('monthDiff: ' + monthDiff);
                        totalDuration+=monthDiff;
                        System.Debug('totalDuration:' + totalDuration);
                    
                        if(lastYear != NULL) {
                            Integer cntYear = lastYear;
                            while(cntYear <= ct.StartDate.year()) {
                                Date thisYear = date.parse('12/31/' + String.ValueOf(cntYear));
                                System.Debug('thisYear Lapsed:' + thisYear);

                                Boolean frmCert = false;
                                Boolean erpCert = false;
                                if(c.KPI_FRM_Certified_Date__c != NULL && c.KPI_FRM_Certified_Date__c <= thisYear) {
                                    frmCert = true;
                                }
                                if(c.KPI_ERP_Certified_Date__c != NULL && c.KPI_ERP_Certified_Date__c <= thisYear) {
                                    erpCert = true;
                                }
                                String cert = 'Non-Certified';
                                if(frmCert && erpCert) {
                                    cert = 'Certified Dual FRM/ERP';
                                } else if(frmCert) {
                                    cert = 'Certified FRM';
                                } else if(erpCert) {
                                    cert = 'Certified ERP';
                                }
                                System.debug('cert~' + cert);

                                                                
                                if(thisYear >= ct.StartDate && thisYear <= ct.EndDate) {
                                } else {
                                    if(prevStatus==NULL) {

                                        List<Opportunity> lstOpp = mapAcctOpp.get(ct.AccountId);
                                        System.debug('lstOpp~' + lstOpp);
                                        
                                        String oppMemberType;
                                        if(lstOpp != NULL && lstOpp.size() > 0) {
                                            Opportunity lastOpp=null;
                                            for(Opportunity opp :lstOpp) {
                                                if(opp.CloseDate <= thisYear)   
                                                    lastOpp=opp;
                                            }
                                            System.debug('lastOpp~' + lastOpp);
                                            if(lastOpp!=null)
                                                oppMemberType = lastOpp.Member_Status__c;
                                        }
                                        prevStatus = oppMemberType;
                                    }
                                    
                                    
                                    contYearStatus+= '~' + String.ValueOf(cntYear) + ':' + prevStatus + '^' + 'Lapsed' + '^' + cert;
                                    if(contYearStatus.length() > 255)
                                        contYearStatus = contYearStatus.Right(255);
                                    if(cntYear == 2015)
                                        c.Membership_2015_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                                    if(cntYear == 2016)
                                        c.Membership_2016_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                                    if(cntYear == 2017)
                                        c.Membership_2017_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                                    if(cntYear == 2018)
                                        c.Membership_2018_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                                }
                                cntYear++;
                            }
                            lastYear = cntYear-1;                        
                        }
                        
                        Integer cntYear = ct.StartDate.year();
                        Boolean hadMembership=false;
                        while(cntYear <= ct.EndDate.year()) {
                            Date thisYear = date.parse('12/31/' + String.ValueOf(cntYear));
                            System.Debug('thisYear:' + thisYear);
                            
                            Boolean frmCert = false;
                            Boolean erpCert = false;
                            if(c.KPI_FRM_Certified_Date__c != NULL && c.KPI_FRM_Certified_Date__c <= thisYear) {
                                frmCert = true;
                            }
                            if(c.KPI_ERP_Certified_Date__c != NULL && c.KPI_ERP_Certified_Date__c <= thisYear) {
                                erpCert = true;
                            }
                            String cert = 'Non-Certified';
                            if(frmCert && erpCert) {
                                cert = 'Certified Dual FRM/ERP';
                            } else if(frmCert) {
                                cert = 'Certified FRM';
                            } else if(erpCert) {
                                cert = 'Certified ERP';
                            }
                            System.debug('cert~' + cert);
                            
                            
                            if(thisYear >= ct.StartDate && thisYear <= ct.EndDate) { 
                                
                                System.debug('Year in Contract~' + ct);
                                hadMembership=true;
                                
                                List<Opportunity> lstOpp = mapAcctOpp.get(ct.AccountId);
                                System.debug('lstOpp~' + lstOpp);
                                
                                String oppMemberType;
                                if(ct.Opp_Member_Type__c != null)
                                    oppMemberType = ct.Opp_Member_Type__c;
                                else oppMemberType = 'Unknown';
                                
                                if(lstOpp != NULL && lstOpp.size() > 0) {
                                    Opportunity lastOpp=null;
                                    for(Opportunity opp :lstOpp) {
                                    	if(opp.CloseDate <= thisYear)   
                                            lastOpp=opp;
                                    }
                                    System.debug('lastOpp~' + lastOpp);
                                    if(lastOpp!=null)
                                        oppMemberType = lastOpp.Member_Status__c;
                                }
                                
                                if(oppMemberType.indexOf('Comp') == -1) {
                                    totalPayDuration+=12;
                                }
                                
                                contYearStatus+= '~' + String.ValueOf(cntYear) + ':' + oppMemberType + '^' + 'Good' + '^' + cert;
                                System.debug('contYearStatus~' + contYearStatus);
                                                            
                                if(contYearStatus.length() > 255)
                                    contYearStatus = contYearStatus.Right(255);
                                    
                                if(cntYear == 2015)
                                    c.Membership_2015_Status__c = oppMemberType + '^' + 'Good' + '^' + cert;
                                if(cntYear == 2016)
                                    c.Membership_2016_Status__c = oppMemberType + '^' + 'Good' + '^' + cert;
                                if(cntYear == 2017)
                                    c.Membership_2017_Status__c = oppMemberType + '^' + 'Good' + '^' + cert;
                                if(cntYear == 2018)
                                    c.Membership_2018_Status__c = oppMemberType + '^' + 'Good' + '^' + cert;
                                
                                prevStatus = oppMemberType;
                            }
                            cntYear++;
                            
                        }
                        if(hadMembership)
                        	lastYear = cntYear-1;
    
                    }
                    Integer cntYear = lastYear;
                    while(cntYear <= 2018) {
                        Date thisYear = date.parse('12/31/' + String.ValueOf(cntYear));
                    
                        Boolean frmCert = false;
                        Boolean erpCert = false;
                        if(c.KPI_FRM_Certified_Date__c != NULL && c.KPI_FRM_Certified_Date__c <= thisYear) {
                            frmCert = true;
                        }
                        if(c.KPI_ERP_Certified_Date__c != NULL && c.KPI_ERP_Certified_Date__c <= thisYear) {
                            erpCert = true;
                        }
                        String cert = 'Non-Certified';
                        if(frmCert && erpCert) {
                            cert = 'Certified Dual FRM/ERP';
                        } else if(frmCert) {
                            cert = 'Certified FRM';
                        } else if(erpCert) {
                            cert = 'Certified ERP';
                        }
                        System.debug('cert~' + cert);
                        
                        
                        
                        contYearStatus+= '~' + String.ValueOf(cntYear) + ':' + 'Lapsed' + '^' + cert;
                        if(contYearStatus.length() > 255)
                            contYearStatus = contYearStatus.Right(255);
                        if(cntYear == 2015)
                            c.Membership_2015_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                        if(cntYear == 2016)
                            c.Membership_2016_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                        if(cntYear == 2017)
                            c.Membership_2017_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                        if(cntYear == 2018)
                            c.Membership_2018_Status__c = prevStatus + '^' + 'Lapsed' + '^' + cert;
                        cntYear++;
                    }
                    c.Membership_Status_By_Year__c = contYearStatus;
                    c.Membership_Duration__c = totalDuration;
                    c.Membership_Paying_Diration__c = totalPayDuration;
                    System.debug('Update c~' + c);
                }
            }
            update scope;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}