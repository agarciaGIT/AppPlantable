/*
*   @Desciption     :   Plantable OnBoarding Business class, execute request in sf and return result
*   @Create date    :   08-21-2022
*   @Author         :   Alberto Garcia
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_OnBoarding_BC {
    
    // TO DO
    public static Map<String,String> getClassDetail(){
        Map<String,String> metodsMap = new Map<String,String>();
        //string Name, String Type, String rtnType, String param, String detail
        metodsMap.put('getAllActiveMeals',Plant_Utility.setMethodEntry('getAvailableDates', 'get', 'Plant_Utility.responseWrapper','NONE', 'Return all active Meals records'));
        metodsMap.put('updateMealSelection',Plant_Utility.setMethodEntry('updateMealSelection', 'set', 'Plant_Utility.responseWrapper','MealSelectionReq_Wrapper wrapper object', 'Ad new meal list from Meal selection'));
        return metodsMap;
    }
    
    public Plant_Utility.responseWrapper getOnBoardingStatus(autorize_AccountReq reqWrap){
        
        System.Debug('!!Plant_OnBoarding_BC:' + reqWrap);
        
        String statusCode='';
        String status='';
        String msg='';
        
        if(reqWrap!=null && !String.isBlank(reqWrap.accountId)){        
            List<OnBoarding__c> lstOnboards = [select Id, Current_Step__c, Call_Date_Time__c, Plant_Leaning_Product__c, Plant_Learning_Current_Day__c, Plant_Learning_Start_Date__c,
                                               (select OnBoarding_Question__c, OnBoarding_Question_Option__c, Scale_1_to_10__c, Selected_Date__c, Text__c from  OnBoarding_Answers__r)
                                               from OnBoarding__c where Account__c = :reqWrap.accountId];
            if(lstOnboards.isEmpty()) {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','No OnBoarding found for this Account: ' + reqWrap.accountId,new Plant_Utility.responseListWrapper(new List<String>()));
                return responseWrap;                
            } else {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Onboarding returned',new Plant_Utility.responseListWrapper(lstOnboards));
                return responseWrap;
            }
        } else {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Missing account Id',new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;
        }

    }
    
    // Learning Item Calls
    public Plant_Utility.responseWrapper getLearningItems(autorize_OnBoardingReq reqWrap){
        List<Plant_Learning_Item__c> lstLearningItems = [select Id, Plant_Title__c, Plant_Content__c, Plant_Day_Number__c from Plant_Learning_Item__c where Plant_Product__c =: reqWrap.product];
                                           
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','List of learning items',new Plant_Utility.responseListWrapper(lstLearningItems));
        return responseWrap;
    }
    
    public Plant_Utility.responseWrapper setOnBoardingLearningDay(autorize_OnBoardingReq reqWrap){
        
        List<OnBoarding__c> lstObqs = [select Id, Plant_Learning_Current_Day__c from OnBoarding__c where id = :reqWrap.onboardingId];
        if(lstObqs.isEmpty()) {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','No OnBoarding found with this Id: ' + reqWrap.onboardingId,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;                            
        } else {
            if(reqWrap.day == NULL) {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Invalid day given:' + reqWrap.step,new Plant_Utility.responseListWrapper(new List<String>()));
                return responseWrap;                            
            } else {
                lstObqs[0].Plant_Learning_Current_Day__c = reqWrap.day;    
                update lstObqs;
            }
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Onboarding status set',new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }
    
    // callReqStartDate - Date to start returning values
    // callReqNumberDays - Number of days to return
    public Plant_Utility.responseWrapper getOnBoardingCalls(autorize_AccountReq reqWrap){
        
        System.Debug('!!Plant_OnBoarding_BC:' + reqWrap);
        
        String statusCode='';
        String status='';
        String msg='';
        
        if(reqWrap!=null && reqWrap.callReqStartDate != NULL && reqWrap.callReqNumberDays != NULL){
            List<OnBoarding__c> lstOnboards = [select Call_Date_Time__c from OnBoarding__c 
                                               where Call_Date_Time__c != NULL AND
                                               Call_Date_Time__c >= :reqWrap.callReqStartDate AND
                                               Call_Date_Time__c <= :reqWrap.callReqStartDate.addDays(reqWrap.callReqNumberDays)
                                               Order By Call_Date_Time__c
                                              ];
            Map<String, List<String>> meal_DatesList_Map = new Map<String, List<String>>();
            List<String> dates = new List<String>();
            for(OnBoarding__c ob :lstOnboards) {
                ob.Call_Date_Time__c = ob.Call_Date_Time__c.addHours(-4);
                //dates.add(String.ValueOf(ob.Call_Date_Time__c));
                //dates.add('bob');
            }
            meal_DatesList_Map.put('callDates',dates);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','List of existing appointments',new Plant_Utility.responseListWrapper(lstOnboards));
            return responseWrap;
        } else {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Missing start date or number of days',new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;            
        }
    }


    public Plant_Utility.responseWrapper setOnBoardingStep(autorize_OnBoardingReq reqWrap){
        
        List<OnBoarding__c> lstObqs = [select Id, Current_Step__c from OnBoarding__c where id = :reqWrap.onboardingId];
        if(lstObqs.isEmpty()) {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','No OnBoarding found with this Id: ' + reqWrap.onboardingId,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;                            
        } else {
            if(reqWrap.step == NULL || (reqWrap.step != 'Survey Completed' && reqWrap.step != 'Call Scheduled' && reqWrap.step != 'Call Completed')) {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Invalid step given:' + reqWrap.step,new Plant_Utility.responseListWrapper(new List<String>()));
                return responseWrap;                            
            } else {
                lstObqs[0].Current_Step__c = reqWrap.step;    
                update lstObqs;
            }
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Onboarding status set',new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;

    }

    public Plant_Utility.responseWrapper setOnBoardingCallDateTime(autorize_OnBoardingReq reqWrap){
        
        List<OnBoarding__c> lstObqs = [select Id, Call_Date_Time__c from OnBoarding__c where id = :reqWrap.onboardingId];
        if(lstObqs.isEmpty()) {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','No OnBoarding found with this Id: ' + reqWrap.onboardingId,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;                            
        } else {
            if(reqWrap.callDateTime == NULL) {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','callDateTime missing:' + reqWrap.step,new Plant_Utility.responseListWrapper(new List<String>()));
                return responseWrap;                            
            } else {
                
                String hhs = reqWrap.callDateTime.format('HH');
                Integer hhi = Integer.ValueOf(hhs)+4;
                hhs = String.ValueOf(hhi);
                
                String mms = reqWrap.callDateTime.format('mm');
                Integer mmi = Integer.ValueOf(mms);
                String sss = reqWrap.callDateTime.format('ss');
                Integer ssi = Integer.ValueOf(sss);
                
                System.Debug('callDateTimeS:' + hhs + ':' + mms + ':' + sss);
                System.Debug('callDateTimeI:' + hhi + ':' + mmi + ':' + ssi);
                
                if(hhi < 9 || hhi > 17 || (mmi != 0 && mmi != 15 && mmi != 30 && mmi != 45) || ssi != 0) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Invalid meeting start time, can only be 9 - 5, on the hour, or on 15 min increments:' + reqWrap.step,new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                                                
                } else {
                
                    List<OnBoarding__c> lstOnboards = [select Id, Call_Date_Time__c from OnBoarding__c 
                                                       where Call_Date_Time__c != NULL 
                                                       AND
                                                       Call_Date_Time__c >= :reqWrap.callDateTime.addHours(4)
                                                       AND
                                                       Call_Date_Time__c <= :reqWrap.callDateTime.addHours(5)
                                                       Order By Call_Date_Time__c
                                                      ];
                    System.Debug('lstOnboards:' + lstOnboards);
                    
                    if(lstOnboards.isEmpty()){
                        lstObqs[0].Call_Date_Time__c = reqWrap.callDateTime.addHours(4); 
                        update lstObqs;
                    } else {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','This time is already taken:' + reqWrap.step,new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                            
                    }                    
                }
            }
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Call Date Time Set',new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;

    }
    
    public Plant_Utility.responseWrapper setOnBoardingQuestion(autorize_OnBoardingReq reqWrap){
        
        try{ 
            
            if(reqWrap == NULL ||
               reqWrap.onboardingId == NULL ||
               reqWrap.questionId == NULL ||
               (reqWrap.answerOptionIds == NULL && 
                reqWrap.answerNumber == NULL &&
                reqWrap.answerDate == NULL &&
                reqWrap.answerString == NULL)) {
                
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Missing required information',new Plant_Utility.responseListWrapper(new List<String>()));
                    return responseWrap;                            
                }            

            OnBoarding_Answer__c onbAnswer = new OnBoarding_Answer__c(
                OnBoarding__c = reqWrap.onboardingId,
                OnBoarding_Question__c = reqWrap.questionId
            );
            System.Debug('setup onbAnswer:' + onbAnswer);

            
            List<OnBoarding_Question__c> lstQuests = [select Onboarding_Question_ID__c, Type__c,
                                                      (select Id, Option_Number__c, Option_Text__c from OnBoarding_Question_Options__r)
                                                      from OnBoarding_Question__c where id = :reqWrap.questionId];
            System.Debug('lstQuests:' + lstQuests);
            
            List<OnBoarding_Answer_Option__c> obAnswerOptions = new List<OnBoarding_Answer_Option__c>();
            
            if(!lstQuests.isEmpty()) {
                OnBoarding_Question__c quest = lstQuests[0];
                                
                SET<String> mapQuestionOptions = new SET<String>();
                if(quest.OnBoarding_Question_Options__r != NULL && !quest.OnBoarding_Question_Options__r.isEmpty()) {
                    for(OnBoarding_Question_Option__c obqo :quest.OnBoarding_Question_Options__r) {
                        mapQuestionOptions.add(obqo.id);                    
                    }
                }
                System.Debug('mapQuestionOptions:' + mapQuestionOptions);

                if(quest.Type__c == 'Multiple Choice - select one') {
                    
                    if(mapQuestionOptions.isEmpty()) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','502','Missing Answer Options for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                            
                        
                    } else if(reqWrap.answerOptionIds == NULL || reqWrap.answerOptionIds.isEmpty()) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','502','No answer option given for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                            
                    } else {
                        
                        if(reqWrap.answerOptionIds.size() > 1) {
                            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','503','Only 1 option allowed for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                            return responseWrap;                            
                        }
                        
                        for(String optId :reqWrap.answerOptionIds) {
                            if(!mapQuestionOptions.contains(optId)) {
                                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','504','Invalid option for this question:' + optId,new Plant_Utility.responseListWrapper(new List<String>()));
                                return responseWrap;                            
                            } else {
                                OnBoarding_Answer_Option__c obao = new OnBoarding_Answer_Option__c(
                                    OnBoarding_Question_Option__c = optId
                                );
                                obAnswerOptions.add(obao);
                            }
                        }    
                        System.Debug('obAnswerOptions:' + obAnswerOptions);
                    }
                } else if(quest.Type__c == 'Multiple Choice - select many') {
                    
                    if(mapQuestionOptions.isEmpty()) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','502','Missing Answer Options for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                                                    
                    } else if(reqWrap.answerOptionIds == NULL || reqWrap.answerOptionIds.isEmpty()) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','502','No answer option given for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                            
                    } else {
                        
                        for(String optId :reqWrap.answerOptionIds) {
                            if(!mapQuestionOptions.contains(optId)) {
                                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','503','Invalid option for this question:' + optId,new Plant_Utility.responseListWrapper(new List<String>()));
                                return responseWrap;                            
                            } else {
                                OnBoarding_Answer_Option__c obao = new OnBoarding_Answer_Option__c(
                                    OnBoarding_Question_Option__c = optId
                                );
                                obAnswerOptions.add(obao);
                            }
                        }                        
                        System.Debug('obAnswerOptions:' + obAnswerOptions);                    
                    }
                    
                } else if(quest.Type__c == 'Date') {
                    if(reqWrap.answerDate == NULL) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','504','Missing DATE answer options for question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;                                                    
                    } else {
                        onbAnswer.Selected_Date__c = reqWrap.answerDate;
                    }
                } else if(quest.Type__c == 'Short Text') {
                    if(reqWrap.answerString == NULL || reqWrap.answerString.length() == 0) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','505','Missing TEXT answer option for question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;   
                    } else {
                        if(reqWrap.answerString.length() > 255) {
                            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','506','TEXT answer too long for question',new Plant_Utility.responseListWrapper(new List<String>()));
                            return responseWrap;   
                        }
                        onbAnswer.Text__c = reqWrap.answerString;
                    }
                } else if(quest.Type__c == 'Long Text') {
                    if(reqWrap.answerString == NULL || reqWrap.answerString.length() == 0) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','507','Missing TEXT answer option for question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;   
                    } else {
                        if(reqWrap.answerString.length() > 1000) {
                            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','508','TEXT answer too long for question',new Plant_Utility.responseListWrapper(new List<String>()));
                            return responseWrap;   
                        }
                        onbAnswer.Text__c = reqWrap.answerString;
                    }
                } else if(quest.Type__c == 'Scale 1 - 10') {
                    if(reqWrap.answerNumber == NULL) {
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','509','Missing NUMBER answer option for question',new Plant_Utility.responseListWrapper(new List<String>()));
                        return responseWrap;   
                    } else {
                        if(reqWrap.answerNumber < 0 || reqWrap.answerNumber > 10) {
                            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','510','NUMBER answer needs to be between 0 and 10',new Plant_Utility.responseListWrapper(new List<String>()));
                            return responseWrap;   
                        }
                        onbAnswer.Scale_1_to_10__c = reqWrap.answerNumber;
                    }
                } else if(quest.Type__c == 'Display Text') {
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','511','No answers are allow for this question',new Plant_Utility.responseListWrapper(new List<String>()));
                    return responseWrap;   
                }
                System.Debug('onbAnswer:' + onbAnswer);                    
                
            } else {
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','Question not found',new Plant_Utility.responseListWrapper(new List<String>()));
                return responseWrap;                                            
            }
            
            if(reqWrap.answerId != NULL) {
                onbAnswer.Id = reqWrap.answerId;
            }
            System.Debug('upsert onbAnswer:' + onbAnswer);
            upsert onbAnswer;

            // Remove old options and add new ones
            if(reqWrap.answerId != NULL && !obAnswerOptions.isEmpty()) {
                List<OnBoarding_Answer_Option__c> lstExtOpts = [select Id from OnBoarding_Answer_Option__c where OnBoarding_Answer__c = :reqWrap.answerId];
                System.Debug('delete lstExtOpts:' + lstExtOpts);
                DELETE lstExtOpts;
            }
            
            if(!obAnswerOptions.isEmpty()) {
                for(OnBoarding_Answer_Option__c oa :obAnswerOptions) {
                    oa.OnBoarding_Answer__c = onbAnswer.Id;
                }
                System.Debug('insert obAnswerOptions:' + obAnswerOptions);
                INSERT obAnswerOptions;
            }
            
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Question Answer set',new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            String status = 'error';
            String statusCode='500';
            String msg='Internal Server Error: '+ex.getMessage();

            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;
        }

    }
    
    public Plant_Utility.responseWrapper getOnBoardingQuestions(autorize_OnBoardingReq reqWrap){
        
         List<OnBoarding_Question__c> lstQuests =
         [select Onboarding_Question_ID__c, Type__c, Question__c, Sort_Order__c, Display_Text_Button__c, Display_Text_Button_Help_Text__c,
                                                     (select Option_Number__c, Option_Text__c, Option_Image_URL__c, Sort_Order__c, If_Selected_Go_Here__r.Onboarding_Question_ID__c from OnBoarding_Question_Options__r)
                                                     from OnBoarding_Question__c where Products__c = :reqWrap.product];
         System.Debug('lstQuests:' + lstQuests);
         Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Onbaording survey questions returned',new Plant_Utility.responseListWrapper(lstQuests));
         return responseWrap;

     }
    
    // @Wrapper(w) class: 1
    // desc:  return OnBoarding from Account
    public class autorize_AccountReq{
        public String accountId; // account Id
        public Date callReqStartDate; 
        public Integer callReqNumberDays;
        //public String authenticationToken;

        public autorize_AccountReq parse(String json_po){
            return (autorize_AccountReq)JSON.deserialize(json_po, autorize_AccountReq.class);
        }
    }

    // @Wrapper(w) class: 2
    // desc:  return OnBoarding from OnBoarding
    public class autorize_OnBoardingReq {
        public String onboardingId; // account Id
        public String product; // account Id
        public String step; // account Id
        public DateTime callDateTime; // Call Appointment Date Time
        public Integer day; // account I
        
        public string onboadingId;
        public String questionId; 
        public string answerId;
        public List<String> answerOptionIds;
        public String answerString;
        public Date answerDate;
        public Decimal answerNumber;
        
        //public String authenticationToken;

        public autorize_OnBoardingReq parse(String json_po){
            return (autorize_OnBoardingReq)JSON.deserialize(json_po, autorize_OnBoardingReq.class);
        }
    }
    
}