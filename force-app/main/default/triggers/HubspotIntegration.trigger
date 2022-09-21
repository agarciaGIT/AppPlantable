trigger HubspotIntegration on Meal__c (before update) {
for(Meal__c m:Trigger.new){
    if(Trigger.isUpdate) {
        if(Trigger.oldMap.get(m.ID).Name!= m.Name||Trigger.oldMap.get(m.ID).Meal_Description__c!= m.Meal_Description__c||
                             Trigger.oldMap.get(m.ID).Type__c != m.Type__c|| Trigger.oldMap.get(m.ID).Menu_Name__c != m.Menu_Name__c||
                             Trigger.oldMap.get(m.ID).Allergens__c != m.Allergens__c||Trigger.oldMap.get(m.ID).Last_ingredients_update__c!= m.Last_ingredients_update__c||
                             Trigger.oldMap.get(m.ID).Number_of_Servings__c!= m.Number_of_Servings__c||
                             Trigger.oldMap.get(m.ID).Image_URL__c!= m.Image_URL__c||Trigger.oldMap.get(m.ID).Nutritional_Label_Image_URL__c != m.Nutritional_Label_Image_URL__c||
                             Trigger.oldMap.get(m.ID).Status__c!= m.Status__c){
                                 m.Hubspot_Integration_Status__c =2;
                             }
      }
}
}