/*
*   @Desciption     :   Plantable OnBoarding Service class, handle calles form API and LWC controllwr
*   @Create date    :   11-04-2022
*   @Author         :   Alberto Garcia
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

/*  
 *  API:
 *  GET Status - Returns OnBoarding Status for a new customer
 *  PUT Status - Sets OnBoarding Status for a new customer
 *  GET Questions - Returns questions for a given Product
 *  SET Answer - Sets OnBoarding Answer for a new customer for a given question
 * 
 */

public class Plant_OnBoarding_SC {
    
    // Constructor **
    public Plant_OnBoarding_SC() {
    }
    
    // @ Get onboarding status
    public static Plant_Utility.responseWrapper getOnBoardingStatus(Plant_OnBoarding_BC.autorize_AccountReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().getOnBoardingStatus(reqWrap);
        return response;
    }    
    
    
    public static Plant_Utility.responseWrapper getLearningItems(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().getLearningItems(reqWrap);
        return response;
    }    

    public static Plant_Utility.responseWrapper setOnBoardingLearningDay(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().setOnBoardingLearningDay(reqWrap);
        return response;
    }    
    
    public static Plant_Utility.responseWrapper setOnBoardingStatus(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().setOnBoardingStep(reqWrap);
        return response;
    }    

    public static Plant_Utility.responseWrapper getOnBoardingCalls(Plant_OnBoarding_BC.autorize_AccountReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().getOnBoardingCalls(reqWrap);
        return response;
    }    
    
    public static Plant_Utility.responseWrapper setOnBoardingCallDateTime(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().setOnBoardingCallDateTime(reqWrap);
        return response;
    }    

    public static Plant_Utility.responseWrapper getOnBoardingQuestions(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().getOnBoardingQuestions(reqWrap);
        return response;
    }    
    
    public static Plant_Utility.responseWrapper setOnBoardingQuestion(Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrap){
        System.Debug('!!Plant_OnBoarding_SC:' + reqWrap);
        Plant_Utility.responseWrapper response = new Plant_OnBoarding_BC().setOnBoardingQuestion(reqWrap);
        return response;
    }    

}