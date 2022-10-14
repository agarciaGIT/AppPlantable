public with sharing class lwcVFDemoController {
    @AuraEnabled(cacheable = true)
    public static List<SObject> fetchsObjectData(String obName){
        System.debug('Hello');
        return database.query('SELECT ID, Name FROM '+obName+' LIMIT 5');
    }
}