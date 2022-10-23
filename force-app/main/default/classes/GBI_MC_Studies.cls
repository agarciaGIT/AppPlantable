public class GBI_MC_Studies {

    @AuraEnabled(cacheable = false)
    public static GBI_MS_Studies.retStudiesInfo getListStudies(GBI_MS_Studies.reqStudiesList reqWrapper){
        return  GBI_MS_Studies.getListStudies(reqWrapper);
    }

    @AuraEnabled(cacheable = false)
    public static GBI_MS_Studies.getSudiesReturnData getStudies(){
        return GBI_MS_Studies.getStudies();
    }
    
    @AuraEnabled(cacheable = false)
    public static GBI_MS_Studies.faqReturnData getFAQInformation(){
        return GBI_MS_Studies.getFAQInformation();
    }
    
    @AuraEnabled(cacheable = false)
    public static Boolean sendSupportEmail(String subject, String description, Boolean isPillar3){
        return GBI_MS_Studies.sendSupportEmail(subject, description, isPillar3);
    }
    
    @AuraEnabled(cacheable = false)
    public static List<Study_Account__c> getParticipantInformation(){
        return GBI_MS_Studies.getParticipantInformation();
    }
    
    @AuraEnabled(cacheable = false)
    public static Contact getUserContactData(){
        return GBI_MS_Studies.getUserContactData();
    }
    
    @AuraEnabled(cacheable = false)
    public static String updateContactInfo(String firstName, String lastName, String title, String phone, String altphone, String email) {
        return GBI_MS_Studies.updateContactInfo(firstName, lastName, title, phone, altphone, email);
    }
    
    @AuraEnabled(cacheable = false)
    public static Boolean removeUserPhoto(){
        return GBI_MS_Studies.removeUserPhoto();
    }
    
    @AuraEnabled(cacheable = false)
    public static String setUserPhoto(Id attachmentId, String fileText, String fileName){
        return GBI_MS_Studies.setUserPhoto(attachmentId, fileText, fileName);
    }
}