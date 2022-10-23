public class GBI_Common {

    public static Set<String> getPickListValues(String strObjectName, String strPicklistField) {

        Set<String> retValues = new Set<String>();
            
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            retValues.add(objPickList.getLabel());
        }
        
        return retValues;
    }
    
}