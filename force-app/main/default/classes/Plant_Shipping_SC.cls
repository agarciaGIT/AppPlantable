/*
*   @Desciption     :   Plantable Shipping Service class, handle calles form API and LWC controllwr
*   @Create date    :   07-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   Plant_Shipping_SC_Test
*/
public class Plant_Shipping_SC {

    // Default constructor
    public Plant_Shipping_SC() {

    }

    // Get Next 10 Delivery Dates
    public static Plant_Utility.responseWrapper getAvailableShippingStates(){
        Plant_Utility.responseWrapper dd_resultList = new Plant_Shipping_BC().getAvailableShippingStates();
        return dd_resultList;
    }
    
    // Get Next 10 Delivery Dates
    public static Plant_Utility.responseWrapper getDeliveryDate(Plant_Shipping_BC.deliveryDateWrapper jsonWrapper){
        // Plant_Shipping_BC.deliveryDateWrapper jsonWrapper = new Plant_Shipping_BC.deliveryDateWrapper().parse(jsonReq);
        Plant_Utility.responseWrapper dd_resultList = new Plant_Shipping_BC().getAvailableDeliveryDates(jsonWrapper);
        // return JSON.serialize(dd_resultList);
        return dd_resultList;
    }
    
    // @ get shipping address for Cart
    public static Plant_Utility.responseWrapper getShippingAddress(String orderPropId){
        Plant_Utility.responseWrapper ShippingAddress = new Plant_Shipping_BC().getShippingAddress(orderPropId);
        return ShippingAddress;
    }
}