/*
*   @Desciption     :   Plantable Customer Service class, handle calls from API and LWC controller
*   @Create date    :   29-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/
public class Plant_Customer_SC {
    
    //Default Contrustor
    public Plant_Customer_SC(){
    }

    //@ Method to get Account Information
    // @ Desc:  get Customer Information
    public static Plant_Utility.responseWrapper getCustomerInfo_SC(String authenticationToken){
        Plant_Utility.responseWrapper accountInfo_Result = new Plant_Customer_BC().getCustomerInfo(authenticationToken);
        return accountInfo_Result;
    }
    
    //@ Method to update Account Information
    // @ Desc:  updating Account Info 
    public static Plant_Utility.responseWrapper updateAccount( Plant_Customer_BC.AccountInfo_Wrap reqWrap){
        Plant_Utility.responseWrapper updateAccount_Result = new Plant_Customer_BC().updateAccountInfo(reqWrap);
        return updateAccount_Result;
    }
   //@ Method to create new Account
    public static Plant_Utility.responseWrapper createAccount_SC(Plant_Customer_BC.createAccount_Wrap reqWrap){
        Plant_Utility.responseWrapper createAccount_Result = new Plant_Customer_BC().createAccount(reqWrap);
        return createAccount_Result;
    }

    // @ Desc:  get Payment Method details about an Account
    public static Plant_Utility.responseWrapper getAccountPaymentDetail_SC(String authenticationToken){
        Plant_Utility.responseWrapper paymentMtd_Res= new Plant_Customer_BC().getAccountPaymentDetails(authenticationToken);
        return paymentMtd_Res;
    }

      // @ Get all Shipping Address for an Account Id
    public static Plant_Utility.responseWrapper getShippingAddresstDetail_SC(String authenticationToken){
        Plant_Utility.responseWrapper getShippingAddress = new Plant_Customer_BC().getShippingAddresstDetailList(authenticationToken);
        return getShippingAddress;
    } 
     // @ set: Update shipping address
    public static Plant_Utility.responseWrapper updateShippingAddress_SC(Plant_Customer_BC.manageShipAddress_wrap shipAdd_wrap){
        Plant_Utility.responseWrapper ShippingAddress_updateResp = new Plant_Customer_BC().updateShippingAddress(shipAdd_wrap);
        return ShippingAddress_updateResp;
    }
      
    // @ delete shipping address
    public static Plant_Utility.responseWrapper deleteShippingAddress_SC(Plant_Customer_BC.wrapReq_class jsonWrapper){
        Plant_Utility.responseWrapper DeleteAddress = new Plant_Customer_BC().deleteShippingAddress(jsonWrapper);
        return DeleteAddress;
    } 

    // @ add customer shipping address
    public static Plant_Utility.responseWrapper addCustomerAddress_SC(Plant_Customer_BC.addCustomerAddreeeWrap jsonWrapper){
        Plant_Utility.responseWrapper addAddress = new Plant_Customer_BC().addCustomerAddress(jsonWrapper);
        return addAddress;
    } 
    
    // @ update customer shipping address
    public static Plant_Utility.responseWrapper updateCustomerAddress_SC(Plant_Customer_BC.updateCustomerAddressWrap jsonWrapper){
        Plant_Utility.responseWrapper addAddress = new Plant_Customer_BC().updateCustomerAddress(jsonWrapper);
        return addAddress;
    } 
    
    // @ add Payment Method
    public static Plant_Utility.responseWrapper addCustomerPaymentMethod_SC(Plant_Customer_BC.addCustomerPaymentWrap jsonWrapper){
        Plant_Utility.responseWrapper addPayment = new Plant_Customer_BC().addCustomerPaymentMethod(jsonWrapper);
        return addPayment;
    } 

    // @ update Payment Method
    public static Plant_Utility.responseWrapper updateCustomerPaymentMethod_SC(Plant_Customer_BC.updateCustomerPaymentWrap jsonWrapper){
        Plant_Utility.responseWrapper addPayment = new Plant_Customer_BC().updatePaymentMethod(jsonWrapper);
        return addPayment;
    } 
        
    // @ delete Payment Method of Customer
    public static Plant_Utility.responseWrapper delCustomerPaymentMethod_SC(Plant_Customer_BC.delCustomerPaymentWrap jsonWrapper){
        Plant_Utility.responseWrapper delPayment = new Plant_Customer_BC().delCustomerPaymentMethod(jsonWrapper);
        return delPayment;
    } 
}