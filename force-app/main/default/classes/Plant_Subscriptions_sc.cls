/*
*   @Desciption     :   Plantable (Subscription Service class)
*                       

*   @Create date    :   12-09-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

public class Plant_Subscriptions_sc{
    
    //Default constructor
    public Plant_Subscriptions_sc() {

    }

    //@ Method to update Customer Delivery Date
    public static Plant_Utility.responseWrapper customerDeliveryDate_SC(Plant_Subscriptions_BC.Ddate_UpdateWrap reqWrap){
        Plant_Utility.responseWrapper dDetails_Result = new Plant_Subscriptions_BC().update_CustmrSubs_DeliveryDate(reqWrap);
        return dDetails_Result;
    }
    
    //@ Method to update Customer Delivery Date
    public static Plant_Utility.responseWrapper getSubscriptionInfo_SC(String authenticationToken){
        Plant_Utility.responseWrapper SubscriptionInfo_Result = new Plant_Subscriptions_BC().getSubscriptionInformation(authenticationToken);
        return SubscriptionInfo_Result;
    }

    public static Plant_Utility.responseWrapper setSubscription_PaymentDetails_SC(Plant_Subscriptions_BC.subsption_PaymentUpdate_Wrap reqWrap){
        Plant_Utility.responseWrapper subscriptionPayment_Result = new Plant_Subscriptions_BC().setSubscription_PaymentDetails(reqWrap);
        return subscriptionPayment_Result;
    }
     //@ update Subscription Meals record for Account Id
    public static Plant_Utility.responseWrapper setSubscription_Meals_SC(Plant_Subscriptions_BC.subsption_MealUpdate_Wrap reqWrap){
        Plant_Utility.responseWrapper subscriptionMeals_Result = new Plant_Subscriptions_BC().setSubscription_Meals(reqWrap);
        return subscriptionMeals_Result;
    }
    //@ update Subscription Address record for Account Id
    public static Plant_Utility.responseWrapper setSubscription_Address_SC(Plant_Subscriptions_BC.subsption_AddressUpdate_Wrap reqWrap){
        Plant_Utility.responseWrapper subscriptionAddress_Result = new Plant_Subscriptions_BC().setSubscription_Address(reqWrap);
        return subscriptionAddress_Result;
    }

    //@ To Void The Existing Transaction
    public static Plant_Utility.responseWrapper voidTransaction_SC(Plant_Subscriptions_BC.voidTransaction_Wrap reqWrap){
        Plant_Utility.responseWrapper voidTransaction_Result = new Plant_Subscriptions_BC().voidTransaction(reqWrap);
        return voidTransaction_Result;
    }
    
    //@ To get Details Of a Subscription of an Account
    public static Plant_Utility.responseWrapper getSubscriptionDetails_SC(String authenticationToken, String subscriptionId){
        Plant_Utility.responseWrapper subscriptionDetails_Result = new Plant_Subscriptions_BC().getSubscriptionDetails(authenticationToken, subscriptionId);
        return subscriptionDetails_Result;
    }

    //@ To get Details Of a Subscription of an Account
    public static Plant_Utility.responseWrapper setSubscription_PaymentDetailsSetp2_SC(Plant_Subscriptions_BC.CardAuthorize_ReqWrap reqWrap){
        Plant_Utility.responseWrapper subscriptionDetails_Result = new Plant_Subscriptions_BC().setSubscription_PaymentDetailsSetp2(reqWrap);
        return subscriptionDetails_Result;
    }

     // @ Desc:  Update Subscription status
     public static Plant_Utility.responseWrapper updateSubscription( Plant_Subscriptions_BC.SubscrptionWrap subscDetails){
        Plant_Utility.responseWrapper subsModification_Res= new Plant_Subscriptions_BC().updateSubscruptionStatus(subscDetails);
        return subsModification_Res;
    }

}