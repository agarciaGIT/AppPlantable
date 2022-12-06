/*  Javascript remoting controller class for GBI App
 *  Used in visualforce page: graApp
 *  12/16/2018 Xiang: [US-14962] Added check for No DP Required in fetchUserData()
 *  07/02/2019 Xiang: [US-22435] (Not needed any more) Do not return Studies on home page when user is not participant
 *  07/30/2019 Xiang: [US-24370] Added File Upload function
 */
global without sharing class graAppRemoter {
    
    global class getUserReturnData {
        public User userData { get; set; }
        public Contact contactData { get; set; }
        public Account accountData { get; set; }        
        public Id indvAccountRecordTypeId { get; set; }
        
        public List<Study__c> studies { get; set; }   
        public List<Study_Contact__c> studyContacts { get; set; }  
        public List<Account> studyContactAccounts { get; set; }
        public List<AccountContactRelation> studyAccountContactRelation { get; set; }
        
        public List<User> studyUsers { get; set; }  
        public List<Study_Account__c> studyAccounts { get; set; }  
        public List<Study_Round__c> studyRounds { get; set; }  
        
        public List<FAQ_Category__c> faqCategories { get; set; }
        public List<FAQ_Section__c> listFAQSections { get; set; }
        public List<FAQ_Subsection__c> listFAQSubSections { get; set; }
        public List<Frequently_Asked_Questions__c> FAQs { get; set; }  
        public List<Study_Vote__c> studyVotes { get; set; }  
        public List<Study_Vote_Question__c> studyVoteQuestions { get; set; }  
        public List<Study_Contact_Vote__c> studyContactVotes { get; set; }  // May need to hide others votes
        
        public List<Study_Data_Submission__c> studyDataSubmissions { get; set; }  
        
        public List<Disclosure_Protocol__c> disclosureProtocols { get; set; }
        public List<Study_Disclose_Protocol_Submission__c> submissionDPs { get; set; }
        
        public List<Study_Document__c> graDocuments  { get; set; }
        public List<Study_Document__c> studyDocuments  { get; set; }
        
        public List<GBI_Update__c> gbiUpdates { get; set; }
        
        public AggregateResult[] studyAccountCount { get; set; }
        
        public Boolean isGARPEmployee { get; set; }
        public List<Study_NDA__c> studyNDAs { get; set; } 
        
        public List<Study_Survey__c> studySurveys { get; set; } 
    }
    
    global class verifyStudyAccessData {
        String errorMessage;
        MAP<ID,ID> myStudyAccounts;
        MAP<ID,ID> myStudyContacts;
    }
    
    global class getNextSurveyQuestionData {
        public String errorMessage;
        public Study_Survey_Question__c surveyQuestion;
        public Study_Survey_Answer__c surveyAnswer;
        public List<Study_Survey_Question__c> lstQuestions;
        public List<Study_Survey_Answer__c> lstAnswers;
    }
    
    global class pillar3Filters{
        public List<String> lstCurrencies;
        public List<Pillar_3_Institution__c> lstInstitutions;
        public Pillar_3_Dates__c dates;
    }
    
    public graAppRemoter() { 
        System.debug('graAppRemoter');
    }
    
    global PageReference init() {
        System.debug('init');
        //return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/sfdcApp');
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, AccountId, GBI_Participant__c FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                if(lstContact[0].GBI_Participant__c == True) {
                    return null;
                }
            }
        }
        return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/sfdcApp');
    }
    
    @testVisible private static Id getNetworkID() {
        Network net = [select Id, Name from Network where name = 'My GARP'];
        return net.Id;
    }
    
    
    @RemoteAction    
    public static Boolean setLastLogin(String contactId, String studyContactId) {
        if(studyContactId != NUll && studyContactId.length() > 0) {
            List<Study_Contact__c> lstStudyContact = [select Id, Name, Last_Login_Date_Time__c from Study_Contact__c where Id = :studyContactId];
            if(lstStudyContact != NULL && lstStudyContact.size() > 0) {
                lstStudyContact[0].Last_Login_Date_Time__c = system.now();
                update lstStudyContact;
            }
        }
        if(contactId != NUll && contactId.length() > 0) {
            List<Contact> lstContact = [select Id, Name, GBI_Last_Login_Date_Time__c from Contact where Id = :contactId];
            if(lstContact != NULL && lstContact.size() > 0) {
                lstContact[0].GBI_Last_Login_Date_Time__c = system.now();
                update lstContact;
            }
        }
        return true;
    }
    
   @RemoteAction    
    public static List<GBI_Update__c> fetchAllUpdates() {
       return [select Id, Name, Description__c, Intro_Description__c, Publish_Date__c, Status__c, Title__c, Visibility__c from GBI_Update__c order by Publish_Date__c DESC];
    }
    
   @RemoteAction    
    public static List<GBI_Update__c> fetchGBIUpdate(string updateId) {
       return [select Id, Name, Description__c, Intro_Description__c, Publish_Date__c, Status__c, Title__c, Visibility__c from GBI_Update__c where Id = :updateId];
    }
    
    @RemoteAction    
    public static List<Study__c> getRelatedStudies(string studyId) {
        List<Study__c> study = [select Name, Type__c, Parent_Study__c from Study__c where Id = :studyId];
        if(study != null && study.size() > 0) {
            String studyType = study[0].Type__c;
        
            if(study[0].Parent_Study__c != null) {
        
                String parentId = study[0].Parent_Study__c;
        
                List<Study__c> allStudies = new List<Study__c>();
                List < Study__c > listOfStudies = [select Id, Name FROM Study__c where Parent_Study__c = :parentId];
                List < Study__c > parentStudy = [select Id, Name FROM Study__c where Id = :parentId];
                allStudies.addAll(listOfStudies);
                allStudies.addAll(parentStudy);
                return allStudies;
            } else if(studyType != null){
                return [select Id, Name, Type__c from Study__c where Type__c =:studyType ];
                
            } else {
                return null;
            }
        }
        return null;
    }

    @RemoteAction    
    public static String updateUserEmail(String emailAddress) {
        
        String userId = UserInfo.getUserId();
        
        User fndUser = null;            
        List<User> lstUser = [
            SELECT Id, Name, Email, ContactId, Contact.Email, Username 
            FROM User 
            WHERE Id = :userId OR Email = :emailAddress
        ];
        
        for(User u :lstUser) {
            if(u.Name != 'GARP Membership' && u.Id == userId) {
                fndUser = u;
            }
        }
        
        if(fndUser != null && lstUser.size() == 1) {
            
            fndUser.Email = emailAddress;
            fndUser.Username = emailAddress;
            
            UPDATE fndUser;
            
            User vUser = [
                SELECT Id, Name, Email, ContactId, Username 
                FROM User 
                WHERE Id = :userId
            ];
            
            if(vUser.Email == emailAddress){
                return '';
            }
            
        }
        
        return 'User not found';
        
    }
    
    public static verifyStudyAccessData VerifyUserStudyAccess(String studyId) {
        
        verifyStudyAccessData vd = new verifyStudyAccessData();
        
        String userId = UserInfo.getUserId();        
        String contactId;
        Study_Contact__c thisStudyContact;
        Set<ID> myStudies = new Set<ID>();
        MAP<ID,ID> myStudyAccounts = new MAP<ID,ID>();
        MAP<ID,ID> myStudyContacts = new MAP<ID,ID>();
        Set<ID> studiesWithDP = new Set<ID>();
        Set<ID> studyRoundIds = new Set<ID>();
        MAP<ID,ID> mapStudyDP = new MAP<ID,ID>();
        String msg;
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, AccountId, Company_Account__c FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                // Studies I participated In
                List<Study_Contact__c> lstStudyContact = [select Id, Name, Role__c, Status__c, Study__c, Contact__c, Study_Account__c from Study_Contact__c where Contact__c = :contactId];
                for(Study_Contact__c sc :lstStudyContact) {
                    myStudies.add(sc.Study__c);
                    myStudyAccounts.put(sc.Study__c, sc.Study_Account__c);
                    myStudyContacts.put(sc.Study__c, sc.Id);
                }
                
                // DP Submissions from Studies I participated In
                List<Study_Disclose_Protocol_Submission__c> submissionDPs = [select Id, Name, Contact__c, Contact__r.AccountId, Contact__r.Company_Account__c, Signed_Date_Time__c, Study__c FROM Study_Disclose_Protocol_Submission__c where study__c in :myStudies and Study_Account__c in :myStudyAccounts.Values()];
                
                for(Study_Disclose_Protocol_Submission__c dp :submissionDPs) {
                    mapStudyDP.put(dp.Study__c, dp.Id);
                }

                // Compute Studies I participated In with DP
                for(Study_Contact__c sc :lstStudyContact) {
                    if(mapStudyDP.get(sc.Study__c)!=null)
                        studiesWithDP.add(sc.Study__c);
                }
               
                if(!myStudies.contains(studyId)) {
                    msg = 'You are not participating in this study!';
                }
                
                if(!studiesWithDP.contains(studyId)) {
                    msg = 'Your DP was not submitted in this study!';                         
                }
                vd.myStudyAccounts = myStudyAccounts;
                vd.myStudyContacts = myStudyContacts;
                vd.errorMessage = msg;
                return vd;
            }
        }
        vd.errorMessage = 'User not found';
        return vd;
        
    }

    @RemoteAction    
    public static getNextSurveyQuestionData commitSurveyData(String studyId, String surveyId, getNextSurveyQuestionData surveyData) {

        // Verify Access to Study
        verifyStudyAccessData vd = VerifyUserStudyAccess(studyId);
        
        // If Access is Allowed
        if(vd != NULL && vd.errorMessage == NULL && vd.myStudyAccounts != NULL && vd.myStudyContacts != NULL) {

            // Get Study Account ID
            ID fndStudyAcctId = vd.myStudyAccounts.get(studyId);
            ID fndStudyContId = vd.myStudyContacts.get(studyId);
            if(fndStudyAcctId != NULL && fndStudyContId != NULL) {
            
                List<Study_Survey_Submission__c> lstSubmissions = [select Id from Study_Survey_Submission__c where Status__c='Submitted' AND
                                                                   Study_Account__c = :fndStudyAcctId AND
                                                                   Study_Survey__c = :surveyId];
                
                if(lstSubmissions.isEmpty()) {
                    
                    // Load answers
                    List<Study_Survey_Answer__c> lstAnswers = [select Id, Study_Contact__c, Study_Survey_Question__c, Answer__c from Study_Survey_Answer__c where Study_Account__c = :fndStudyAcctId AND Study_Survey_Question__r.Study_Survey__c = :surveyId];
                    System.debug('Load Answers lstAnswers:' + lstAnswers);
                    
                    Map<String,Study_Survey_Answer__c> mapExistingAnswers = new Map<String,Study_Survey_Answer__c>();
                    for(Study_Survey_Answer__c ssa :lstAnswers) {
                        mapExistingAnswers.put(ssa.Study_Survey_Question__c,ssa);
                    }
                    System.debug('mapExistingAnswers:' + mapExistingAnswers);
                    
                    Map<String,Study_Survey_Answer__c> mapNewAnswers = new Map<String,Study_Survey_Answer__c>();
                    for(Study_Survey_Answer__c ssa :surveyData.lstAnswers) {
                        mapNewAnswers.put(ssa.Study_Survey_Question__c,ssa);
                    }
                    System.debug('mapNewAnswers:' + mapNewAnswers);
                    
                    // Remove or Update Existing Answers
                    List<Study_Survey_Answer__c> removeAnswers = new List<Study_Survey_Answer__c>();
                    List<Study_Survey_Answer__c> updateAnswers = new List<Study_Survey_Answer__c>();
                    List<Study_Survey_Answer__c> insertAnswers = new List<Study_Survey_Answer__c>();
                    
                    for(String ans :mapExistingAnswers.keySet()) {
                        Study_Survey_Answer__c fndNew = mapNewAnswers.get(ans);
                        Study_Survey_Answer__c fndExisting = mapExistingAnswers.get(ans);
                        
                        System.debug('ans:' + ans);
                        System.debug('fndNew:' + fndNew);
                        System.debug('fndExisting:' + fndExisting);
                        
                        if(fndNew == NULL) {
                            removeAnswers.add(fndExisting);
                        } else {
                            fndExisting.Study_Contact__c = fndNew.Study_Contact__c;
                            fndExisting.Answer__c = fndNew.Answer__c;
                            updateAnswers.add(fndExisting);
                        }
                        System.debug('removeAnswers:' + removeAnswers);
                        System.debug('updateAnswers:' + updateAnswers);
                    }
                    
                    // Add new Answers
                    for(String ans :mapNewAnswers.keySet()) {
                        Study_Survey_Answer__c fndNew = mapNewAnswers.get(ans);
                        Study_Survey_Answer__c fndExisting = mapExistingAnswers.get(ans);
                        
                        System.debug('ans:' + ans);
                        System.debug('fndNew:' + fndNew);
                        System.debug('fndExisting:' + fndExisting);
                        
                        if(fndExisting == NULL) {
                            insertAnswers.add(fndNew);
                        }                                
                        System.debug('insertAnswers:' + insertAnswers);
                    }
                    System.debug('removeAnswers:' + removeAnswers);
                    System.debug('updateAnswers:' + updateAnswers);                            
                    System.debug('insertAnswers:' + insertAnswers);
                    
                    delete removeAnswers;
                    update updateAnswers;
                    insert insertAnswers;
                    
                    // Add Survey Submission
                    Study_Survey_Submission__c sss = new Study_Survey_Submission__c(Status__c='Submitted', 
                                                                                    Study_Account__c=fndStudyAcctId, 
                                                                                    Study_Contact__c=fndStudyContId, 
                                                                                    Study_Survey__c=surveyId, 
                                                                                    Submitted_Date_Time__c=DateTime.now());
                    insert sss;
                }
            } else {
                surveyData.errorMessage = 'Study Account or Contact not found';
            }
        } else {
            surveyData.errorMessage = 'Invalid Access';
        }
        
        return surveyData;        
    }
    
    @RemoteAction
    public static getNextSurveyQuestionData submitStudySurveyAnswer(String studyId, String surveyId, String surveyQuestionId, String surveyAnswer, getNextSurveyQuestionData surveyData) {
        getNextSurveyQuestionData gsqd;
        
        // Verify Access to Study
        verifyStudyAccessData vd = VerifyUserStudyAccess(studyId);
        
        // If Access is Allowed
        if(vd != NULL && vd.errorMessage == NULL && vd.myStudyAccounts != NULL && vd.myStudyContacts != NULL) {
            List<Study_Survey__c> lstSurveys = [select Id, Study__c from Study_Survey__c where id = :surveyId];
            
            // Verify Survey request is in Study requested
            if(lstSurveys != NULL && lstSurveys.size() > 0) {
                if(lstSurveys[0].Study__c == studyId) {
                    
                    // Get Study Account ID
                    ID fndStudyAcctId = vd.myStudyAccounts.get(studyId);
                    ID fndStudyContId = vd.myStudyContacts.get(studyId);
                    if(fndStudyAcctId != NULL && fndStudyContId != NULL) {
                        
                        // Save Answer to List
                        Study_Survey_Answer__c newAnswer = new Study_Survey_Answer__c(
                                Answer__c = surveyAnswer,
                                Study_Account__c = fndStudyAcctId,
                                Study_Contact__c = fndStudyContId,
                                Study_Survey_Question__c = surveyQuestionId
                            );
                        
                        System.debug('newAnswer:' + newAnswer);
                        
                        if(surveyData == NULL) {
                            surveyData = new getNextSurveyQuestionData();
                            surveyData.lstAnswers = new List<Study_Survey_Answer__c>();

                            System.debug('init surveyData:' + surveyData);
                        }
                        surveyData.lstAnswers.add(newAnswer);
                        System.debug('update surveyData:' + surveyData);
                        
                        // Get Next Question
                        gsqd = getNextStudySurveyQuestionInternal(surveyId,fndStudyAcctId,surveyQuestionId,newAnswer); 
                        gsqd.lstAnswers = new List<Study_Survey_Answer__c>();
                        for(Study_Survey_Answer__c ssa :surveyData.lstAnswers) {
                            gsqd.lstAnswers.add(ssa);
                        }
                        System.debug('update Question/Answer gsqd:' + gsqd);
                        
                        return gsqd;
                    }
                }
            }
        } else {
            gsqd = new getNextSurveyQuestionData();
            gsqd.errorMessage = vd.errorMessage;
        }     
        return gsqd;
    }
        

    @RemoteAction
    public static getNextSurveyQuestionData getStudySurveyQuestion(String studyId, String surveyId, String questionId, getNextSurveyQuestionData surveyData) {
        
        getNextSurveyQuestionData gsqd = new getNextSurveyQuestionData();
        
        // Verify Access to Study
        verifyStudyAccessData ret = VerifyUserStudyAccess(studyId);
        System.debug('verifyStudyAccessData:' + ret);
        
        // If Access is Allowed
        if(ret != NULL && ret.errorMessage == NULL && ret.myStudyAccounts != NULL) {
            List<Study_Survey__c> lstSurveys = [select Id, Study__c from Study_Survey__c where id = :surveyId];
            System.debug('lstSurveys:' + lstSurveys);
            
            // Verify Survey request is in Study requested
            if(lstSurveys != NULL && lstSurveys.size() > 0) {
                if(lstSurveys[0].Study__c == studyId) {
                    
                    // Get Study Account ID
                    ID fndStudyAcctId = ret.myStudyAccounts.get(studyId);
                    System.debug('fndStudyAcctId:' + fndStudyAcctId);
                    
                    if(fndStudyAcctId != NULL) {
                        // Get First Question

                        List<Study_Survey_Question__c> lstQuestion = [select Id, Is_First_Question__c, Question__c, Next_Question__c, recordtype.name,
                                                                      (select Id, Answer__c from Study_Survey_Answers__r where Study_Account__c = :fndStudyAcctId),
                                                                      (select Id, Choice__c, Sort_Order__c, Study_Survey_Next_Question__c from Study_Survey_Choices__r)
                                                                      from Study_Survey_Question__c where Study_Survey__c = :surveyId AND Id = :questionId];
                        
                        if(lstQuestion != NULL && lstQuestion.size() > 0) {
                            Study_Survey_Question__c currentQuestion = lstQuestion[0];
                            gsqd.surveyQuestion = currentQuestion;
                            if(currentQuestion.Study_Survey_Answers__r != NULL && currentQuestion.Study_Survey_Answers__r.size() > 0) {
                                gsqd.surveyAnswer = currentQuestion.Study_Survey_Answers__r[0];
                            }
                        }
                        
                        // Rebuild Answers
                        gsqd.lstAnswers = new List<Study_Survey_Answer__c>();
                        gsqd.lstQuestions = [select Id, Is_First_Question__c, Question__c, Next_Question__c, recordtype.name from Study_Survey_Question__c where Study_Survey__c = :surveyId];
                        Boolean fndStart = false;
                        
                        for(Study_Survey_Answer__c ssa :surveyData.lstAnswers) {
                            
                            System.debug('ssa:' + ssa + ':' + questionId);
                                                    
                            if(ssa.Study_Survey_Question__c == questionId) {
                                fndStart = true;
                            }
                            if(!fndStart) {
                                gsqd.lstAnswers.add(ssa);
                            }
                            
                            System.debug('gsqd.lstAnswers:' + gsqd.lstAnswers);
                        }
                        
                        System.debug('getNextStudySurveyQuestionInternal:' + gsqd);
                    }
                }
            }
        }        
        return gsqd;
        
    } 
    
    
    @RemoteAction
    public static getNextSurveyQuestionData getFirstStudySurveyQuestion(String studyId, String surveyId) {
        
        getNextSurveyQuestionData gsqd = new getNextSurveyQuestionData();
        
        // Verify Access to Study
        verifyStudyAccessData ret = VerifyUserStudyAccess(studyId);
        System.debug('verifyStudyAccessData:' + ret);
        
        // If Access is Allowed
        if(ret != NULL && ret.errorMessage == NULL && ret.myStudyAccounts != NULL) {
            List<Study_Survey__c> lstSurveys = [select Id, Study__c from Study_Survey__c where id = :surveyId];
            System.debug('lstSurveys:' + lstSurveys);
            
            // Verify Survey request is in Study requested
            if(lstSurveys != NULL && lstSurveys.size() > 0) {
                if(lstSurveys[0].Study__c == studyId) {
                    
                    // Get Study Account ID
                    ID fndStudyAcctId = ret.myStudyAccounts.get(studyId);
                    System.debug('fndStudyAcctId:' + fndStudyAcctId);
                    
                    if(fndStudyAcctId != NULL) {
                        // Get First Question

                        List<Study_Survey_Question__c> lstQuestion = [select Id, Is_First_Question__c, Question__c, Next_Question__c, recordtype.name,
                                                                      (select Id, Answer__c from Study_Survey_Answers__r where Study_Account__c = :fndStudyAcctId),
                                                                      (select Id, Choice__c, Sort_Order__c, Study_Survey_Next_Question__c from Study_Survey_Choices__r)
                                                                      from Study_Survey_Question__c where Study_Survey__c = :surveyId AND Is_First_Question__c = True];
                        
                        if(lstQuestion != NULL && lstQuestion.size() > 0) {
                            Study_Survey_Question__c currentQuestion = lstQuestion[0];
                            gsqd.surveyQuestion = currentQuestion;
                            if(currentQuestion.Study_Survey_Answers__r != NULL && currentQuestion.Study_Survey_Answers__r.size() > 0) {
                                gsqd.surveyAnswer = currentQuestion.Study_Survey_Answers__r[0];
                            }
                        }
                        gsqd.lstAnswers = new List<Study_Survey_Answer__c>();
                        gsqd.lstQuestions = [select Id, Is_First_Question__c, Question__c, Next_Question__c, recordtype.name from Study_Survey_Question__c where Study_Survey__c = :surveyId];
                        System.debug('getNextStudySurveyQuestionInternal:' + gsqd);
                    }
                }
            }
        }        
        return gsqd;
        
    } 
    
    public static getNextSurveyQuestionData getNextStudySurveyQuestionInternal(String surveyId, String studyAccountId, String lastQuestionId, Study_Survey_Answer__c newAnswer) {
        getNextSurveyQuestionData gsqd = new getNextSurveyQuestionData();
        
        MAP<String,Study_Survey_Question__c> mapQuestions = new MAP<String,Study_Survey_Question__c>();
        List<Study_Survey_Question__c> lstQuestion = [select Id, Is_First_Question__c, Question__c, Next_Question__c, recordtype.name,
                                                      (select Id, Answer__c from Study_Survey_Answers__r where Study_Account__c = :studyAccountId),
                                                      (select Id, Choice__c, Sort_Order__c, Study_Survey_Next_Question__c from Study_Survey_Choices__r)
                                                      from Study_Survey_Question__c where Study_Survey__c = :surveyId];
        
        System.debug('lstQuestion:' + lstQuestion);
        
        Study_Survey_Question__c currentQuestion;
        Study_Survey_Question__c nextQuestion;
        
        if(lstQuestion != NULL && lstQuestion.size() > 0) {
            
            // Get current and next questions based on Sort Order
            for(Study_Survey_Question__c ssq :lstQuestion) {
               
                System.debug('ssq:' + ssq);
                mapQuestions.put(ssq.Id, ssq);
                
                if(ssq.Id == newAnswer.Study_Survey_Question__c) {
                        currentQuestion = ssq;
                }
            }
            
            // Set Next Question default
            if(currentQuestion.Next_Question__c != NULL) {
                Study_Survey_Question__c fndQuest = mapQuestions.get(currentQuestion.Next_Question__c);
                if(fndQuest != NULL) {
                    nextQuestion = fndQuest;    
                }                
            }
            
            System.debug('currentQuestion:' + currentQuestion);
            System.debug('nextQuestion:' + nextQuestion);
            
            // If current question is multiple choice and answer given has custom path
            if(currentQuestion != NULL && currentQuestion.Study_Survey_Answers__r != NULL && currentQuestion.Study_Survey_Choices__r != NULL) {
                                
                System.debug('answer:' + newAnswer);
                
                for(Study_Survey_Choice__c ssc :currentQuestion.Study_Survey_Choices__r) {
                    System.debug('ssc:' + ssc);
                    if(ssc.Choice__c == newAnswer.Answer__c && ssc.Study_Survey_Next_Question__c != NULL) {
                        Study_Survey_Question__c fndQuest = mapQuestions.get(ssc.Study_Survey_Next_Question__c);
                        if(fndQuest != NULL) {
                            nextQuestion = fndQuest;    
                        }
                    }
                }
            }
            
            System.debug('currentQuestion:' + currentQuestion);
            System.debug('nextQuestion:' + nextQuestion);
            
            gsqd.surveyQuestion = nextQuestion;
            if(nextQuestion != NULL && nextQuestion.Study_Survey_Answers__r != NULL && nextQuestion.Study_Survey_Answers__r.size() > 0) {
                gsqd.surveyAnswer = nextQuestion.Study_Survey_Answers__r[0];
            }                
        }
        return gsqd;
    }
    
    @RemoteAction    
    public static String updateContactInfo(String firstName, String lastName, String title, String phone, String altphone, String email) {
        
        FINAL Id userId = UserInfo.getUserId();        
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && !lstUser.isEmpty()) {
            
            FINAL Id contactId = lstUser[0].ContactId;   
             
            List<Contact> lstContact = [
                SELECT Id, Name, AccountId, FirstName, LastName, Phone, OtherPhone, Title, Email
                FROM Contact 
                WHERE Id = :contactId
            ];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                lstContact[0].FirstName = firstName;
                lstContact[0].LastName = lastName;
                lstContact[0].Title = title;
                lstContact[0].Phone = phone;
                lstContact[0].OtherPhone = altphone;
                lstContact[0].Email = email;
                               
                UPDATE lstContact[0];
                
                return '';
            }
            return 'Contact not found';
        }
        return 'User not found';
    }
    
    @RemoteAction    
    public static String removeUserPhoto() {
        String userId = UserInfo.getUserId();
        
        User usr = [Select id, FullPhotoUrl, ContactId from User where id = :userId];
        
        List<User_Photo__c> ufs = [select id from User_Photo__c where Contact__c = :usr.ContactId];
        if(ufs != NULL && ufs.size() > 0) {
            User_Photo__c uf = ufs[0];
            list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE ParentId =: uf.Id];
            if(attachments != NULL && attachments.size() > 0) {
                delete attachments;
            }
        }
        
        Contact updateContact = [Select id, Photo_URL__c from contact where id = :usr.ContactId];
        updateContact.Photo_URL__c = NULL;
        Update updateContact;
        
        return updateContact.Photo_URL__c;
    }
    
    @RemoteAction    
    public static String setUserPhoto(Id attachmentId) {
        String userId = UserInfo.getUserId();
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
        if(!attachments.isEmpty()) {
            ConnectApi.BinaryInput binInput = new ConnectApi.BinaryInput(attachments[0].body, 'image/jpg', 'fileName');
            delete attachments;
            
            // Replace Photo
            User usr = [Select id, Name, FullPhotoUrl, ContactId from User where id = :userId];
            
            List<User_Photo__c> ufs = [select id from User_Photo__c where Contact__c = :usr.ContactId];
            User_Photo__c uf;
            if(ufs != NULL && ufs.size() > 0) {
                uf = ufs[0];
                list<Attachment> phattachments = [SELECT Id, Body FROM Attachment WHERE ParentId =: uf.Id];
                if(phattachments != NULL && phattachments.size() > 0) {
                    delete phattachments;
                }
            } else {
                uf = New User_Photo__c(Name=usr.Name, Contact__c=usr.ContactID);
                insert uf;
            }
            
            Attachment a = new Attachment();
            a.body = binInput.getBlobValue();
            a.ParentId = uf.ID;
            a.contentType = 'image/jpeg';
            a.name = 'photo';                                
            insert a;            
            
            Contact updateContact = [Select id, Photo_URL__c from contact where id = :usr.ContactId];
            updateContact.Photo_URL__c = '/servlet/servlet.FileDownload?file=' + a.id;
            Update updateContact;
            
            return updateContact.Photo_URL__c;
            
        } else {
            return null;
        }
    }
            
    @RemoteAction
    public static String submitCase(String subject, String Body) {
        String userId = UserInfo.getUserId();        
        String contactId;
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, Email, AccountId FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                Case newCase = new Case();
                newCase.Contact = lstContact[0];
                newCase.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Case', 'Customer');
                newCase.Subject = subject;
                newCase.Description = Body;
                insert newCase;
                return '';
            }
        }
        return 'User not found';
    }
    
