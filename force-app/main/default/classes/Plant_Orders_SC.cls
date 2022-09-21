/*
*   @Desciption     :   Plantable Order Service class, handle calls from API and LWC controller
*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_Orders_SC {
    // Constructor **
    public Plant_Orders_SC() {

    }

    // @ Desc:  pre-process Order
    public static Plant_Utility.responseWrapper setPreProcessOrders( Plant_Orders_BC.opReqWrapper reqWrap){
        Plant_Utility.responseWrapper prePprocessOrder_Result = new Plant_Orders_BC().preProcessOrder(reqWrap);
        // return JSON.serialize(processOrder);
        return prePprocessOrder_Result;
    }

     // @ Desc:  process Order
     public static Plant_Utility.responseWrapper processOrders( Plant_Orders_BC.processOdr_Wrapper reqWrap){
        Plant_Utility.responseWrapper processOrderRes = new Plant_Orders_BC().processOrder(reqWrap);
        return processOrderRes;
    }

     // @ Desc:  process Transaction
     // call: AuthorizeOrder_ClickJSON (authorize chargent order and create transaction)
     public static Plant_Utility.responseWrapper authorizePayment( Plant_Orders_BC.TransactionReqWrap processOrderTransactionReqWrap){
        //Plant_Utility.responseWrapper processPayment_Res= new Plant_Orders_BC().authorizeCard_EnqueueRequest(processOrderTransactionReqWrap);
        Plant_Utility.responseWrapper processPayment_Res= new Plant_Orders_BC().authorizeChargent_Method2(processOrderTransactionReqWrap);
        return processPayment_Res;
    }

     // @ Desc:  process Payment
     // call: ChargeAuthorizedTransaction_ClickJSON (process tansaction)
     public static Plant_Utility.responseWrapper processPayment( Plant_Orders_BC.processPayment_Wrap processPayment_ReqWrap){
        //Plant_Utility.responseWrapper processPayment_Res= new Plant_Orders_BC().processCard_EnqueueRequest(processPayment_ReqWrap);
        Plant_Utility.responseWrapper processPayment_Res= new Plant_Orders_BC().authorizeChargent_Method3(processPayment_ReqWrap);
        return processPayment_Res;
    }

    // @ Desc:  get Payment Method details
    public static Plant_Utility.responseWrapper getPaymentDetail( String cartId){
        Plant_Utility.responseWrapper paymentMtd_Res= new Plant_Orders_BC().getPaymentDetails(cartId);
        return paymentMtd_Res;
    }
    
    // @ Desc:  set Payment Method details on cart
    public static Plant_Utility.responseWrapper setPaymentDetail( Plant_Orders_BC.paymtUpdateWrap payment_Wrap){
        Plant_Utility.responseWrapper paymentMtd_Res= new Plant_Orders_BC().setPaymentDetails(payment_Wrap);
        return paymentMtd_Res;
    }
    // @ Desc:  get Meal details of an order
    public static Plant_Utility.responseWrapper getOrder_MealDetail( Plant_Orders_BC.wrapOrder_MealReq payment_Wrap){
        Plant_Utility.responseWrapper OrderMealMtd_Res= new Plant_Orders_BC().getOrder_MealDetails(payment_Wrap);
        return OrderMealMtd_Res;
    }
    
    // @ Desc:  update meals from Customer order(24 hr from create)
    public static Plant_Utility.responseWrapper updateOrder_MealsList( Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper payment_Wrap){
        Plant_Utility.responseWrapper OrderMealMtd_Res= new Plant_Orders_BC().updateOrder_Meals(payment_Wrap);
        return OrderMealMtd_Res;
    }

     // @ Desc:  Cancel Order of Customer (24 hr from create)
    public static Plant_Utility.responseWrapper cancelOrder_method_SC( Plant_Orders_BC.wrapOrder_MealReq order_Wrap){
        Plant_Utility.responseWrapper OrderCancel_Res= new Plant_Orders_BC().cancelOrder_method(order_Wrap);
        return OrderCancel_Res;
    }

// @ Desc:  get Card Authentication Result 
    public static Plant_Utility.responseWrapper getCardAuthenticationResult_SC( Plant_Orders_BC.getCardStatus order_Wrap){
        Plant_Utility.responseWrapper cardResult_Res= new Plant_Orders_BC().getCardAuthenticationResult(order_Wrap);
        return cardResult_Res;
    }

// @ Desc:  to change the Delivery date of a particular order
    public static Plant_Utility.responseWrapper changeOrderDeliveryDate_SC(Plant_Orders_BC.OrderDeliveryDate_Wrap order_Wrap){
        Plant_Utility.responseWrapper deliveryDate_Res= new Plant_Orders_BC().changeOrderDeliveryDate(order_Wrap);
        return deliveryDate_Res;
    }

     //@ Method to get details about orders created by Customer
    // @ Desc:  No. of orders and status
    public static Plant_Utility.responseWrapper getOrder_SC(String authenticationToken){
        Plant_Utility.responseWrapper orders_Result = new Plant_Orders_BC().getOrders(authenticationToken);
        return orders_Result;
    }

      
    //@ Method to get details about orders created by Customer
    // @ Desc: Get details about an order using order number
    public static Plant_Utility.responseWrapper getOrderDetail_SC(String authenticationToken, String OrderNo){
        Plant_Utility.responseWrapper orderDetails_Result = new Plant_Orders_BC().getOrderDetails(authenticationToken, OrderNo);
        return orderDetails_Result;
    }
    
   
    //@ Method to update Shipping Address 
    // @ Desc: to update Shipping Address of an order using order number and Access Token
    public static Plant_Utility.responseWrapper customerShippingAddress_SC( Plant_Orders_BC.manageShipAddress reqWrap){
        Plant_Utility.responseWrapper AddressDetails_Result = new Plant_Orders_BC().update_CustomerOdr_ShipAddress(reqWrap);
        return AddressDetails_Result;
    }
    
}