({
	prepMealData : function(obj) {
        for(var i=0; i<obj.lstMealsData.length; i++) {
            var cps = obj.lstMealsData[i].Calories_Per_Serving__c;
            if(cps !== 'undefined' && cps !== null) {
                cps = Math.round(cps);
            }
            obj.lstMealsData[i].Calories_Per_Serving__c = cps;
        }
        return obj;
	}
})