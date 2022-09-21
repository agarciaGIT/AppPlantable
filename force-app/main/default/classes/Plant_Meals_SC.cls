/*
*   @Desciption     :   Plantable Meals Service class, handle calles form API and LWC controllwr
*   @Create date    :   07-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   Plant_Meals_SC_Test
*/

public class Plant_Meals_SC {
    
    // @ default constructor
    public Plant_Meals_SC() {

    }

    // @ Get meal list
    public static Plant_Utility.responseWrapper getMealList(){
        Plant_Utility.responseWrapper response = new Plant_Meals_BC().getAllActiveMeals();
        return response;
    }

    // @ Get Ingredient details
    public static Plant_Utility.responseWrapper getIngredientDetails(String param_MealId){
        Plant_Utility.responseWrapper ingredResponse = new Plant_Meals_BC().getIngredientDetail(param_MealId);
        return ingredResponse;
    } 

    // @ Update Meal selection
    public static Plant_Utility.responseWrapper setMealSelection(Plant_Meals_BC.MealSelectionReq_Wrapper jsonWrapper){
        Plant_Utility.responseWrapper mealSResponse = new Plant_Meals_BC().updateMealSelection(jsonWrapper);
        return mealSResponse;
    } 

    // @ Get chef Meals
    public static Plant_Utility.responseWrapper getChefMenu_SC(){
        Plant_Utility.responseWrapper response = new Plant_Meals_BC().getChefMenu();
        return response;
    }
}