public class Plant_GetPickListValue {

    public static List<picklistWrapper>  getPicklistValues(String ObjectApi_name,String Field_name){ 
        List<picklistWrapper> pickListValueeList =  new List<picklistWrapper>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
          for (Schema.PicklistEntry a : pick_list_values) { 
            if(a.isActive()){
              pickListValueeList.add(new picklistWrapper(a.getLabel(),a.getValue()));
            }
         }
        return pickListValueeList;
    }

    public class picklistWrapper{
        string label{get;set;}
        string value{get;set;}

        public picklistWrapper(string label , string value){
            this.label = label;
            this.value = value;
        }
    }
}