/*
*   @Desciption     :   Plantable Shipping Service class, handle calles form API and LWC controllwr
*   @Create date    :   20-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class plant_AuthorizeController_SC {
    
    // Default constructor
    public plant_AuthorizeController_SC() {

    }

    // @ Get all Authorization for an Account Id
    public static Plant_Utility.responseWrapper getAuthenticationTokenSC(plant_AuthorizeController.userInfoReqWrap jsonWrapper){
        Plant_Utility.responseWrapper Authorization_resultList = new plant_AuthorizeController().getAuthenticationToken(jsonWrapper);
        return Authorization_resultList;
    }
    
    // @ Generate or Refresh Authentication Token for an Account Id
    public static Plant_Utility.responseWrapper generateAccessTokenSC(plant_AuthorizeController.accessTokenReqWrap jsonWrapper){
        Plant_Utility.responseWrapper Authorization_resultList = new plant_AuthorizeController().generateAccessToken(jsonWrapper);
        return Authorization_resultList;
    }
    
    // @ Generate or Refresh Authentication Token for an Account Id
    public static Plant_Utility.responseWrapper changePassword_SC(plant_AuthorizeController.changePassword_wrap jsonWrapper){
        Plant_Utility.responseWrapper changePassword_Result = new plant_AuthorizeController().changePassword(jsonWrapper);
        return changePassword_Result;
    }

    // @ Temporary Expire the Authorization token
    public static Plant_Utility.responseWrapper expireAuthorizationToken_SC(plant_AuthorizeController.ExpireToken_wrap jsonWrapper){
        Plant_Utility.responseWrapper expireToken_Result = new plant_AuthorizeController().expireAuthorizationToken(jsonWrapper);
        return expireToken_Result;
    }

    // @ Generate Temporary Password
    public static Plant_Utility.responseWrapper forgotPasswordRequest_SC(String emailId){
        Plant_Utility.responseWrapper Authorization_resultList = new plant_AuthorizeController().forgotPasswordRequest(emailId);
        return Authorization_resultList;
    }
}