@RemoteAction
    public static Response.Detail submitDP(String studyId, String invoiceEmail, Decimal paymentFeeAmount) {
    
        try{
    
        String userId = UserInfo.getUserId();        
        String contactId;
        Study_Contact__c thisStudyContact;
        Set<ID> myStudies = new Set<ID>();
        Set<ID> myStudyAccount = new Set<ID>();
        Set<ID> studiesWithDPIds = new Set<ID>();
        MAP<ID,ID> mapStudyDP = new MAP<ID,ID>();
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                // Studies I participated In
                List<Study_Contact__c> lstStudyContact = [select Id, Name, Role__c, Status__c, Study__c, Contact__c, Study_Account__c from Study_Contact__c where Contact__c = :contactId];
                for(Study_Contact__c sc :lstStudyContact) {
                    if(sc.Study__c == studyId)
                        thisStudyContact = sc;
                    myStudies.add(sc.Study__c);
                    myStudyAccount.add(sc.Study_Account__c);
                }
                
                if(!myStudies.contains(studyId)) {
                    throw new Response.ResponseException('You are not participating in this study!', 400, null);
                }
                
                /*
                // DP Submissions from Studies I participated In from My Org
                List<Study_Disclose_Protocol_Submission__c> studiesWithDP= [
                    select Id, Name, Contact__c, Signed_Date_Time__c, Study__c, Study_Account__c 
                    FROM Study_Disclose_Protocol_Submission__c 
                    where study__c in :myStudies and Study_Account__c = :thisStudyContact.Study_Account__c 
                ];
                
                for(Study_Disclose_Protocol_Submission__c dp :studiesWithDP) {
                    studiesWithDPIds.add(dp.Study__c);
                }
                */
    
                List<Disclosure_Protocol__c> disclosureProtocols = [
                    SELECT Id, Study__r.Payment_Required__c,
                    (SELECT Id FROM Study_Disclosure_Protocol_Submissions__r WHERE Study__c = :studyId AND Study_Account__c in :myStudyAccount)
                    FROM Disclosure_Protocol__c
                    WHERE Study__c = :studyId AND DP_Status__c = 'Active'
                    LIMIT 1
                ];
    
                if(disclosureProtocols[0].Study_Disclosure_Protocol_Submissions__r.isEmpty()) {
                    Study_Disclose_Protocol_Submission__c newDPSubmission = new Study_Disclose_Protocol_Submission__c();
                    newDPSubmission.Disclosure_Protocol__c = disclosureProtocols[0].Id;
                    newDPSubmission.Study_Contact__c = thisStudyContact.Id;
                    newDPSubmission.Study_Account__c = thisStudyContact.Study_Account__c;
                    newDPSubmission.Study__c = studyId;
                    newDPSubmission.Signed_Date_Time__c = system.now();
                    
                    if(disclosureProtocols[0].Study__r.Payment_Required__c) {
                        Study_Account__c newStudyAccountInfo = [SELECT Id, Payment_Agreed_Date__c , Invoice_Email__c, Payment_Agreed_Amount__c FROM Study_Account__c WHERE Id = :thisStudyContact.Study_Account__c];
                        if(newStudyAccountInfo  != NULL) {
                            newStudyAccountInfo.Payment_Agreed_Date__c = datetime.now();
                            newStudyAccountInfo.Invoice_Email__c = invoiceEmail;
                            newStudyAccountInfo.Payment_Agreed_Amount__c = (paymentFeeAmount != 0 && paymentFeeAmount != 0.00) ? paymentFeeAmount : null;
                        
                            update newStudyAccountInfo;
                        } else {
                            throw new Response.ResponseException('Study Account not found.', 400, null);
                        }
                    }
                    insert newDPSubmission;
                    
                    return new Response.Detail('Successfully inserted Disclosure Protocol Submission and updated Invoice Email & Payment Agreed.', 200, null);
                } else {
                    throw new Response.ResponseException('A disclosure protocol for this study was already submitted.', 400, null);
                }
            }
        }
    
        throw new Response.ResponseException('User not found.', 404, null);
    
        }catch(Response.ResponseException e){
    
            return new Response.Detail(e.getMessage(), e.status, e.errors);
    
        }catch(Exception e){
    
            return new Response.Detail(null, 400, new List<Object>{
                e.getMessage(),
                e.getLineNumber(),
                e.getStackTraceString()
            });
    
        } 
    }    
    @RemoteAction
    public static Boolean submitPillar3Attestation() {
        String userId = UserInfo.getUserId();        
        
        String contactId;
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, GBI_Pillar_3_Attestation__c  FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                lstContact[0].GBI_Pillar_3_Attestation__c = true;
                update lstContact[0];
                return true;
            }
        }
        return false;
        
    }

    
    @RemoteAction
    public static String submitData(String studyRoundId) {
        String userId = UserInfo.getUserId();        
        String contactId;
        Study_Contact__c thisStudyContact;
        Set<ID> myStudies = new Set<ID>();
        Set<ID> myStudyAccounts = new Set<ID>();
        Set<ID> studiesWithDP = new Set<ID>();
        Set<ID> studyRoundIds = new Set<ID>();
        MAP<ID,ID> mapStudyDP = new MAP<ID,ID>();
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;            
            List<Contact> lstContact = [SELECT Id, Name, AccountId, Company_Account__c FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                // Studies I participated In
                List<Study_Contact__c> lstStudyContact = [select Id, Name, Role__c, Status__c, Study__c, Contact__c, Study_Account__c from Study_Contact__c where Contact__c = :contactId];
                for(Study_Contact__c sc :lstStudyContact) {
                    myStudies.add(sc.Study__c);
                    myStudyAccounts.add(sc.Study_Account__c);
                }
                
                // DP Submissions from Studies I participated In
                List<Study_Disclose_Protocol_Submission__c> submissionDPs = [select Id, Name, Contact__c, Contact__r.AccountId, Contact__r.Company_Account__c, Signed_Date_Time__c, Study__c FROM Study_Disclose_Protocol_Submission__c where study__c in :myStudies and Study_Account__c in :myStudyAccounts];
                
                for(Study_Disclose_Protocol_Submission__c dp :submissionDPs) {
                    mapStudyDP.put(dp.Study__c, dp.Id);
                }

                // Compute Studies I participated In with DP
                for(Study_Contact__c sc :lstStudyContact) {
                    if(mapStudyDP.get(sc.Study__c)!=null)
                        studiesWithDP.add(sc.Study__c);
                }
                
                // Study Round info from Studies I participated In that have submitted a DP
                List<Study_Round__c> studyRounds = [
                    SELECT Id, Name, Description__c, Published_Date__c, Round__c, Status__c, Study__c, Data_Collection_Start_Date__c, Data_Collection_End_Date__c, 
                    (SELECT Id,Name,CreatedDate FROM Attachments order by CreatedDate DESC)
                    FROM Study_Round__c 
                    where Study__c in :studiesWithDP and Round__c = :studyRoundId
                ];
                if(studyRounds != null && studyRounds.size() > 0) {
                    ID studyID = studyRounds[0].Study__c;
                    if(!myStudies.contains(studyID)) {
                        return 'You are not participating in this study!';
                    }

                    if(!studiesWithDP.contains(studyId)) {
                        return 'Your DP was not submitted in this study!';                         
                    }
                } else {
                    return 'No study rounds found!';
                }
                
                for(Study_Contact__c sc :lstStudyContact) {
                    if(sc.Study__c == studyRounds[0].Study__c)
                        thisStudyContact = sc;                    
                    myStudies.add(sc.Study__c);
                }
                
                                                
                List<Study_Data_Submission__c> studyDataSubmissions = [select Id, Name, Study_Account__c, Submission_Date_Time__c, Study_Round__c from Study_Data_Submission__c where Study_Account__c = :thisStudyContact.Study_Account__c and Study_Round__c = :studyRoundId];
                if(studyDataSubmissions == null || studyDataSubmissions.size() <= 0) {
                    Study_Data_Submission__c newSubmission = new Study_Data_Submission__c();
                    newSubmission.Study_Account__c = thisStudyContact.Study_Account__c;
                    newSubmission.Study_Round__c = studyRoundId;
                    newSubmission.Submission_Date_Time__c = system.now();
                    insert newSubmission;
                    return '';
                }
            }
        }
        return 'User not found';
    }

    @RemoteAction
    public static String submitVote(String voteId, String questionId, String answer) {
        String userId = UserInfo.getUserId();        
        String contactId;
        Study_Contact__c thisStudyContact;
        MAP<ID,Study_Contact__c> myStudies = new MAP<ID,Study_Contact__c>();
        Set<ID> studiesWithDP = new Set<ID>();
        Set<ID> studyRoundIds = new Set<ID>();
        Set<ID> myStudyAccounts = new Set<ID>();        
        MAP<ID,ID> mapStudyDP = new MAP<ID,ID>();
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;                 
            List<Contact> lstContact = [SELECT Id, Name, AccountId, Company_Account__c FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                // Studies I participated In
                List<Study_Contact__c> lstStudyContact = [select Id, Name, Role__c, Status__c, Study__c, Contact__c, Study_Account__c, Study_Account__r.Role__c, Study_Account__r.DP_Not_Required__c from Study_Contact__c where Contact__c = :contactId];
                for(Study_Contact__c sc :lstStudyContact) {
                    myStudies.put(sc.Study__c, sc);
                    myStudyAccounts.add(sc.Study_Account__c);
                }
                
                System.debug('myStudies:' + myStudies);
                
                // DP Submissions from Studies I participated In
                List<Study_Disclose_Protocol_Submission__c> submissionDPs = [select Id, Name, Contact__c, Contact__r.AccountId, Contact__r.Company_Account__c, Signed_Date_Time__c, Study__c FROM Study_Disclose_Protocol_Submission__c where study__c in :myStudies.keySet() and Study_Account__c in :myStudyAccounts];
                
                for(Study_Disclose_Protocol_Submission__c dp :submissionDPs) {
                    mapStudyDP.put(dp.Study__c, dp.Id);
                }

                // Compute Studies I participated In with DP
                for(Study_Contact__c sc :lstStudyContact) {
                    if(mapStudyDP.get(sc.Study__c)!=null)
                        studiesWithDP.add(sc.Study__c);
                }                
                
                List<Study_Vote__c> lstStudyVotes = [select Id, Name, Study__c from Study_Vote__c where Id = :voteId];
                if(lstStudyVotes != null && lstStudyVotes.size() > 0) {
                    ID studyID = lstStudyVotes[0].Study__c;
                    Study_Contact__c fndSc = myStudies.get(studyID);
                    
                    if(fndSc == NULL) {
                        return 'You are not participating in this study!';
                    }

                    if(fndSc.Study_Account__r.Role__c == 'Other' || fndSc.Study_Account__r.DP_Not_Required__c == True) {
                        return 'You do not have permission to vote in this study!';
                    }
                    
                    if(!studiesWithDP.contains(studyId)) {
                        return 'Your DP was not submitted in this study!';                         
                    }                    
                } else {
                    return 'Vote does not exist';
                }
                
                for(Study_Contact__c sc :lstStudyContact) {
                    if(sc.Study__c == lstStudyVotes[0].Study__c)
                        thisStudyContact = sc;
                }                
                
                List<Study_Contact_Vote__c> studyContactVotes = [select Id, Name, Study_Contact__c, Study_Account__c FROM Study_Contact_Vote__c where Cancel_Vote__c = FALSE AND Study_Vote_Question__c = :questionId and Study_Account__c = :thisStudyContact.Study_Account__c];
                if(studyContactVotes!= null && studyContactVotes.size() > 0) {
                    return 'A vote was already cast for your Organization!';
                }
                Study_Contact_Vote__c newVote = new Study_Contact_Vote__c();
                newVote.Study_Vote_Question__c = questionId;
                newVote.Study_Contact__c = thisStudyContact.Id;
                newVote.Vote__c = answer;
                newVote.Vote_Made_Date_Time__c = system.now();
                newVote.Study_Account__c = thisStudyContact.Study_Account__c;
                insert newVote;
                return '';
            }
        }
        return 'User not found.';
    }
    
    /*** Start Upload Related Methods ***/
    // [US-24370] Security Check and fetch Upload Link to correct folder
    @RemoteAction
    public static UploadLink loadSFUploadLink(Id studyId) {
        UploadLink ul = new UploadLink();
        ul.success = false;

        // Contact Security Check - Contact is GBI Participant
        List<User> userChk = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId() AND Contact.GBI_Participant__c = true];
        
        if(userChk.size() > 0) {
            Id contId = userChk[0].ContactId;
            
            // Study Contact Security Check - 1. Study enables integration 2. Study Account active and platform has ShareFile, 3. Study Contact active and has Role access 
            List<Study_Contact__c> styConChk = [SELECT Id, Study__c, Study_Account__c, Study_Account__r.Account__c FROM Study_Contact__c WHERE Contact__c = :contId AND Study__c = :studyId 
                                                AND Study__r.Secure_File_Integration_Status__c = 'Enabled' 
                                                AND Study_Account__r.Status__c = 'Active' AND Study_Account__r.Secure_File_Platform__c INCLUDES('ShareFile')
                                                AND Status__c = 'Active' AND Role__c INCLUDES('Admin', 'Data Manager')];
            if(styConChk.size() > 0) {
                // Study Round Check - Study data submission is open
                List<Study_Round__c> styVerChk = [SELECT Id FROM Study_Round__c WHERE Study__c = :studyId AND Status__c in ('Data Collection','Active')];
                
                if(styVerChk.size() > 0) {
                    //All security checks passed
                    Study_Contact__c studyContact = styConChk[0];
                    String uploadLink = shareFileClass.generateSFUploadLink(studyContact);
                    
                    if(String.isNotEmpty(uploadLink)) {
                        ul.success = true;
                        ul.statusMsg = 'Upload Link fetched without error.';
                        ul.uploadLink = uploadLink;
                    }else {
                        ul.statusMsg = 'Could not get upload link, please try again later.';
                    }
                }else {
                    ul.statusMsg = 'Data submission is not open for the study.';
                }
            }else {
                ul.statusMsg = 'User does not have file access on the Study.';
            }
        }else {
            ul.statusMsg = 'User is not GBI Participant.';
        }
        
        return ul;
    }
    
    public class UploadLink {
        public Boolean success {get; private set;}
        public String statusMsg {get; private set;}
        public String uploadLink {get; private set;}
    }
    /*** End Upload Related Methods ***/

    @RemoteAction    
    public static Id uploadAttachment(Id attachmentId, String fileText, String fileName) {
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
                if(attachments.isEmpty()) {
                    Attachment att = new Attachment();
                    att.Body = EncodingUtil.base64Decode(fileText);
                    att.Name = fileName;
                    att.parentId = lstContact[0].Id;
                    insert att;
                    return att.Id;
                } else {
                    String newBody = '';
                    Attachment att = attachments[0];
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += fileText;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    upsert att;
                    return att.Id;
                }   
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    
    @RemoteAction
    public static Boolean sendEmail(String subject, String description, Boolean isPillar3){
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :contactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<Messaging.SingleEmailMessage> lstMail=new List<Messaging.SingleEmailMessage>();
                List<OrgWideEmailAddress> lstEmailAddress = new List<OrgWideEmailAddress>();
                // Query from Organization-Wide Email Address       
                if(isPillar3)
                    lstEmailAddress=[select Id, Address from OrgWideEmailAddress WHERE Address='pillar3support@garp.com'];
                else
                    lstEmailAddress=[select Id, Address from OrgWideEmailAddress WHERE Address='gbi@garp.com'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
                String[] toAddresses = new String[] {lstEmailAddress[0].Address}; 
                mail.setToAddresses(toAddresses); 
                // Set Organization-Wide Email Address Id
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSubject(isPillar3 ? 'GBI Pillar 3 Support Request' : 'GBI Support Request'); 
                mail.setBccSender(false); 
                mail.setUseSignature(false); 
                mail.setHtmlBody('Name: '+lstContact[0].Name+'<br>Email: '+lstContact[0].Email+'<br>Phone: '+lstContact[0].Phone+'<br><br>Subject: '+subject+'<br><br>Description: '+description);
                lstMail.add(mail);   
                if(!Test.isRunningTest()){
                    if(lstMail.size() > 0){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMail);
                        return results[0].isSuccess();
                    }
                    else{
                        return false;
                    }
                }
                else{
                    return true;
                }
                
            }
            else{
                return false;
            }
            
        }
        else{
            return false;
        }
        
    }
    
    /*
    @RemoteAction
    public static getUserReturnData fetchActiveSurveyData() {
        getUserReturnData rd = new getUserReturnData();
        Boolean isGARPEmployee = false;
        Boolean hasSignedNDA = false;
        String contactId = null;
        String accountId = null;
        ID indvAccountRecordTypeId = recordtypehelper.getRecordtypeID('Account','Individual');
        rd.indvAccountRecordTypeId = indvAccountRecordTypeId;
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [SELECT u.Id, u.ContactId, FullPhotoUrl FROM User u WHERE u.Id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            rd.userData = lstUser[0];        
            contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, FullName__c, LastName, Email, Phone, HomePhone, OtherPhone, Title, Risk_Manager_of_the_Year_Bio__c,
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Mailing_Address_Company__c, Account.BillingCountry,
                                        RPT_Clean_Country__c, AccountId, GARP_ID__c, Membership_Type__c, Job_Function__c, Company__c, 
                                        Area_of_Concentration__c, Corporate_Title__c, Company_Account__r.Name
                                        FROM Contact WHERE Id = :contactId AND GBI_Participant__c = True];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                rd.contactData = lstContact[0];
                accountId = lstContact[0].AccountId;
                
                // Direct Parent Account of Conatct
                List<Account> lstAccount = [SELECT Id, Name, RecordTypeID, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone FROM Account WHERE Id = :accountId];
                if( lstAccount != null && lstAccount.size() > 0 ) {
                    rd.accountData = lstAccount[0];
                    if(rd.accountData.Name == 'GARP')
                        isGARPEmployee = true;
                }
                                
                // If direct Parent Account not GARP, check AccountContactRole to see if they are GARP related
                if(isGARPEmployee == false) {
                    List<AccountContactRelation> lstAcctContRoles = [select Id, AccountId, Account.Name, ContactId, IsDirect from AccountContactRelation where ContactId = :contactId];
                    if( lstAcctContRoles != null && lstAcctContRoles.size() > 0 ) {
                        for(AccountContactRelation acr : lstAcctContRoles) {
                            if(acr.Account.Name == 'GARP') {
                                isGARPEmployee = true;
                                break;
                            }
                        }
                    }
                }
                rd.isGARPEmployee = isGARPEmployee;
                system.debug('isGARPEmployee:' + isGARPEmployee);
                
                Contact myContact;
                
                Set<ID> allStudies = new Set<ID>();
                
                Set<ID> myStudies = new Set<ID>();
                MAP<ID,Study_Contact__c> myStudiesAccounts = new MAP<ID,Study_Contact__c>();        // Study_Account__c Id
                Set<ID> myStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c
                
                Set<ID> studiesWithDP = new Set<ID>();
                Set<ID> faqCategoryIds = new Set<ID>();
                Set<ID> studyVoteIds = new Set<ID>();
                Set<ID> studyVoteQuestionsIds = new Set<ID>();
                Set<ID> studyWaiverIds = new Set<ID>();
                Set<ID> studyRoundIds = new Set<ID>();
                Set<ID> studyContactIds = new Set<ID>();
                Set<String> studyDocumentFolders = new Set<String>();
                MAP<ID, ID> mapStudyDP = new MAP<ID, ID>();
                
                // Study Id to DP_Not_Required__c map. Used only for Non-GARP employee.
                Map<Id, Boolean> mapDPNotRequired = new Map<Id, Boolean>();
                // Study Id to Study Account Id map. Used only for Non-GARP employee.
                Map<Id, Id> mapStudyIdToStudyAccountId = new Map<Id, Id>();
                
                // All Active Studies with Study Accounts
                List<Study__c> lstStudy = [SELECT Id, Name, Parent_Study__c, Parent_Study__r.Name, Type__c, Description__c, Status__c, Start_Date__c, End_Date__c, Conference_Call_Status__c, Conference_Call_Details__c, FAQ_Category__c, Document_Folder_Name__c, Risk_Type__c, Study_Objective__c, Data_Provided__c, Disclosure_Protocol__c, Reference_Study__c, Number_of_Participants__c, Data_Types_Supported__c, Qualtrics_Survey_Integration_Status__c,
                                           (SELECT Id, Name, Account__c, Role__c, Status__c FROM Study_Accounts__r)
                                           FROM Study__c WHERE Status__c IN ('In Progress')];
                rd.studies = lstStudy;
                //system.debug('lstStudy:' + lstStudy);
            }
        }
        return rd;        
    }
    */
    
    // Primary check for user accesses
    @RemoteAction
    public static getUserReturnData fetchUserData() {
        getUserReturnData rd = new getUserReturnData();
        Boolean isGARPEmployee = false;
        Boolean hasSignedNDA = false;
        String contactId = null;
        String accountId = null;
        ID indvAccountRecordTypeId = recordtypehelper.getRecordtypeID('Account','Individual');
        rd.indvAccountRecordTypeId = indvAccountRecordTypeId;
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [SELECT u.Id, u.ContactId, FullPhotoUrl FROM User u WHERE u.Id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            rd.userData = lstUser[0];        
            contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, FullName__c, LastName, Email, Phone, HomePhone, OtherPhone, Title, Risk_Manager_of_the_Year_Bio__c,
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Mailing_Address_Company__c, Account.BillingCountry,
                                        RPT_Clean_Country__c, AccountId, GARP_ID__c, Membership_Type__c, Job_Function__c, Company__c, GBI_Analytics_Participant__c,
                                        GBI_Pillar_3_Attestation__c,Area_of_Concentration__c, Corporate_Title__c, Company_Account__r.Name,Photo_URL__c
                                        FROM Contact WHERE Id = :contactId AND GBI_Participant__c = True];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                rd.contactData = lstContact[0];
                accountId = lstContact[0].AccountId;
                
                // Direct Parent Account of Conatct
                List<Account> lstAccount = [SELECT Id, Name, RecordTypeID, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone FROM Account WHERE Id = :accountId];
                if( lstAccount != null && lstAccount.size() > 0 ) {
                    rd.accountData = lstAccount[0];
                    if(rd.accountData.Name == 'GARP')
                        isGARPEmployee = true;
                }
                                
                // If direct Parent Account not GARP, check AccountContactRole to see if they are GARP related
                if(isGARPEmployee == false) {
                    List<AccountContactRelation> lstAcctContRoles = [select Id, AccountId, Account.Name, ContactId, IsDirect from AccountContactRelation where ContactId = :contactId];
                    if( lstAcctContRoles != null && lstAcctContRoles.size() > 0 ) {
                        for(AccountContactRelation acr : lstAcctContRoles) {
                            if(acr.Account.Name == 'GARP') {
                                isGARPEmployee = true;
                                break;
                            }
                        }
                        
                        /* Comment out to save SOQL - get Account.Name from AccountContactRole directly
                        Set<ID> acctIds = new Set<ID>();
                        for(AccountContactRole acr :lstAcctContRoles) {
                            acctIds.add(acr.AccountId);
                        }
                        List<Account> lstAccts = [select Id, Name from Account where Id in :acctIds];
                        if(lstAccts != null && lstAccts.size() > 0) {
                            for(Account acct :lstAccts) {
                                if(acct.Name == 'GARP')
                                    isGARPEmployee = true;
                            }
                        }*/
                    }
                }
                rd.isGARPEmployee = isGARPEmployee;
                system.debug('isGARPEmployee:' + isGARPEmployee);
                
                Contact myContact;
                
                Set<ID> allStudies = new Set<ID>();
                
                Set<ID> myStudies = new Set<ID>();
                MAP<ID,Study_Contact__c> myStudiesAccounts = new MAP<ID,Study_Contact__c>();        // Study_Account__c Id
                Set<ID> myStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c
                
                Set<ID> studiesWithDP = new Set<ID>();
                Set<ID> faqCategoryIds = new Set<ID>();
                Set<ID> studyVoteIds = new Set<ID>();
                Set<ID> studyVoteQuestionsIds = new Set<ID>();
                Set<ID> studyWaiverIds = new Set<ID>();
                Set<ID> studyRoundIds = new Set<ID>();
                Set<ID> studyContactIds = new Set<ID>();
                Set<String> studyDocumentFolders = new Set<String>();
                MAP<ID, ID> mapStudyDP = new MAP<ID, ID>();
                
                // Study Id to DP_Not_Required__c map. Used only for Non-GARP employee.
                Map<Id, Boolean> mapDPNotRequired = new Map<Id, Boolean>();
                // Study Id to Study Account Id map. Used only for Non-GARP employee.
                Map<Id, Id> mapStudyIdToStudyAccountId = new Map<Id, Id>();
                
                // All Active Studies with Study Accounts
                List<Study__c> lstStudy = [SELECT Id, Name, Parent_Study__c, Parent_Study__r.Name, Type__c, Description__c, Status__c, 
                                                  Start_Date__c, End_Date__c, Conference_Call_Status__c, Conference_Call_Details__c, FAQ_Category__c, 
                                                  Document_Folder_Name__c, Risk_Type__c, Study_Objective__c, Data_Provided__c, Disclosure_Protocol__c, 
                                                  Reference_Study__c, Number_of_Participants__c, Data_Types_Supported__c, Qualtrics_Survey_Integration_Status__c,
                                                  Payment_Required__c,Study_Fee__c,
                                           (SELECT Id, Name, Account__c, Role__c, Status__c,Payment_Agreed_Amount__c,Payment_Agreed_Date__c FROM Study_Accounts__r)
                                           FROM Study__c WHERE Status__c IN ('In Progress','Completed')];
                rd.studies = lstStudy;
                //system.debug('lstStudy:' + lstStudy);
                                
                for(Study__c study :lstStudy) {
                    allStudies.add(study.Id);
                    faqCategoryIds.add(study.FAQ_Category__c);
                    studyDocumentFolders.add(study.Document_Folder_Name__c);
                }                    

                // Studies Contacts from Studies I participated In
                List<Study_Contact__c> lstStudyContact;
                if(isGARPEmployee) {
                    lstStudyContact = [SELECT Id, Name, Role__c, Status__c, Study__c, Contact__c, Contact__r.Name, Contact__r.Photo_URL__c, Contact__r.AccountId, Study_Account__r.Account__c, Study_Account__c, Study_Account__r.Status__c, Study_Account__r.Name, Study_Account__r.Id 
                                       FROM Study_Contact__c WHERE Status__c IN ('Active','Confirmed') AND Study__c in :lstStudy and Study__r.Status__c IN ('In Progress')];
                    // Simulate GARP Employee are in all Studies
                    for(Study__c s :lstStudy) {
                        Study_Contact__c newSc = new Study_Contact__c();
                        newSc.Study__c = s.Id;
                        newSc.Contact__c = contactId;
                        newSc.Study_Account__c = accountId;
                        lstStudyContact.add(newSc);
                    }                    
                }else {
                    lstStudyContact = [SELECT Id, Name, Role__c, Status__c, Study__c, Contact__c, Contact__r.Name, Contact__r.Photo_URL__c, Contact__r.AccountId, Study_Account__r.Account__c, Study_Account__c, Study_Account__r.Status__c, Study_Account__r.Name, Study_Account__r.Role__c, Study_Account__r.Id, Study_Account__r.DP_Not_Required__c
                                       FROM Study_Contact__c WHERE Contact__c = :contactId AND Status__c IN ('Active','Confirmed') 
                                       AND Study_Account__r.Status__c = 'Active'];
                    
                    // For later use of DP not required for Non-GARP employee
                    for(Study_Contact__c sc : lstStudyContact) {
                        mapDPNotRequired.put(sc.Study__c, sc.Study_Account__r.DP_Not_Required__c);
                        mapStudyIdToStudyAccountId.put(sc.Study__c, sc.Study_Account__r.Id);
                    }
                }
                //rd.studyContacts = lstStudyContact;                
                                
                for(Study_Contact__c sc :lstStudyContact) {
                    myStudies.add(sc.Study__c);
                    if(sc.Contact__c == contactId) {
                        myStudiesAccounts.put(sc.Study_Account__c, sc);
                        myStudiesAccountIds.add(sc.Study_Account__r.Account__c);
                    }
                    studyContactIds.add(sc.Contact__c);
                }
                system.debug('myStudiesAccounts:' + myStudiesAccounts);
                
                rd.disclosureProtocols  = [select Id, Name, Study__c, Disclosure_Protocol__c, DP_Status__c, CurrencyIsoCode,
                (select Id, Name FROM Study_Disclosure_Protocol_Submissions__r WHERE Study_Contact__r.Contact__c = :contactId)
                 from Disclosure_Protocol__c WHERE DP_Status__c = 'Active'];
                
                List<Study_NDA__c> lstNDAs = [
                    SELECT Id, Account__c, Status__c, Latest_NDA_Dated_Date__c, Next_NDA_Review_Date__c, 
                    (SELECT Id, Name FROM Attachments)
                    FROM Study_NDA__c 
                    WHERE Account__c IN :myStudiesAccountIds and Status__c IN ('Signed','Expired')
                    ORDER BY Latest_NDA_Dated_Date__c DESC NULLS LAST
                ];
                                
                system.debug('lstNDAs:' + lstNDAs);
                
                List<Study_NDA__c> lstNDAFinal = new List<Study_NDA__c>();
                Study_NDA__c lastNDA;
                Date lastNDADate = Date.newInstance(1900, 1, 1);
                
                if(lstNDAs.size() > 0) {
                    lastNDA = lstNDAs[0];
                    lastNDADate = lstNDAs[0].Latest_NDA_Dated_Date__c;
                }
                
                for(Study_NDA__c nda :lstNDAs) {
                    /*if(nda.Latest_NDA_Dated_Date__c > lastNDADate) {
                        lastNDADate = nda.Latest_NDA_Dated_Date__c;
                        lastNDA = nda;
                    }*/
                    if(nda.Status__c == 'Signed') {
                        hasSignedNDA = true;
                        break;
                    }
                }
                
                if(lastNDA != null)
                    lstNDAFinal.add(lastNDA);
                
                rd.studyNDAs = lstNDAFinal;
                
                system.debug('hasSignedNDA:' + hasSignedNDA);
                                
                // DP Submissions from Studies I participated In
                List<Study_Disclose_Protocol_Submission__c> submissionDPs;
                if(isGARPEmployee) {
                    // Simulate GARP Employee have submitted all DPs
                    submissionDPs = new List<Study_Disclose_Protocol_Submission__c>();
                    for(Study__c s :lstStudy) {
                        Study_Disclose_Protocol_Submission__c newSds = new Study_Disclose_Protocol_Submission__c();
                        newSds.Study__c = s.Id;
                        newSds.Study_Account__c = accountId;
                        newSds.Study_Contact__c = contactId;
                        submissionDPs.add(newSds);
                    }
                }else {
                    submissionDPs = [SELECT Id, Name, Study_Account__c, Study_Account__r.Account__c, Study_Contact__c, Signed_Date_Time__c, Study__c, Disclosure_Protocol__c
                                FROM Study_Disclose_Protocol_Submission__c WHERE study__c IN :myStudies AND Study_Account__c IN :myStudiesAccounts.keySet()];
                    
                    // Simulate DP submitted if the Study Account enabled DP_Not_Required__c
                    for(Id oneMyStudy : myStudies) {
                        if(true == mapDPNotRequired.get(oneMyStudy)) {
                            submissionDPs.add(new Study_Disclose_Protocol_Submission__c(
                                Study__c = oneMyStudy, Study_Account__c = mapStudyIdToStudyAccountId.get(oneMyStudy), Study_Contact__c = contactId
                            ));
                        }
                    }
                }
                rd.submissionDPs = submissionDPs;
                
                for(Study_Disclose_Protocol_Submission__c dp :submissionDPs) {
                    mapStudyDP.put(dp.Study__c, dp.Study__c);
                }
                
                system.debug('mapStudyDP:' + mapStudyDP);

                // Allow access to Completed Studies for Active users
                for(Study__c study :lstStudy) {
                    if(study.Status__c == 'Completed') {
                        // Already have a DP?
                        String fndDP = mapStudyDP.get(study.Id);
                        // Dont have
                        if(fndDP == NULL) {
                            // Add One
                            Study_Disclose_Protocol_Submission__c newSds = new Study_Disclose_Protocol_Submission__c();
                            newSds.Study__c = study.Id;
                            newSds.Study_Account__c = accountId;
                            newSds.Study_Contact__c = contactId;
                            submissionDPs.add(newSds);
                        }
                    }
                }                    

                // Recompute DPs
                for(Study_Disclose_Protocol_Submission__c dp :submissionDPs) {
                    mapStudyDP.put(dp.Study__c, dp.Study__c);
                }

                
                // Compute Studies I participated In with DP and NDA signed
                for(Study_Contact__c sc :lstStudyContact) {
                    if((mapStudyDP.get(sc.Study__c) != null && hasSignedNDA == true) || isGARPEmployee)
                        studiesWithDP.add(sc.Study__c);
                }
                system.debug('studiesWithDP:' + studiesWithDP);
                
                if(isGARPEmployee) {
                   rd.studyContacts = lstStudyContact;  
                } else {
                    // Used cross pages, if DP/NDA signed, users can also view contacts from other organizations
                    lstStudyContact = [SELECT Id, Name, Role__c, Status__c, Study__c, Contact__c, Contact__r.Name, Contact__r.Photo_URL__c, Contact__r.AccountId, Study_Account__r.Account__c, Study_Account__r.Account__r.Id, Study_Account__c, Study_Account__r.Status__c, Study_Account__r.Name 
                                       FROM Study_Contact__c WHERE (Study__c IN :studiesWithDP OR Study_Account__c IN :myStudiesAccounts.keySet())
                                       AND Status__c = 'Active' AND Study_Account__r.Status__c = 'Active'];                
                    rd.studyContacts = lstStudyContact;                      
                }
                           
                system.debug('lstStudyContact:' + lstStudyContact);     
                
                // Study Account from all studies
                List<Study_Account__c> lstStudyAccounts = [SELECT Id, Name, Role__c, Status__c, Study__c, Account__c, Account__r.Name, Account__r.Alternate_Name__c, Account__r.Firm_Type__c, Account__r.Number_of_Studies__c, Account__r.Region__c, Account__r.BillingCountry, Account__r.CPE_Provider_Logo__c, Account__r.Description, Account__r.GBI_Region__c, Account__r.GBI_Country_Code__c,Payment_Agreed_Amount__c,Payment_Agreed_Date__c,
                                                           Account__r.GBI_Pillar_Start_Date__c, Account__r.GBI_Pillar_Impact_Start_Date__c, Account__r.GBI_Pillar_Impact_End_Date__c
                                                           FROM Study_Account__c WHERE (Status__c = 'Active' OR Status__c = 'Confirmed') AND Study__c in :allStudies];
                rd.studyAccounts = lstStudyAccounts;
                               
                List<User> studyUsers = [Select Id, Name, ContactId, FullPhotoUrl from User where ContactId in :studyContactIds];
                rd.studyUsers = studyUsers;
                                
                // Study Round with Attachments from Studies I participated In that have submitted a DP and NDA signed
                List<Study_Round__c> studyRounds = [SELECT Id, Name, Description__c, Published_Date__c, Round__c, Status__c, Study__c, Data_Collection_Start_Date__c, Data_Collection_End_Date__c, Current_Version__c, Result__c, Approved_Date__c, Version__c, 
                                                    (SELECT Id,Name,CreatedDate FROM Attachments ORDER BY CreatedDate DESC) 
                                                    FROM Study_Round__c WHERE Study__c in :studiesWithDP AND Status__c in ('Active','Completed','Voting','Data Collection')];
                rd.studyRounds = studyRounds;
                
                for(Study_Round__c sr :studyRounds)
                    studyRoundIds.add(sr.Id);
                
                // Study Vote info from Studies I participated In that have submitted a DP and NDA signed
                List<Study_Vote__c> studyVotes = [SELECT Id, Name, Start_Date__c, End_Date__c, Status__c, Description__c, Study__c, Vote_Options__c FROM Study_Vote__c WHERE Study__c IN :studiesWithDP];
                
                
                List<Study_Vote__c> studyVotesFinal = new List<Study_Vote__c>();
                for(Study_Vote__c sv :studyVotes) {
                    Boolean canVote = True;
                    if(isGARPEmployee == True) {
                        canVote = False;
                    } else {
                        for(Study_Contact__c sc :myStudiesAccounts.values()) {
                            if(sc.Study__c == sv.Study__c) {
                                if(sc.Study_Account__r.Role__c == 'Other' || sc.Study_Account__r.DP_Not_Required__c == True) {
                                    canVote = False;
                                }
                            }
                        }
                    }
                    if(canVote == True) {
                        studyVotesFinal.add(sv);
                    }
                }
                
                //System.assert(false, 'BOOM!'+ studyVotesFinal);

                
                rd.studyVotes = studyVotesFinal;
                
                for(Study_Vote__c sv :studyVotesFinal)
                    studyVoteIds.add(sv.Id);
                
                List<Study_Vote_Question__c> studyVoteQuestions = [select Id, Name, Question__c, Answers__c, Study_Vote__c FROM Study_Vote_Question__c where Study_Vote__c in :studyVoteIds];
                rd.studyVoteQuestions = studyVoteQuestions;
                
                for(Study_Vote_Question__c sv :studyVoteQuestions)
                    studyVoteQuestionsIds.add(sv.Id);
                
                List<Study_Contact_Vote__c> studyContactVotes = [select Id, Name, Study_Contact__c, Study_Account__c, Study_Vote_Question__c, Study_Vote_Question__r.Study_Vote__c, Vote_Made_Date_Time__c FROM Study_Contact_Vote__c where Cancel_Vote__c = FALSE AND Study_Vote_Question__c in :studyVoteQuestionsIds];
                rd.studyContactVotes = studyContactVotes;
                
                // Study Data Submission info from Studies I participated In that have submitted a DP and NDA signed
                List<Study_Data_Submission__c> studyDataSubmissions = [SELECT Id, Name, Study_Account__c, Submission_Date_Time__c, Study_Round__c 
                                                                       FROM Study_Data_Submission__c WHERE Study_Account__c IN :myStudiesAccounts.keySet() AND Study_Round__c IN :studyRoundIds];
                rd.studyDataSubmissions = studyDataSubmissions;
                
                // GBI General Documents - No Study__c
                List<Study_Document__c> graDocuments = [SELECT Id, Name, Description__c, Current_Version__c, Secure_Location__c, Study__c, Date_Added__c, Last_Modified__c, Folder__c,
                                                        (SELECT Id,Name, CreatedDate  FROM Attachments order by CreatedDate DESC) 
                                                        FROM Study_Document__c WHERE Study__c = null];
                rd.graDocuments = graDocuments;
                
                // Study Documents info from Studies I participated In that have submitted a DP and NDA signed
                List<Study_Document__c> docs = [SELECT Id, Name, Description__c, Current_Version__c, Secure_Location__c, Study__c, Date_Added__c, Last_Modified__c, Folder__c,
                                                (SELECT Id,Name, CreatedDate FROM Attachments ORDER BY CreatedDate DESC) 
                                                FROM Study_Document__c WHERE Study__c IN :studiesWithDP];
                rd.studyDocuments = docs;
                
                // FAQ Info - Majorly from faqCategoryIds (Lookup on Study__c)
                List<FAQ_Category__c> allFAQCates = [SELECT Id, Name, FAQ_Category__c,
                                                     (SELECT Id, Name, FAQ_Category__c, Section_Order_Number__c FROM FAQ_Section_del__r),
                                                     (SELECT Id, Name, FAQ_Category__c, FAQ_Section__c, Related_Section_Order_Number__c, Subsection_Order_Number__c FROM FAQ_Subsection__r),
                                                     (SELECT Id, Name, FAQ_Category__c, FAQ_Section__c, FAQ_Subsection__c, FAQ_Rank__c, FAQ_Question__c, FAQ_Answer__c, FAQ_Section_Order__c, FAQ_Subsection_Order__c, Related_Subsection__c FROM Frequently_Asked_Questions_del__r)
                                                     FROM FAQ_Category__c WHERE Name = 'GBI' OR Id IN :faqCategoryIds];
                
                List<FAQ_Category__c> faqCategories = new List<FAQ_Category__c>();
                List<FAQ_Section__c>  listFAQSections = new List<FAQ_Section__c>();
                List<FAQ_Subsection__c> listFAQSubSections = new List<FAQ_Subsection__c>();
                List<Frequently_Asked_Questions__c> FAQs = new List<Frequently_Asked_Questions__c>();
                
                for(FAQ_Category__c oneCat : allFAQCates) {
                    faqCategories.add(new FAQ_Category__c(Id=oneCat.Id, Name=oneCat.Name, FAQ_Category__c=oneCat.FAQ_Category__c));
                    listFAQSections.addAll(oneCat.FAQ_Section_del__r);
                    listFAQSubSections.addAll(oneCat.FAQ_Subsection__r);
                    FAQs.addAll(oneCat.Frequently_Asked_Questions_del__r);
                }
                
                rd.faqCategories =faqCategories;
                rd.listFAQSections = listFAQSections;
                rd.listFAQSubSections = listFAQSubSections;
                rd.FAQs = FAQs;
                
                
                System.debug('studiesWithDP!'+ studiesWithDP);
                
                List<Study_Survey__c> lstStudySurveys = [select Id, Name, Description__c, Study__c, End_Date__c from Study_Survey__c where 
                                   Study__c in :studiesWithDP AND Status__c = 'Active' AND (Start_Date__c = NULL OR Start_Date__c <= TODAY) AND (End_Date__c = NULL OR End_Date__c >= TODAY)];
    
                System.debug('lstStudySurveys!'+ lstStudySurveys);
                
                
                List<Study_Survey_Submission__c> lstStudySurveysSubmissions = [select Id, Study_Survey__c from Study_Survey_Submission__c where Study_Survey__r.Study__c IN :studiesWithDP AND Status__c = 'Submitted' AND Study_Account__c IN :myStudiesAccounts.keySet()];
                map<String,Study_Survey_Submission__c> mapSubmissions = new map<String,Study_Survey_Submission__c>();
                for(Study_Survey_Submission__c sss :lstStudySurveysSubmissions) {
                    mapSubmissions.put(sss.Study_Survey__c, sss);
                }
                System.debug('mapSubmissions!'+ mapSubmissions);
                
                rd.studySurveys = new List<Study_Survey__c>();
                for(Study_Survey__c ss :lstStudySurveys) {
                    Study_Survey_Submission__c fndSubmission = mapSubmissions.get(ss.Id);
                    if(fndSubmission == NULL) {
                        rd.studySurveys.add(ss);
                    }
                }
                System.debug('rd.studySurveys!'+ rd.studySurveys);
                
                
                // Comment out to save SOQLs. Gather all SOQLs into one
                /* List<FAQ_Category__c> faqCategories = [select Id, Name, FAQ_Category__c from FAQ_Category__c where Name = 'GBI'];
                for(FAQ_Category__c faq :faqCategories)
                    faqCategoryIds.add(faq.Id);
                
                faqCategories = [select Id, Name, FAQ_Category__c from FAQ_Category__c where Id in :faqCategoryIds];
                rd.faqCategories =faqCategories;
                
                List<FAQ_Section__c>  listFAQSections = [select Id, Name, FAQ_Category__c, Section_Order_Number__c from FAQ_Section__c where FAQ_Category__c in :faqCategoryIds];
                rd.listFAQSections = listFAQSections;
                
                List<FAQ_Subsection__c>  listFAQSubSections = [select Id, Name, FAQ_Category__c, FAQ_Section__c, Related_Section_Order_Number__c, Subsection_Order_Number__c from FAQ_Subsection__c where FAQ_Category__c in :faqCategoryIds];
                rd.listFAQSubSections = listFAQSubSections;
                
                List<Frequently_Asked_Questions__c> FAQs = [select Id, Name, FAQ_Category__c, FAQ_Section__c, FAQ_Subsection__c, FAQ_Rank__c, FAQ_Question__c, FAQ_Answer__c, FAQ_Section_Order__c, FAQ_Subsection_Order__c, Related_Subsection__c from Frequently_Asked_Questions__c where FAQ_Category__c in :faqCategoryIds];
                rd.FAQs = FAQs; */
                
                rd.gbiUpdates = [select Id, Name, Description__c, Intro_Description__c, Publish_Date__c, Status__c, Title__c, Visibility__c from GBI_Update__c order by Publish_Date__c DESC];
                
                rd.studyAccountCount = [SELECT Study__c, count(Id) FROM Study_Account__c WHERE Status__c = 'Active' GROUP BY Study__c];
            }
        }
        return rd;
    }
    
    @RemoteAction
    public static pillar3Filters getPillar3Filters () {
        pillar3Filters filters = new pillar3Filters();
        filters.lstCurrencies = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Pillar_3_Institution__c').getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklistEntries = fieldMap.get('Currency__c').getDescribe().getPicklistValues();
        for( Schema.PicklistEntry ple : picklistEntries)
        {
            filters.lstCurrencies.add(ple.getLabel());
        }
        filters.lstCurrencies.sort();
        filters.lstInstitutions = [SELECT Name, Country__c, Country_Code__c, Alias__c, Institution_Type__c FROM Pillar_3_Institution__c where Active__c = True];
        filters.dates = Pillar_3_Dates__c.getValues('Default Dates');
        return filters;
    }
    
    @RemoteAction
    public static List<Pillar_3_Report__c> getPillar3Menu () {
        List<Pillar_3_Report__c> reportList = [SELECT Name, Viz_URL__c, Parent_Menu__c, Has_Submenu__c, Is_Top_Menu__c, Order__c, Tab_Color__c FROM Pillar_3_Report__c order by Order__c];
        return reportList;
    }
    
    @RemoteAction
    public static List<Pillar_3_Notification__c> getPillar3Notifications () {
        List<Pillar_3_Notification__c> notifList = [SELECT Name, Title__c, Type__c,Type_Color__c, Notification_Date__c FROM Pillar_3_Notification__c WHERE Active__c = True order by Notification_Date__c desc, Priority__c desc];
        return notifList;
    }
}