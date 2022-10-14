public class contractSyncUtil {

    public static boolean bRecursive = false;
    public static boolean skipSyncTrigger = false;
    static id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
    static id FRMExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
    static id ERPExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
    static id ICBRRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
    static id FBRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FBR Program');
    static id WileyTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
    static id CPETypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'CPE');
    static id SCRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'SCR Program');
    static id RiskNetId = RecordTypeHelper.GetRecordTypeId('Contract', 'Risk.Net');

    static id progReqCPECredit = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');

    
    public class sortContracts implements Comparable {
        public Contract cont;
        
        public sortContracts(Contract c) {
            cont = c;
        }        
        
        // The rest of this code remains the same; add the following function:
        public Integer compareTo(Object o) {
            sortContracts scVal = (sortContracts)o;

            if(scVal.cont.StartDate < cont.StartDate) {
                return 1;
            } else if(scVal.cont.StartDate == cont.StartDate) {
                if(scVal.cont.recordTypeId == MembershipTypeId)
                    return 1;
                else return -1;
            } else {
                return -1;    
            }
        }
    }


    public static void updateContracts(List<id> lstIds) {

        Map < Id, Contract > mapAccountIds = new Map<Id, Contract>();
            
        List < Contact > lstActiveContacts = new List < Contact > ();
        MAP<Id, Opportunity> updateOppMap = new MAP<Id, Opportunity>();
        MAP<Id, Opportunity> currOppMap = new MAP<Id, Opportunity>();
        MAP<Id, Boolean> oppMapWasComped = new MAP<Id, Boolean>();
        MAP<Id, Integer> oppMapWasRenewCnt = new MAP<Id, Integer>();
        MAP<Id, Integer> oppMapWasAutoRenewCnt = new MAP<Id, Integer>();
        MAP<Id, Opportunity> oppMapOrig = new MAP<Id, Opportunity>();
        
        List<Contract> lstUpdateContracts = new List<Contract>();
        
        List < Contract > lstContract = [select Id, Name, AccountId, Account.Contract_Sync_Off__c, Status, Part_1_completed_date__c, Part_2_completed_date__c, RecordType.Name, KPI_Months_of_Membership__c, All_Requirements_Completed_Date__c, All_Requirements_Completed__c, Membership_Type__c, StartDate, EndDate, ActivatedDate, Opportunity__c, Opportunity__r.Program_Abbrev__c, recordTypeId, CustomerSignedId from Contract where accountId in : lstIds Order By StartDate];
        List < Opportunity > lstOpportunityEligible = [SELECT Id, Name, Amount, AccountId, GARP_Invoice_Number__c, FRM_Candidate_Status__c, ERP_Candidate_Status__c, Certification_Status__c, Original_Membership_Status__c, Was_Exam_Comped__c, ChargentSFA__Transaction_Count_Recurring__c, AutoRenewal_Count__c, Renewal_Count__c , Member_Status__c, Eligible_for_Membership_Extension__c, CloseDate, StageName, Display_Invoice_Number__c,
                (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name,
                PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems),
                FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c,
                Deferred_Exam_Registration__c, Chargent_Autorenewal_Count__c, Backup_Auto_Renewal_Count__c 
                FROM Opportunity where 
                AccountId in : lstIds and StageName like '%Close%' and StageName != 'Closed Lost'
            order by CloseDate, Last_Transaction_Paid_Date__c 
        ];
        
        system.debug('contractSyncUtil - lstContract: ' + lstContract);
                
        for(Opportunity opp: lstOpportunityEligible) {
            currOppMap.put(opp.Id, opp);
        }
        List < Product_Refunds__c > lstPr = [select Id, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId,
            Product__r.ProductCode, Product__r.Product_ID__c from Product_Refunds__c where
            Status__c = 'Completed'
            and Opportunity__c in : lstOpportunityEligible
        ];

        MAP < ID, List < Product_Refunds__c >> mapPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapExamRegPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapWileyPR = new MAP < ID, List < Product_Refunds__c >> ();
        
        for (Product_Refunds__c pr: lstPr) {

            if (pr.Product__r.ProductCode == 'MEMW' ||
                pr.Product__r.Product_ID__c == '1147') {
                    
                List < Product_Refunds__c > lst = mapWileyPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapWileyPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapWileyPR.put(pr.Opportunity__c, lst);
                }
                    
            }
                
                
            if (pr.Product__r.ProductCode == '208' ||
                pr.Product__r.ProductCode == '7' ||
                pr.Product__r.ProductCode == '207' ||
                pr.Product__r.ProductCode == '1129' ||
                pr.Product__r.ProductCode == '4' ||
                pr.Product__r.ProductCode == '944' ||
                pr.Product__r.ProductCode == 'MEMS' ||
                pr.Product__r.ProductCode == 'MEMI' ||
                pr.Product__r.ProductCode == 'MEMC' ||
                pr.Product__r.ProductCode == '395' ||
                pr.Product__r.ProductCode == 'MEMF' ||
                pr.Product__r.Product_ID__c == '181' ||
                pr.Product__r.Product_ID__c == '209' ||
                pr.Product__r.Product_ID__c == '5' ||
                pr.Product__r.Product_ID__c == '6') {

                List < Product_Refunds__c > lst = mapPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapPR.put(pr.Opportunity__c, lst);
                }
            }
            
            if (pr.Product__r.ProductCode == 'ENCL' ||
                pr.Product__r.ProductCode == 'ENCE' ||
                pr.Product__r.ProductCode == 'ENCS' ||
                pr.Product__r.ProductCode == 'FRM1E' ||
                pr.Product__r.ProductCode == 'FRM1S' ||
                pr.Product__r.ProductCode == 'FRM1L' ||
                pr.Product__r.ProductCode == 'FRM2E' ||
                pr.Product__r.ProductCode == 'FRM2S' ||
                pr.Product__r.ProductCode == 'FRM2L' ||
                pr.Product__r.Product_ID__c == '1155' ||
                pr.Product__r.Product_ID__c == '1156') {

                List < Product_Refunds__c > lst = mapExamRegPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, lst);
                }
            }            
            
        }
        List < Candidate_Requirement__c > lstCandidateRequirement = [select Id, Name, RecordTypeID, Status__c, Certificate_Sent_Date__c, Date_of_Failed_Review__c, Date_of_Ready_for_Review__c, Date_of_Completion__c, Approved_Credits_Total__c, Candidate_Commitment__c, Approved_Credits__c, Candidate_Commitment__r.StartDate from Candidate_Requirement__c where Candidate_Commitment__c in : lstContract];



        List < Contact > lstContacts = new List < Contact > ();
        MAP <String,Boolean> mapContactActive = new MAP <String,Boolean>();
        for (Contact objContact: [select id, KPI_Member__c, Membership_Type__c, CVent_Contact_Type__c, KPI_Membership_Since__c,
                KPI_Membership_Expiration_Date__c, KPI_Membership_Payment_Lapsed_Months__c, KPI_Membership_Payment_Status__c,
                KPI_Membership_Source__c, KPI_Membership_Original_Business_Type__c, KPI_Membership_Renewal_Type__c,
                KPI_Membership_Business_Type__c, KPI_Membership_Renewal_Count__c, KPI_Membership_Original_Type__c,
                KPI_Membership_Renew_Count__c, KPI_Membership_Comp_Count__c,
                KPI_Membership_Converted_Exam_Comp__c,KPI_Membership_Converted_Affiliate__c,
                KPI_Membership_Renewal_Date__c, Membership_Last_Contract_Start_Date__c, KPI_Membership_Purchase_History__c,
                KPI_Membership_Contract_History__c, Membership_Caluclated_Expiration_Date__c,
                                  
                KPI_FRM_Resume_Status__c, KPI_FRM_Resume_Status_Date__c, KPI_FRM_Resume_Certificate_Sent_Date__c, KPI_FRM_Resume_Submission_Date__c,
                KPI_ERP_Resume_Status__c, KPI_ERP_Resume_Status_Date__c, KPI_ERP_Resume_Certificate_Sent_Date__c, KPI_ERP_Resume_Submission_Date__c,

                KPI_FRM_Resume_Program_Requirement_ID__c, KPI_ERP_Resume_Program_Requirement_ID__c,
                KPI_FRM_Certified_Date__c, KPI_FRM_Certified_Year__c, KPI_FRM_Certified__c, KPI_FRM_Candidate__c,
                KPI_FRM_Holder__c, KPI_FRM_Candidate_Payment_Lapsed_Months__c, KPI_FRM_Candidate_Payment_Status__c,

                KPI_FRM_Candidate_Business_Type__c, KPI_ERP_Certified_Date__c, KPI_ERP_Certified_Year__c,

                KPI_FRM_Program_Start_Date__c, KPI_FRM_Program_Expiration_Date__c, KPI_ERP_Program_Start_Date__c, KPI_ERP_Program_Expiration_Date__c,

                KPI_ERP_Certified__c, KPI_ERP_Candidate__c, KPI_ERP_Holder__c, KPI_ERP_Candidate_Payment_Lapsed_Months__c,
                KPI_ERP_Candidate_Payment_Status__c, KPI_ERP_Candidate_Business_Type__c, KPI_ICBRR_Participant__c,FRR_Participant__c,
                KPI_FBR_Participant__c, KPI_CPE_Participation__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Credits__c,
                KPI_CPE_Last_Completed_Cycle__c, KPI_CPE_Requirement_Status__c, CPE_Current_Program_Requirement__c, accountId,
                
                KPI_SCR_Candidate__c, KPI_SCR_Holder__c, KPI_SCR_Completion_Date__c,
                
                KPI_Wiley__c, KPI_Wiley_Business_Type__c, KPI_Wiley_Join_Date__c, KPI_Wiley_Payment_Status__c, Date_Joined__c,              
                Email_Member_Update__c, MailingCountry from contact where accountId in : lstIds
            ]) {
            
            objContact.KPI_SCR_Candidate__c = false;
            objContact.KPI_SCR_Holder__c = false;
            objContact.KPI_SCR_Completion_Date__c = null;    
            
            objContact.KPI_FRM_Resume_Program_Requirement_ID__c = null;
            objContact.KPI_ERP_Resume_Program_Requirement_ID__c = null;
            objContact.KPI_FRM_Program_Start_Date__c = null;
            objContact.KPI_FRM_Program_Expiration_Date__c = null;
            objContact.KPI_ERP_Program_Start_Date__c = null;
            objContact.KPI_ERP_Program_Expiration_Date__c = null;
            objContact.KPI_FRM_Certified_Date__c = null;
            objContact.KPI_FRM_Certified_Member_Status__c = null;
                    
            objContact.KPI_FRM_Certified_Year__c = null;
            objContact.KPI_FRM_Certified__c = false;
            objContact.KPI_FRM_Candidate__c = false;
            objContact.KPI_FRM_Holder__c = false;
            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
            objContact.KPI_FRM_Candidate_Payment_Status__c = null;
            objContact.KPI_FRM_Candidate_Business_Type__c = null;

            objContact.KPI_ERP_Certified_Date__c = null;
            objContact.KPI_ERP_Certified_Year__c = null;
            objContact.KPI_ERP_Certified__c = false;
            objContact.KPI_ERP_Certified_Member_Status__c = null;
                
            objContact.KPI_ERP_Candidate__c = false;
            objContact.KPI_ERP_Holder__c = false;
            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
            objContact.KPI_ERP_Candidate_Payment_Status__c = null;
            objContact.KPI_ERP_Candidate_Business_Type__c = null;

            objContact.KPI_ICBRR_Participant__c = false;
            objContact.FRR_Participant__c = false;
            //objContact.KPI_ICBRR_Result__c = null;
            objContact.KPI_FBR_Participant__c = false;

            objContact.KPI_CPE_Participation__c = false;
            objContact.KPI_CPE_Current_Cycle__c = null;
            objContact.CPE_Last_Cycle__c = null;
            objContact.KPI_CPE_Credits__c = null;
            objContact.KPI_CPE_Last_Completed_Cycle__c = null;
            objContact.KPI_CPE_Requirement_Status__c = null;
            objContact.CPE_Current_Program_Requirement__c = null;
     
            objContact.KPI_Wiley__c = false;
            objContact.KPI_Wiley_Business_Type__c = null;
            objContact.KPI_Wiley_Join_Date__c = null;
            objContact.KPI_Wiley_Payment_Status__c = null;
              
            objContact.KPI_Member__c = false;
            objContact.Membership_Type__c = 'Affiliate';
            objContact.CVent_Contact_Type__c = 'Non-Member';
            objContact.KPI_Membership_Since__c = null;
            objContact.KPI_Membership_Expiration_Date__c = null;
            objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
            objContact.KPI_Membership_Payment_Status__c = null;
            objContact.KPI_Membership_Source__c = null;
            objContact.KPI_Membership_Original_Business_Type__c = null;
            objContact.KPI_Membership_Original_Source__c = null;
            objContact.KPI_Membership_Renewal_Type__c = null;
            objContact.KPI_Membership_Business_Type__c = null;
                
            objContact.KPI_Membership_Renewal_Count__c = null;
            objContact.KPI_Membership_Comp_Count__c = NULL;
            objContact.KPI_Membership_Renew_Count__c = NULL;
            objContact.KPI_Membership_Converted_Exam_Comp__c = false;
            objContact.KPI_Membership_Converted_Affiliate__c = false;
            objContact.KPI_Membership_Converted_Date__c = null;
                
            objContact.KPI_Membership_Renewal_Date__c = null;
            objContact.KPI_Membership_Original_Type__c = null;
            objContact.Membership_Last_Contract_Start_Date__c = null;

            objContact.KPI_FRM_Resume_Status__c = null;
            objContact.KPI_FRM_Resume_Status_Date__c = null;
            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = null;
            objContact.KPI_FRM_Resume_Submission_Date__c = null;

            objContact.KPI_ERP_Resume_Status__c = null;
            objContact.KPI_ERP_Resume_Status_Date__c = null;
            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = null;
            objContact.KPI_ERP_Resume_Submission_Date__c = null;
            objContact.KPI_Membership_Purchase_History__c = null;
            objContact.KPI_Membership_Contract_History__c = null;
                
            objContact.Email_Member_Update__c = false;
            objContact.Date_Joined__c = null;

            Map<String,String> abbrevMap = new Map<String,String>();
            abbrevMap.put('Individual','Indv');
            abbrevMap.put('Student','Stud');
            abbrevMap.put('Affiliate','Aff');
            abbrevMap.put('Expired','Exp');
            abbrevMap.put('Canceled','Can');
           abbrevMap.put('MEMI','Individual');
           abbrevMap.put('MEMC','Individual');
           abbrevMap.put('MEMF','Individual');                   
           abbrevMap.put('MEMS','Student');
           abbrevMap.put('AFREE','Affiliate');

                
           Map<String,String> statusMap = new Map<String,String>();
           statusMap.put('MEMI','Individual');
           statusMap.put('MEMC','Individual');
           statusMap.put('MEMF','Individual');                   
           statusMap.put('MEMS','Student');
           statusMap.put('AFREE','Affiliate');

           
            List < Contract > contracts = new List < Contract > ();
            Date firstFrmProgStartDate;
            Date firstErpProgStartDate;
            String renewStatusLevel = '';
            Boolean userComp = false;
            Boolean userPay = false;
            Integer renewalCount = 0;
            String lastUserType = '';
            Integer frmCnt = 0;
            Integer frmCanceledCnt = 0;
            Integer erpCnt = 0;
            Integer erpCanceledCnt = 0;
            Integer memCnt = 0;
            Contract lastContract = null;
            Contract thisContract = null;
            Contract firstMemberContract = null;
            Contract lastMemberContract = null;
            Date memberSinceContract = null;
            Date nowDateTime = date.today();
            //Datetime contractStartDateTime;
            //Datetime contractEndDateTime;
                
            Map<ID,ID> acctOppMap = new Map<ID,ID>();
            // Contracts are in Start Date Order!!
            // Order them by type also
            List< sortContracts > sortedContracts = new List< sortContracts >();
            for(Contract con: lstContract) {
                sortContracts sc = new sortContracts(con);
                sortedContracts.add(sc);
            }
            sortedContracts.sort();
            system.debug('!! sortedContracts:'+sortedContracts);
                
            Integer numberOfMonthsAsMember = 0;
                
            Date frmPart1CompleteDate;
            Date frmPart2CompleteDate;

            Date erpPart1CompleteDate;
            Date erpPart2CompleteDate;
                
                
            for (sortContracts conS: sortedContracts) {
                
                Contract con = conS.cont;
                
                system.debug('* * * Core con:'+con);
                
                
                if (objContact.accountId != con.AccountId)
                    continue;
                    
                    
                system.debug('* * *Contract_Sync_Off__c :'+con.Account.Contract_Sync_Off__c);
                if(con.Account.Contract_Sync_Off__c == True) {
                    system.debug('* * * SKIP!');
                    continue;
                }
                
                Boolean foundDupe = false;
                for (Contact conLook: lstContacts) {
                    if (conLook.Id == objContact.Id) {
                        foundDupe = true;
                        break;
                    }
                }
                if (foundDupe)
                    continue;
            
                if (con.recordTypeId == MembershipTypeId)
                    thisContract = con;

                Boolean currentCPE = false;

                Boolean fndActiveContract = mapContactActive.get(objContact.Id);
                
                if (con.status.indexof('Canceled') > -1 && fndActiveContract == NULL) {
                    
                    system.debug('* * * Core Canceled1:'+con);
                    

                    if (con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId) {
                        if (con.recordTypeId == FRMExamTypeId) {
                            frmCanceledCnt++;
                            objContact.KPI_FRM_Certified_Date__c = null;
                            objContact.KPI_FRM_Certified_Member_Status__c = null;
                            objContact.KPI_FRM_Certified_Year__c = null;
                            objContact.KPI_FRM_Certified__c = false;
                            objContact.KPI_FRM_Candidate__c = false;
                            objContact.KPI_FRM_Holder__c = false;
                            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                            objContact.KPI_FRM_Resume_Status__c = null;
                            objContact.KPI_FRM_Resume_Status_Date__c = null;
                            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = null;
                            objContact.KPI_FRM_Resume_Submission_Date__c = null;
                            objContact.KPI_FRM_Candidate_Business_Type__c = null;
                        }
                        if (con.recordTypeId == ERPExamTypeId) {
                            erpCanceledCnt++;
                            objContact.KPI_ERP_Certified_Date__c = null;
                            objContact.KPI_ERP_Certified_Member_Status__c = null;
                            objContact.KPI_ERP_Certified_Year__c = null;
                            objContact.KPI_ERP_Certified__c = false;
                            objContact.KPI_ERP_Candidate__c = false;
                            objContact.KPI_ERP_Holder__c = false;
                            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                            objContact.KPI_ERP_Resume_Status__c = null;
                            objContact.KPI_ERP_Resume_Status_Date__c = null;
                            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = null;
                            objContact.KPI_ERP_Resume_Submission_Date__c = null;
                            objContact.KPI_ERP_Candidate_Business_Type__c = null;
                        }
                    }
                    if (con.recordTypeId == CPETypeId) {
                        Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                        for (Candidate_Requirement__c cr: lstCandidateRequirement) {
                            if (cr.Candidate_Commitment__c == con.Id) {
                                if (cr.Name == 'CPE') {
                                    objContact.KPI_CPE_Requirement_Status__c = 'Pending';
                                    if (cr.Status__c == 'Completed') {
                                        objContact.KPI_CPE_Last_Completed_Cycle__c = String.valueOf(cr.Candidate_Commitment__r.StartDate.year()) + '/' + String.valueOf(cr.Candidate_Commitment__r.StartDate.year() + 1);
                                        if ((cr.Candidate_Commitment__r.StartDate.year() + 2) == Date.today().year() || (cr.Candidate_Commitment__r.StartDate.year() + 3) == Date.today().year()) {
                                            lastCR = cr;
                                            objContact.KPI_CPE_Requirement_Status__c = 'In Good Standing';
                                        }
                                    }
                                }
                            }
                        }
                        if (lastCR != null && lastCR.Status__c != 'Completed') {
                            objContact.KPI_CPE_Requirement_Status__c = 'Lapsed';
                        }
                    }
                } else {
                    mapContactActive.put(objContact.Id, True);
                }
                
            

                
                // To get the FRM program start date (Start date of the first FRM program)
                if (con.recordTypeId == FRMExamTypeId && (con.status.indexof('Activated') > -1 || con.status.indexof('Expired') > -1 || con.status.indexof('Completed') > -1))
                {
                    
                    if(firstFrmProgStartDate == NULL || con.StartDate <= firstFrmProgStartDate )
                    {
                        system.debug('* * * Contract Status is:'+con.status); 
                        firstFrmProgStartDate = con.StartDate;                        
                    }
                    
                    system.debug('* * * First FRM Start Date:'+firstFrmProgStartDate); 
                    objContact.KPI_FRM_Program_Start_Date__c = firstFrmProgStartDate;
                    
                    //System.assert(false, 'BOOM!!!!' + objContact.KPI_FRM_Program_Start_Date__c);      
                }
                
                
                // To get the ERP program start date (Start date of the first ERP program)
                if (con.recordTypeId == ERPExamTypeId && (con.status.indexof('Activated') > -1 || con.status.indexof('Expired') > -1 || con.status.indexof('Completed') > -1))
                {
                    
                    if(firstErpProgStartDate == NULL || con.StartDate <= firstErpProgStartDate )
                    {
                        system.debug('* * * Contract Status is:'+con.status); 
                        firstErpProgStartDate = con.StartDate;                        
                    }
                    
                    system.debug('* * * First ERP Start Date:'+firstErpProgStartDate); 
                    objContact.KPI_ERP_Program_Start_Date__c = firstErpProgStartDate;
                    
                }
                
                
                 if (con.status.indexof('Expired') > -1 && con.recordTypeId == FRMExamTypeId)
                        {
                            system.debug('********Expired ');
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.EndDate;
                            objContact.KPI_FRM_Candidate_Payment_Status__c = 'Lapsed';                            
                        }
                
                if (con.status.indexof('Expired') > -1 && con.recordTypeId == ERPExamTypeId)
                        {
                            system.debug('********Expired ');
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.EndDate;
                            objContact.KPI_ERP_Candidate_Payment_Status__c = 'Lapsed';                            
                        }


                if (con.status.indexof('Expired') > -1 && con.recordTypeId == CPETypeId)
                {
                    if (con.StartDate != null) {
                        if(objContact.KPI_CPE_Current_Cycle__c != NULL) {
                            objContact.CPE_Last_Cycle__c = objContact.KPI_CPE_Current_Cycle__c;
                        }
                        objContact.KPI_CPE_Current_Cycle__c = String.valueOf(con.StartDate.year()) + '/' + String.valueOf(con.StartDate.year() + 1);
                        if (con.StartDate.year() <= Date.today().year()) {
                            objContact.KPI_CPE_Participation__c = true;
                        }
                    }
                }
                
                
                // Active Contracts            
                if (con.status.indexof('Activated') > -1 || con.status.indexof('Completed') > -1) {

                    system.debug('* * * Active or Completed Contract2:'+con);

                    //if (con.recordTypeId == WileyTypeId) {
                    //    system.debug('* * * Wiley:' + con.Membership_Type__c);
                    //    objContact.KPI_J_Wiley__c = true;
                    //}


                    if (con.recordTypeId == CPETypeId) {
                        currentCPE = true;
                        if (con.StartDate != null) {
                            if(objContact.KPI_CPE_Current_Cycle__c != NULL) {
                                objContact.CPE_Last_Cycle__c = objContact.KPI_CPE_Current_Cycle__c;
                            }
                            objContact.KPI_CPE_Current_Cycle__c = String.valueOf(con.StartDate.year()) + '/' + String.valueOf(con.StartDate.year() + 1);
                            if (con.StartDate.year() <= Date.today().year()) {
                                objContact.KPI_CPE_Participation__c = true;
                            }
                        }
                    }

                    if (con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId || con.recordTypeId == CPETypeId || con.recordTypeId == SCRExamTypeId) {

                        system.debug('* * * FRM/ERP:' + con.All_Requirements_Completed__c);

                        Date lastDate = null;
                        Boolean passNotDone = false;
                        Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                        Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
                        Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');

                        for (Candidate_Requirement__c cr: lstCandidateRequirement) {

                            if (cr.Candidate_Commitment__c == con.Id) {

                                system.debug('* * * Candidate_Requirement__c?:' + cr.Name + ':' + cr.Id + ':' + cr.Candidate_Commitment__c + ':' + con.Id + ':' + cr.Name + ':' + cr.Status__c + ':' + cr.Date_of_Completion__c + ':' + cr.RecordTypeID);
                                //if(cr.Name.toLowerCase().indexof('pass') > -1 && cr.Status__c != 'Completed')
                                if (cr.RecordTypeID == examRecordTypeID && cr.Status__c != 'Completed')
                                    passNotDone = true;

                                if (cr.Status__c == 'Completed' && (lastDate == null || cr.Date_of_Completion__c >= lastDate)) {
                                    lastDate = cr.Date_of_Completion__c;
                                }

                                if(cr.recordTypeId == progReqCPECredit) {
                                    //System.assert(false, 'BOOM!!!!' + cr);                                
                                    if (currentCPE)
                                        objContact.CPE_Current_Program_Requirement__c = cr.Id;
                                    objContact.KPI_CPE_Credits__c = cr.Approved_Credits_Total__c;
                                }

                                if (cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == FRMExamTypeId) {

                                    objContact.KPI_FRM_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;
                                    system.debug('The submission date is ++++'+objContact.KPI_FRM_Resume_Submission_Date__c);
                                    if (cr.Status__c == 'Initial')
                                        objContact.KPI_FRM_Resume_Status__c = NULL;

                                    if (cr.Status__c == 'Ready For Review')
                                        objContact.KPI_FRM_Resume_Status__c = 'Waiting for Review';
                                    
                                    if (cr.Status__c == 'Failed Review')
                                        objContact.KPI_FRM_Resume_Status__c = 'Denied';

                                    if (cr.Status__c == 'Completed')
                                        objContact.KPI_FRM_Resume_Status__c = 'Approved';


                                    objContact.KPI_FRM_Resume_Program_Requirement_ID__c = cr.Id;
                                    if (cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                        objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Completion__c;

                                    if (cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                        objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;

                                    if (cr.Certificate_Sent_Date__c != null)
                                        objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;

                                }

                                if (cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == ERPExamTypeId) {
                                    
                                    objContact.KPI_ERP_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;
                                    
                                    if (cr.Status__c == 'Initial')
                                        objContact.KPI_ERP_Resume_Status__c = NULL;

                                    if (cr.Status__c == 'Ready For Review')
                                        objContact.KPI_ERP_Resume_Status__c = 'Waiting for Review';

                                    if (cr.Status__c == 'Failed Review')
                                        objContact.KPI_ERP_Resume_Status__c = 'Denied';

                                    if (cr.Status__c == 'Completed')
                                        objContact.KPI_ERP_Resume_Status__c = 'Approved';

                                    objContact.KPI_ERP_Resume_Program_Requirement_ID__c = cr.Id;
                                    if (cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                        objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Completion__c;

                                    if (cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                        objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;

                                    if (cr.Certificate_Sent_Date__c != null)
                                        objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;

                                }
                            }
                        }

                        if (con.recordTypeId == FRMExamTypeId && (con.status.indexof('Completed') > -1)) {
                         
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.All_Requirements_Completed_Date__c;
                            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = NULL;
                            objContact.KPI_FRM_Candidate_Payment_Status__c = con.status;

                            frmPart1CompleteDate = con.Part_1_completed_date__c;
                            frmPart2CompleteDate = con.Part_2_completed_date__c;                            

                        } else if (con.status.indexof('Activated') > -1 && con.recordTypeId == FRMExamTypeId) {
                        
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.EndDate;

                            if (nowDateTime > con.EndDate) {
                                Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                                objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = monthDiff;
                                objContact.KPI_FRM_Candidate_Payment_Status__c = 'Lapsed';
                            } else {
                                objContact.KPI_FRM_Candidate_Payment_Status__c = 'In Good Standing';
                                objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                            }
                            
                            frmPart1CompleteDate = con.Part_1_completed_date__c;
                            frmPart2CompleteDate = con.Part_2_completed_date__c;                            

                        }
                        
                       
                        /** ERP ***/
                        if (con.recordTypeId == ERPExamTypeId && (con.status.indexof('Completed') > -1)) {
                            
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.All_Requirements_Completed_Date__c;
                            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = NULL;
                            objContact.KPI_ERP_Candidate_Payment_Status__c = con.status;

                            erpPart1CompleteDate = con.Part_1_completed_date__c;
                            erpPart2CompleteDate = con.Part_2_completed_date__c;                            
                            
                        } else if (con.status.indexof('Activated') > -1 && con.recordTypeId == ERPExamTypeId) {
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.EndDate;

                            if (nowDateTime > con.EndDate) {
                                Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                                objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = monthDiff;
                                objContact.KPI_ERP_Candidate_Payment_Status__c = 'Lapsed';
                            } else {
                                objContact.KPI_ERP_Candidate_Payment_Status__c = 'In Good Standing';
                                objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                            }
                            
                            erpPart1CompleteDate = con.Part_1_completed_date__c;
                            erpPart2CompleteDate = con.Part_2_completed_date__c;                            
                            

                        }
                        
                        // SCR
                        if(con.recordTypeId == SCRExamTypeId && (con.status.indexof('Completed') > -1 && con.All_Requirements_Completed__c == true)) {
                            objContact.KPI_SCR_Completion_Date__c = con.All_Requirements_Completed_Date__c;
                        }
                        

                        system.debug('* * * passNotDone:' + passNotDone + ':' + lastDate);

                        system.debug('* * * RecordTypes:' + con.recordTypeId + ':' + FRMExamTypeId + ':' + ERPExamTypeId);

                        if (con.All_Requirements_Completed__c) {
                            if (con.recordTypeId == FRMExamTypeId && lastDate != null) {
                                system.debug('* * * In 1');
                                objContact.KPI_FRM_Certified_Date__c = lastDate;
                                
                                if(lastMemberContract != NULL && lastDate <= lastMemberContract.EndDate) {
                                    if(lastMemberContract != null && lastMemberContract.Membership_Type__c != null)
                                        objContact.KPI_FRM_Certified_Member_Status__c = lastMemberContract.Membership_Type__c + ' In Good Standing';
                                } else {
                                    if(lastMemberContract != null && lastMemberContract.Membership_Type__c != null)
                                        objContact.KPI_FRM_Certified_Member_Status__c = lastMemberContract.Membership_Type__c + ' Lapsed';    
                                }
                                
                                objContact.KPI_FRM_Certified_Year__c = string.valueof(lastDate.year());
                                objContact.KPI_FRM_Certified__c = true;
                                objContact.KPI_FRM_Candidate__c = false;
                                objContact.KPI_FRM_Holder__c = false;
                            }
                            if (con.recordTypeId == ERPExamTypeId && lastDate != null) {
                                system.debug('* * * In 2');
                                objContact.KPI_ERP_Certified_Date__c = lastDate;

                                if(lastMemberContract != NULL && lastDate <= lastMemberContract.EndDate) {
                                    if(lastMemberContract != null && lastMemberContract.Membership_Type__c != null)
                                        objContact.KPI_ERP_Certified_Member_Status__c = lastMemberContract.Membership_Type__c + ' In Good Standing';
                                } else {
                                    if(lastMemberContract != null && lastMemberContract.Membership_Type__c != null)
                                        objContact.KPI_ERP_Certified_Member_Status__c = lastMemberContract.Membership_Type__c + ' Lapsed';    
                                }
                                
                                
                                objContact.KPI_ERP_Certified_Year__c = string.valueof(lastDate.year());
                                objContact.KPI_ERP_Certified__c = true;
                                objContact.KPI_ERP_Candidate__c = false;
                                objContact.KPI_ERP_Holder__c = false;
                            }
                        } else {
                            if (con.recordTypeId == FRMExamTypeId) {
                                system.debug('* * * In 3');
                                objContact.KPI_FRM_Certified__c = false;
                                if (passNotDone) {
                                    objContact.KPI_FRM_Holder__c = false;
                                    objContact.KPI_FRM_Candidate__c = true;
                                } else {
                                    objContact.KPI_FRM_Holder__c = true;
                                    objContact.KPI_FRM_Candidate__c = true;
                                }
                            }
                            if (con.recordTypeId == ERPExamTypeId) {
                                system.debug('* * * In 4');
                                objContact.KPI_ERP_Certified__c = false;
                                if (passNotDone) {
                                    objContact.KPI_ERP_Holder__c = false;
                                    objContact.KPI_ERP_Candidate__c = true;
                                } else {
                                    objContact.KPI_ERP_Holder__c = true;
                                    objContact.KPI_ERP_Candidate__c = true;
                                }
                            }
                        }
                        
                        if(con.recordTypeId == SCRExamTypeId){
                            if(con.status.indexof('Completed') > -1) {
                                objContact.KPI_SCR_Holder__c = true;
                            } else if(con.status.indexof('Activated') > -1) {
                                objContact.KPI_SCR_Candidate__c = true;
                            }
                        }
                    }

                    if (con.recordTypeId == ICBRRExamTypeId) {
                        if(con.Opportunity__r.Program_Abbrev__c == 'ICBRR')
                            objContact.KPI_ICBRR_Participant__c = true;
                        else objContact.FRR_Participant__c = true;

                    }
                    if (con.recordTypeId == FBRExamTypeId) {
                        objContact.KPI_FBR_Participant__c = true;
                    }
                }

                // Dont I need to check for not Draft!!
                if (con.recordTypeId == FRMExamTypeId) {
                    frmCnt++;
                }
                if (con.recordTypeId == ERPExamTypeId) {
                    erpCnt++;
                }
                                    
                if (con.recordTypeId == WileyTypeId && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1) {
                    
                    system.debug('* * * Wiley not Canceled nor Draft Contract3:'+con);
                    
                    objContact.KPI_Wiley__c = True;
                    
                    if(con.status.indexof('Expired') > -1) {
                        objContact.KPI_Wiley_Payment_Status__c = 'Lapsed';
                    } else if(con.status.indexof('Activ') > -1) {
                        objContact.KPI_Wiley_Payment_Status__c = 'In Good Standing';
                    }
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('exam reg calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId) {
                            Boolean found=false;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                             
                                if (ol.PricebookEntry.Product2.ProductCode == 'MEMW' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '1147')
                                    found=true;
                                
                            }
                            system.debug('found reg:'+found); 
                            
                            opp.Wiley_Status__c = null;
                            updateOppMap.put(opp.Id,opp);
                            system.debug('Wiley_Status__c: ' + Opp);
                            
                            if(found) {
                                if(objContact.KPI_Wiley_Business_Type__c == null) {
                                    objContact.KPI_Wiley_Business_Type__c = 'New';
                                    objContact.KPI_Wiley_Join_Date__c = opp.CloseDate;
                                    
                                    Opp.Wiley_Status__c = 'New';
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Wiley_Status__c: ' + Opp);                                    
                                        
                                } else {
                                    objContact.KPI_Wiley_Business_Type__c = 'Renew';

                                    Opp.Wiley_Status__c = 'Renew';
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Wiley_Status__c: ' + Opp);                                    
                                }
                            }
                            
                            if(found) {
                                updateOppMap.put(opp.Id,opp);
                                system.debug('Exam Registration total update: ' + Opp);
                            }
                                
                        }
                    }
                }
                
                if ((con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId) && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1 && con.status.indexof('Completed') == -1) {
                    
                    system.debug('* * * FRM/ERP NOT Canceled nor Draft Contract3:'+con);
                    
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('exam reg calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId) {
                            Boolean found=false;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'ENCL' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'ENCE' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'ENCS')
                                    found=true;
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'FRM1E' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM1S' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM1L' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '1155' || 
                                    ol.PricebookEntry.Product2.Product_ID__c == '943' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '682')
                                    found=true;
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'FRM2E' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM2S' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM2L' || 
                                    ol.PricebookEntry.Product2.Product_ID__c == '1156')
                                    found=true;
                                
                            }
                            system.debug('found reg:'+found); 
                            
                            if(found) {
                                updateOppMap.put(opp.Id,opp);
                                system.debug('Exam Registration total update: ' + Opp);
                            }
                                
                        }
                    }
                }
                
                if (con.recordTypeId == MembershipTypeId && con.status.indexof('Activated') > -1 && (con.Membership_Type__c == 'Individual' || con.Membership_Type__c == 'Student')) {
                    if (objContact.MailingCountry != 'Canada') {
                        objContact.Email_Member_Update__c = true;
                    }
                    system.debug('Email_Member_Update__c: ' + objContact.Email_Member_Update__c);
                } else if (con.recordTypeId == MembershipTypeId && con.status.indexof('Expired') > -1 && (con.Membership_Type__c == 'Individual' || con.Membership_Type__c == 'Student')) {
                    objContact.Email_Member_Update__c = false;
                    system.debug('Email_Member_Update__c: ' + objContact.Email_Member_Update__c);
                    
                    numberOfMonthsAsMember += con.StartDate.monthsBetween(con.EndDate);
                    con.KPI_Months_of_Membership__c = numberOfMonthsAsMember;
                    lstUpdateContracts.add(con);
                    
                }
                
                Date badDate = date.newinstance(1999, 1, 1);
                if (con.recordTypeId == MembershipTypeId && con.status.indexof('Draft') == -1 && con.StartDate != badDate) {
                    if(objContact.Date_Joined__c == null)
                        objContact.Date_Joined__c = con.StartDate;                    
                }
                
                if ((con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId || con.recordTypeId == MembershipTypeId) && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1) {
                                            
                    system.debug('* * * Membership NOT Canceled nor Draft Contract3:'+con);
                    objContact.KPI_Member__c = true;
                                        
                    memCnt++;
                    Boolean comp = false;
                    Boolean pay = false;
                    String FirstOppPayType = Null;
                    Integer oppCount = 0;
                    Integer payCount = 0;
                    Integer renewCount = 0;
                    Integer compCount = 0;
                    Date lastRenawalDate;
                    String memberProduct=null;

                    //contractStartDateTime = datetime.newInstance(con.StartDate.year(), con.StartDate.month(),con.StartDate.day());
                    //contractEndDateTime = datetime.newInstance(con.EndDate.year(), con.EndDate.month(),con.EndDate.day());

                    objContact.KPI_Membership_Purchase_History__c = null;
                    ObjContact.Membership_Caluclated_Expiration_Date__c = null;
                    objContact.KPI_Membership_Contract_History__c = null;
                    Date lastExpDate = null;
                    String lastMemberType = null;
                    String lastMemberStatus = null;
                    Boolean hasPaid=false;
                    
                    // Set Membership Type based on Contract by Default
                    objContact.Membership_Type__c = con.Membership_Type__c;

                    oppMapWasAutoRenewCnt = new MAP<Id, Integer>();
                    oppMapWasRenewCnt = new MAP<Id, Integer>();
                    oppMapWasComped = new MAP<Id, Boolean>();
                    oppMapOrig = new MAP<Id, Opportunity>();

                    
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId && opp.StageName.indexOf('Closed') > -1 && opp.StageName.indexOf('Lost') == -1) {
                            //acctOppMap.put(opp.Id,opp.AccountId);
                            Boolean found = false;
                            Decimal amount = 0.0;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                                if (ol.PricebookEntry.Product2.ProductCode == '208' ||
                                    ol.PricebookEntry.Product2.ProductCode == '7' ||
                                    ol.PricebookEntry.Product2.ProductCode == '207' ||
                                    ol.PricebookEntry.Product2.ProductCode == '1129' ||
                                    ol.PricebookEntry.Product2.ProductCode == '4' ||
                                    ol.PricebookEntry.Product2.ProductCode == '944' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMS' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMI' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMC' ||
                                    ol.PricebookEntry.Product2.ProductCode == '395' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMF' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'AFREE' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '181' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '209' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '5' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '6') {
                                    found = True;
                                    if(ol.PricebookEntry.Product2.Product_ID__c == '181' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '209' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '5' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '6') {
                                        memberProduct = ol.PricebookEntry.Product2.Product_ID__c;
                                    } else {
                                        memberProduct = ol.PricebookEntry.Product2.ProductCode;
                                    }
                                    amount += ol.TotalPrice;
                                    if(Opp.CloseDate >= con.StartDate && Opp.CloseDate < con.EndDate)
                                        oppCount++;
                                    break;
                                }
                            }
                            
                            system.debug('memberProduct:' + memberProduct);
                            
                            if(memberProduct == '395' || memberProduct == '181' || memberProduct == '207' || memberProduct == '1129' || memberProduct == '4') {
                                memberProduct = 'MEMI';
                            } else if(memberProduct == '209' || memberProduct == '5') {
                                memberProduct = 'MEMC';
                            } else if(memberProduct == '208' || memberProduct == '7' || memberProduct == '6') {
                                memberProduct = 'MEMS';
                            } else if(memberProduct == '944' || (amount == 0.0 && memberProduct != 'AFREE')) {
                                memberProduct = 'MEMF';
                            } else if(memberProduct == '3') {
                                memberProduct = 'AFREE';
                            }
                            
                            
                            Boolean refund = false;
                            Decimal totalAmount = 0.0;
                            List<Product_Refunds__c> lPR = mapPR.get(opp.Id);
                            system.debug('Fix: ' + opp + ':' + lPR);                                
                            if(lPR != null) {
                                for(Product_Refunds__c pr :lPR) {
                                    if(pr.Refund_amount__c != null)
                                        totalAmount+=pr.Refund_amount__c;
                                }
                            }
                            if(totalAmount >= opp.Amount && lPR != null) {
                                refund = true;
                            }
                            
                            opp.Member_Status__c = null;
                            opp.Certification_Status__c = null;
                            opp.Original_Membership_Status__c = null;
                            opp.Was_Exam_Comped__c = False;
                            opp.Renewal_Count__c = null;
                            opp.AutoRenewal_Count__c = null;
    
                            updateOppMap.put(opp.Id,opp);
                            system.debug('Working Opp: ' + Opp);
                            system.debug('refund: ' + refund);
                            system.debug('found: ' + found);
                            system.debug('lastExpDate: ' + lastExpDate);
                            
                            
                            if(refund == false && found == true) {

                                system.debug('hasPaid: ' + hasPaid);
                                
                                // Set Cert Status
                                String certStatus;
                                String frmCandidateStatus;
                                String erpCandidateStatus;
                                
                                Boolean isFRMCertified=false;                                
                                Boolean isFRMCandidate=false;
                                Boolean isFRMPart2=false;
                                
                                Boolean isERPCertified=false;
                                Boolean isERPCandidate=false;
                                Boolean isERPPart2=false;
                                
                                if(objContact.KPI_FRM_Certified_Date__c != NULL && opp.CloseDate >= objContact.KPI_FRM_Certified_Date__c) {
                                    isFRMCertified=true;
                                }

                                if(objContact.KPI_FRM_Program_Start_Date__c != NULL && opp.CloseDate >= objContact.KPI_FRM_Program_Start_Date__c) {
                                    isFRMCandidate=true;
                                    
                                    if(frmPart1CompleteDate != NULL && opp.CloseDate >= frmPart1CompleteDate) {
                                        isFRMPart2=true;
                                    }
                                }
                                
                                if(objContact.KPI_ERP_Certified_Date__c != NULL && opp.CloseDate >= objContact.KPI_ERP_Certified_Date__c) {
                                    isERPCertified=true;
                                }

                                if(objContact.KPI_ERP_Program_Start_Date__c != NULL && opp.CloseDate >= objContact.KPI_ERP_Program_Start_Date__c) {
                                    isERPCandidate=true;
                                    
                                    if(ERPPart1CompleteDate != NULL && opp.CloseDate >= ERPPart1CompleteDate) {
                                        isERPPart2=true;
                                    }
                                }

                                
                                if(isFRMCertified && isERPCertified) {
                                    certStatus = 'Dual';
                                } else if(isFRMCertified) {
                                    certStatus = 'FRM Certified';
                                } else if(isERPCertified) {
                                    certStatus = 'ERP Certified';
                                } else if(isFRMCandidate || isERPCandidate) {       
                                    certStatus = 'Candidate';
                                } else {
                                    certStatus = 'None';
                                }

                                
                                if(isFRMCandidate) { 
                                    if(isFRMCertified) {
                                        frmCandidateStatus = 'Certified';
                                    } else if(isFRMPart2) {
                                        frmCandidateStatus = 'Part II';
                                    } else {
                                        frmCandidateStatus = 'Part I';
                                    }
                                }
                                
                                if(isERPCandidate) {
                                    if(isERPCertified) {
                                        erpCandidateStatus = 'Certified';
                                    } else if(isERPPart2) {
                                        erpCandidateStatus = 'Part II';
                                    } else {
                                        erpCandidateStatus = 'Part I';
                                    }
                                    
                                }                              
                                //if(objContact.KPI_ERP_Program_Start_Date__c != null && opp.GARP_Invoice_Number__c == '1527556')
                                //if(objContact.KPI_ERP_Program_Start_Date__c != null)
                                //   System.assert(false, 'BOOM!!!!' + objContact.KPI_ERP_Program_Start_Date__c);

                                
                                    opp.Member_Status__c=null;
                                    if(lastMemberStatus == null) {
                                        if(memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS') {
                                            
                                            system.debug('Member_Status__c1:');
                                                         
                                            // Set Opp Status
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Paid';
                                            
                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;
                                            
                                            
                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Original_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                                                                        
                                            hasPaid=true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c2:');
                                                                                        
                                            // Set Opp Status
                                            oppMapWasComped.put(opp.AccountId, True);

                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Comp'; 

                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;

                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);

                                            objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                         
                                           objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            compCount++;
                                            
                                            system.debug('* * * compCount1:' + compCount);
                                            
                                        } else {
                                            
                                            system.debug('Member_Status__c3:');
                                            
                                            // Set Opp Status
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New';    
                                            
                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;
                                            
                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            objContact.KPI_Membership_Original_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Original_Source__c = NULL;
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Source__c = NULL;
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);   

                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                        }                                        
                                    } else {
                                        if(!hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c4:');
                                                                                              
                                            if(objContact.Membership_Type__c == 'Affiliate') {                                               
                                                objContact.KPI_Membership_Converted_Affiliate__c = true;
                                                objContact.KPI_Membership_Converted_Date__c = opp.CloseDate;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Affiliate Conversion';
                                            } else {
                                                objContact.KPI_Membership_Converted_Exam_Comp__c = true;
                                                objContact.KPI_Membership_Converted_Date__c = opp.CloseDate;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Exam Comp Conversion';
                                            }

                                            // Set Opp Status   
                                            
                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;
                                            
                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            objContact.KPI_Membership_Business_Type__c = 'Conversion';
                                            objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            
                                            hasPaid = true;


                                        } else if(hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c5:');
                                               
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Renew';
                                            // Set Opp Status   
                                            
                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;
                                            
                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            
                                            // Add new logic to backup and chargent trans with success
                                            if(opp.Display_Invoice_Number__c != Null && 
                                                (opp.Display_Invoice_Number__c.indexOf('ATM') > -1 ||
                                                (opp.Display_Invoice_Number__c.indexOf('MEM') == -1 && 
                                                    (opp.Chargent_Autorenewal_Count__c  != NULL && opp.Chargent_Autorenewal_Count__c > 0 ||
                                                    opp.Backup_Auto_Renewal_Count__c != NULL && opp.Backup_Auto_Renewal_Count__c > 0))
                                                )) {
                                                Integer renewCnt = oppMapWasAutoRenewCnt.get(opp.AccountId);
                                                if(renewCnt != NULL) {
                                                    renewCnt++;
                                                } else {
                                                    renewCnt=1;
                                                }                                                     
                                                opp.AutoRenewal_Count__c = renewCnt;
                                                oppMapWasAutoRenewCnt.put(opp.AccountId, renewCnt);
                                                opp.Renewal_Count__c = oppMapWasRenewCnt.get(opp.AccountId);
                                                
                                            } else {
                                                Integer renewCnt = oppMapWasRenewCnt.get(opp.AccountId);
                                                if(renewCnt != NULL) {
                                                    renewCnt++;
                                                } else {
                                                    renewCnt=1;
                                                }                                         
                                                opp.Renewal_Count__c = renewCnt;
                                                oppMapWasRenewCnt.put(opp.AccountId, renewCnt);
                                                opp.AutoRenewal_Count__c = oppMapWasAutoRenewCnt.get(opp.AccountId);                                            
                                            }
                                            
                                                                                        
                                            objContact.KPI_Membership_Business_Type__c = 'Renewal';

                                            if((lastMemberType == 'MEMI' || lastMemberType == 'MEMC') && memberProduct == 'MEMS')
                                               objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                                            else objContact.KPI_Membership_Renewal_Type__c = 'Same';

                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            renewCount++;

                                            //if(Lapsed)
                                            //    objContact.KPI_Membership_Since__c = opp.CloseDate;
                                               
                                            hasPaid = true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c6:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Comp';
                                            // Set Opp Status   
                                            oppMapWasComped.put(opp.AccountId, True);

                                            // Set Cert Status
                                            opp.Certification_Status__c = certStatus;
                                            opp.FRM_Candidate_Status__c = frmCandidateStatus;
                                            opp.ERP_Candidate_Status__c = erpCandidateStatus;
                                            
                                            Opportunity origOpp = oppMapOrig.get(opp.AccountId);
                                            if(origOpp == null) {
                                                opp.Original_Membership_Status__c = opp.Member_Status__c;
                                                oppMapOrig.put(opp.AccountId, opp);
                                            } else {
                                                opp.Original_Membership_Status__c = origOpp.Member_Status__c;
                                            }
                                            Boolean wasComped = oppMapWasComped.get(opp.AccountId);
                                            if(wasComped != NULL && wasComped == True) {
                                                opp.Was_Exam_Comped__c = True;
                                            } else {
                                                opp.Was_Exam_Comped__c = False;
                                            }
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            if(objContact.KPI_Membership_Business_Type__c == NULL) {
                                                objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                                objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            }
                                            compCount++;
                                        }                                           
                                    }
                                    lastMemberStatus = opp.Member_Status__c;
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Member_Status__c update: ' + Opp);

                                lastMemberType = memberProduct;
                                system.debug('lastMemberType:' + lastMemberType); 
                                             
                            }
                                                        
                            system.debug('precalc1:' + compCount + ':' + found + ':' + amount + ':' + oppCount + ':' + refund + ':' + memberProduct + ':' + totalAmount + ':' + lastExpDate);
                            
                            // Purchases Found
                            if (found == True && refund == false) {
                                
                                Datetime oppClodeDateTime = datetime.newInstance(Opp.CloseDate.year(), Opp.CloseDate.month(),Opp.CloseDate.day());
                                
                                String newStatus;
                                if((objContact.KPI_Membership_Purchase_History__c == null || objContact.KPI_Membership_Purchase_History__c.indexOf('*') == -1) && amount > 0) {
                                    newStatus = '[' + oppClodeDateTime.format('dd/MM/yyyy') + '*' + memberProduct + ']';
                                } else {
                                    newStatus = '[' + oppClodeDateTime.format('dd/MM/yyyy') + '~' + memberProduct + ']';    
                                }
                                
                                if(objContact.KPI_Membership_Purchase_History__c == null) {
                                    objContact.KPI_Membership_Purchase_History__c = newStatus;
                                } else {
                                    if(objContact.KPI_Membership_Purchase_History__c.length() + newStatus.length() > 255)
                                        objContact.KPI_Membership_Purchase_History__c = objContact.KPI_Membership_Purchase_History__c.subString((objContact.KPI_Membership_Purchase_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Purchase_History__c.length());
                                    objContact.KPI_Membership_Purchase_History__c += newStatus;
                                }
                                    

                                system.debug('KPI_Membership_Purchase_History__c:' + opp.Id + ':' + objContact.KPI_Membership_Purchase_History__c);
                                
                                //if(Opp.CloseDate >= con.StartDate && Opp.CloseDate < con.EndDate) {
                                //    if (amount > 0) {
                                //        pay = true;
                                //        payCount++;
                                //        lastRenawalDate = Opp.CloseDate;                                        
                                //        if (FirstOppPayType == Null)
                                //            FirstOppPayType = 'pay';
                                //    } else {
                                //        comp = true;
                                //        if (FirstOppPayType == Null)
                                //            FirstOppPayType = 'comp';
                                //    }
                                //}
                            }
                        }
                    }

                    system.debug('* * * compCount:' + compCount);
                    
                    if(compCount>0)
                        objContact.KPI_Membership_Comp_Count__c = compCount;
                    if(renewCount>0)
                        objContact.KPI_Membership_Renew_Count__c = renewCount;
                    
                    
                    
                    system.debug('* * * Contracts:' + con.Id + ':' + comp + ':' + pay + ':' + firstMemberContract + ':' + FirstOppPayType + ':' + oppCount + ':' + renewalCount);

                    // Complete Contract History
                    if(lastExpDate != null) {
                        DateTime lastExpDateTime = datetime.newInstance(lastExpDate.year(), lastExpDate.month(),lastExpDate.day());
                        
                        String newStatus;
                        if(lastExpDate < Date.today())
                            newStatus = '[' + lastExpDateTime.format('dd/MM/yyyy') + '~' + memberProduct + '~Exp]';
                        else newStatus = '[' + lastExpDateTime.format('dd/MM/yyyy') + '~' + memberProduct + '~Active]';
                        
                        if(objContact.KPI_Membership_Contract_History__c == null) {
                            objContact.KPI_Membership_Contract_History__c = newStatus;
                        } else {
                            if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                            objContact.KPI_Membership_Contract_History__c += newStatus;
                        }     
                        
                        system.debug('lastExpDate Active: ' + objContact.KPI_Membership_Contract_History__c);
                    }
                    ObjContact.Membership_Caluclated_Expiration_Date__c = lastExpDate;
                    
                    // moved
                    //if (memberSinceContract == null)
                    //    memberSinceContract = con.StartDate;

                    //if (lastContract != null && lastContract.status.indexof('Canceled') == -1)
                    //    memberSinceContract = con.StartDate;
                            

                    //if(objContact.KPI_Membership_Contract_History__c == null) {
                    //    objContact.KPI_Membership_Contract_History__c = '[' + contractStartDateTime.format('dd/MM/yyyy') + '*' + abbrevMap.get(con.Membership_Type__c) + ']';
                    //} else {
                    //    String newStatus = '[' + contractStartDateTime.format('dd/MM/yyyy') + '~' + abbrevMap.get(con.Membership_Type__c) + ']';
                    //    if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                    //        objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                    //    objContact.KPI_Membership_Contract_History__c += newStatus;
                    //} 
                                        
                    //Activated
                    if (con.recordTypeId == MembershipTypeId && con.status.indexof('Activated') > -1) {
    
                        system.debug('* * * Active Contract:' + con.id + ':' + con.recordTypeId);
                        //System.assert(false, 'BOOM!!!!' + con.id); 
                        
                        objContact.KPI_Membership_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
    
                        if (lastContract == null)
                            memberSinceContract = con.StartDate;
                        
                        system.debug('* * * Member:' + con.Membership_Type__c);
                        objContact.KPI_Member__c = true;
                        // this is the issue for the member buying membership
                        
                        objContact.Membership_Type__c = con.Membership_Type__c;
                        //if (con.Membership_Type__c == 'Individual') {
                        //    objContact.CVent_Contact_Type__c = 'Member';
                        //}
                        //if(objContact.KPI_Membership_Since__c == NULL)
                        //  objContact.KPI_Membership_Since__c = con.StartDate;
                        
                        objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                        
                        Opportunity currOpp = currOppMap.get(con.Opportunity__c);
                        if(currOpp != null) {
                            currOpp.Member_Expire_Date__c = con.EndDate;
                            updateOppMap.put(currOpp.Id,currOpp);
                        }

                    }
                
                    //Lapsed or Expired
                    system.debug('* * * Lapsed?:' + nowDateTime + ':' + con.EndDate + ':' + objContact.Id + ':' + objContact.Id);
                    
                    if (con.recordTypeId == MembershipTypeId && (con.status.indexof('Expired') > -1 || nowDateTime > con.EndDate)) {
    
                        system.debug('* * * Expired Contract:' + con.id + ':' + con.recordTypeId);
    
                        //String newStatus = '[' + contractEndDateTime.format('dd/MM/yyyy') + '~' + abbrevMap.get(con.Membership_Type__c) + '~' + abbrevMap.get('Expired') + ']';
                        
                        //if(objContact.KPI_Membership_Contract_History__c == null) {
                        //    objContact.KPI_Membership_Contract_History__c = newStatus;
                        //} else {
                        //    if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                        //      objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                        //  objContact.KPI_Membership_Contract_History__c += newStatus;
                        //} 

                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_Membership_Payment_Status__c = 'Lapsed';      
                        system.debug('* * * Set Lapsed:' + objContact.KPI_Membership_Payment_Status__c);
                        
                        //if (con.recordTypeId == MembershipTypeId) {
                        //    system.debug('* * * Member:' + con.Membership_Type__c);
                        //    objContact.KPI_Member__c = true;
                        //    objContact.Membership_Type__c = con.Membership_Type__c;
                        //    if (con.Membership_Type__c == 'Individual') {
                        //        objContact.CVent_Contact_Type__c = 'Member';
                        //    }
                        //    objContact.KPI_Membership_Since__c = con.StartDate;
                            objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                        //}
                    }

                    //if (firstMemberContract != null) {
                    //    if ((lastUserType == 'Affiliate' && con.Membership_Type__c != 'Affiliate') ||
                    //        (lastUserType == 'Student' && con.Membership_Type__c == 'Individual')) {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                    //    } else if (lastUserType == con.Membership_Type__c) {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Same';
                    //    } else {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                    //    }
                    //}

                    //if (firstMemberContract == null) {
                        //firstMemberContract = con;

                        //objContact.KPI_Membership_Original_Type__c = firstMemberContract.Membership_Type__c;
                        
                        //objContact.Date_Joined__c = con.StartDate;
                        //if (FirstOppPayType == 'pay') {
                        //    objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                        //    objContact.KPI_Membership_Original_Source__c = 'Registration';
                        //    objContact.KPI_Membership_Source__c = 'Registration';
                        //    if (oppCount == 1) {
                        //        objContact.KPI_Membership_Business_Type__c = 'New Business';
                        //    }
                        //} else if (FirstOppPayType == 'comp') {
                        //    objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                        //    objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Program';
                        //    objContact.KPI_Membership_Source__c = 'FRM/ERP Program';
                        //    if (oppCount == 1) {
                        //        objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                        //    }
                        //}
                        //if (oppCount > 1) {
                        //    renewalCount += payCount;
                        //    objContact.KPI_Membership_Renewal_Date__c = lastRenawalDate;
                        //    if (FirstOppPayType == 'comp' && pay == true)
                        //        objContact.KPI_Membership_Business_Type__c = 'Conversion';
                        //    else if (pay == true)
                        //        objContact.KPI_Membership_Business_Type__c = 'Renewal';
                        //    else objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                        //}
                    //} else if (pay == true) {
                        //objContact.KPI_Membership_Source__c = 'Registration';
                        //renewalCount += payCount;
                        //objContact.KPI_Membership_Renewal_Date__c = lastRenawalDate;
                        // If not the first Contract and Paid
                        //if (objContact.KPI_Membership_Business_Type__c == 'Exam Comp')
                        //    objContact.KPI_Membership_Business_Type__c = 'Conversion';
                        //else objContact.KPI_Membership_Business_Type__c = 'Renewal';
                    //} else {
                        //objContact.KPI_Membership_Source__c = 'FRM/ERP Program';
                    //}

                    if (con.recordTypeId == MembershipTypeId && lastMemberContract == null && con.recordTypeId == MembershipTypeId) {
                        lastMemberContract = con;
                    }
                    if (con.recordTypeId == MembershipTypeId && lastMemberContract != null && con.recordTypeId == MembershipTypeId) {
                        if (con.StartDate > lastMemberContract.StartDate)
                            lastMemberContract = con;
                    }

                    if(con.recordTypeId == MembershipTypeId) {
                        system.debug('* * * lastUserType:' + lastUserType + ':' + con.Membership_Type__c);
                        lastUserType = con.Membership_Type__c;
                        lastContract = con;
                    }

                    if (renewalCount > 0) {
                        //objContact.KPI_Membership_Renewal_Count__c = string.valueof(renewalCount);
                    }
                }

            }

            if (lastMemberContract != null) {
                objContact.Membership_Last_Contract_Start_Date__c = lastMemberContract.StartDate;
            }

            if (frmCnt == 1) {
                if (frmCanceledCnt == 1)
                    objContact.KPI_FRM_Candidate_Business_Type__c = null;
                else objContact.KPI_FRM_Candidate_Business_Type__c = 'New';
            } else if (frmCnt > 1) {
                objContact.KPI_FRM_Candidate_Business_Type__c = 'Renewal';
            }

            if (erpCnt == 1) {
                if (erpCanceledCnt == 1)
                    objContact.KPI_ERP_Candidate_Business_Type__c = null;
                else objContact.KPI_ERP_Candidate_Business_Type__c = 'New';
            } else if (erpCnt > 1) {
                objContact.KPI_ERP_Candidate_Business_Type__c = 'Renewal';
            }

            system.debug('* * * objContact:' + objContact);

            //if (objContact.KPI_Membership_Payment_Status__c == 'In Good Standing') {
            //    objContact.KPI_Membership_Since__c = memberSinceContract;
            //} else {
            //    objContact.KPI_Membership_Since__c = null;
            //}

            lstContacts.add(objContact);
        }

        if (lstContacts.size() > 0)
            update lstContacts;

        //system.debug('updateOppMap: ' + updateOppMap);
        
        List<Opportunity> lstUpdateOpp = new List<Opportunity>();
        for(Opportunity op :updateOppMap.values()) {
            lstUpdateOpp.add(op);
        }
            
        //system.debug('lstUpdateOpp: ' + lstUpdateOpp);
        if(!lstUpdateOpp.isEmpty())
        	update lstUpdateOpp;
        
        //bRecursive = True;
        //if(lstUpdateContracts.size() > 0) {
        //   update lstUpdateContracts;
        //}
    }

}