public class studyMealsByOrderDownload {
    
    public List<Meal_Line_Item__c> lstMeals{get;set;}
    public String csvString {get;set;}
    
    
    public studyMealsByOrderDownload () {
        string sdate = ApexPages.currentPage().getParameters().get('dt');
        if(Test.isRunningTest()){
            sdate = '2020-03-02';      
        }
        Date dt = date.valueOf(sdate);
        String userID = UserInfo.getUserId();
        csvString='';
        
        lstMeals = [select Id, Name, Meal_Name__c, Quantity__c, Opp_Name__c, Opp_External_Order_Number__c, Opp_Ship_Date__c from Meal_Line_Item__c WHERE EOrder__r.Account.Study_Account_Owner_ID__c = :userID AND Opp_Is_Study_Order__c = True AND Opp_Ship_Date__c = :dt order by Opp_Ship_Date__c, Opp_Name__c];
        
        for(Meal_Line_Item__c mi :lstMeals) {
            csvString+= mi.Opp_Name__c + ',MSK' + mi.Opp_External_Order_Number__c + ',' + mi.Opp_Ship_Date__c + ',\"' + mi.Meal_Name__c  + '\",' + mi.Quantity__c+ '\n';
        }
        
    }

}