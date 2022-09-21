/*
*   @Desciption     :   Plantable Meals Service class, handle calles form API and LWC controllwr
*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_DiscountCodes_SC {

    // Constructor **
    public Plant_DiscountCodes_SC() {

    }

    // @ Update Meal Discount code
    public static Plant_Utility.responseWrapper setDiscountCode(Plant_DiscountCodes_BC.dcReqWrapper reqWrap){
        Plant_Utility.responseWrapper mealSResponse = new Plant_DiscountCodes_BC().updateDiscountCodeToOrder(reqWrap);
        return mealSResponse;
    }

    // @ Update Meal Discount code
    public static Plant_Utility.responseWrapper removeDiscountCode(Plant_DiscountCodes_BC.dcReqWrapper reqWrap){
        Plant_Utility.responseWrapper mealSResponse = new Plant_DiscountCodes_BC().removeDiscountCode(reqWrap);
        return mealSResponse;
    }

}