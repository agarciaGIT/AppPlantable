/*
*   @Desciption     :   Plantable Shipping Service class, handle calles form API and LWC controllwr
*   @Create date    :   07-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   Plant_Shipping_SC_Test
*/
public class Plant_AppAnalytics_SC {

    // Default constructor
    public Plant_AppAnalytics_SC() {

    }

    // Set Last Login Date Time
    public static Plant_Utility.responseWrapper setLastLogin(Plant_AppAnalytics_BC.autorize_AccountReq jsonWrapper){
        Plant_Utility.responseWrapper resp = new Plant_AppAnalytics_BC().setLastLogin(jsonWrapper);
        return resp;
    }
}