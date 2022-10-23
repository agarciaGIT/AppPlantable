public class GBI_MS_Studies {
    
    public class faqReturnData {        
        @AuraEnabled public List<FAQ_Category__c> faqCategories { get; set; }
        @AuraEnabled public List<FAQ_Section__c> listFAQSections { get; set; }
        @AuraEnabled public List<FAQ_Subsection__c> listFAQSubSections { get; set; }
        @AuraEnabled public List<Frequently_Asked_Questions__c> FAQs { get; set; }  
    }

    public class getSudiesReturnData {
        @AuraEnabled public User userData { get; set; }
        @AuraEnabled public Contact contactData { get; set; }
        @AuraEnabled public Account accountData { get; set; }        
        @AuraEnabled public Id indvAccountRecordTypeId { get; set; }        
        @AuraEnabled public List<Study__c> studies { get; set; }   
        @AuraEnabled public Boolean isGARPEmployee { get; set; }
        @AuraEnabled public List<Study_NDA__c> studyNDAs { get; set; } 
        @AuraEnabled public List<Disclosure_Protocol__c> disclosureProtocols { get; set; }
    }
    
    public class reqStudiesList {
        @AuraEnabled public String status;
        @AuraEnabled public String riskBucket;
        @AuraEnabled public String riskType;
        @AuraEnabled public Boolean participtation;
        @AuraEnabled public Integer year;
    }
    
    public class retStudiesInfo {
        @AuraEnabled public Integer statusCode;
        @AuraEnabled public String statusMsg;
        @AuraEnabled public Boolean isGARPEmployee;
        @AuraEnabled public List<Study__c> myStudies;
        @AuraEnabled public List<Study__c> myOrgStudies;
        @AuraEnabled public List<Study__c> otherStudies;
        @AuraEnabled public List<Study_Disclose_Protocol_Submission__c> discloseProtocolSubmissions;
        @AuraEnabled public List<Study_NDA__c> studyNDAs;
    }
    
    public static retStudiesInfo getListStudies(reqStudiesList reqWrapper) {
        return GBI_BC_Studies.getListStudies(reqWrapper);
    }
    
    public static getSudiesReturnData getStudies(){
        return GBI_BC_Studies.getStudies();
    }
    
    public static Boolean sendSupportEmail(String subject, String description, Boolean isPillar3){
        return GBI_BC_Studies.sendSupportEmail(subject, description, isPillar3);
    }

    public static faqReturnData getFAQInformation(){
        return GBI_BC_Studies.getFAQInformation();
    }
    
    public static List<Study_Account__c> getParticipantInformation(){
        return GBI_BC_Studies.getParticipantInformation();
    }
    
    public static Contact getUserContactData(){
        return GBI_BC_Studies.getUserContactData();
    }

    public static String updateContactInfo(String firstName, String lastName, String title, String phone, String altphone, String email) {
        return GBI_BC_Studies.updateContactInfo(firstName, lastName, title, phone, altphone, email);
    }
    
    public static Boolean removeUserPhoto(){
        return GBI_BC_Studies.removeUserPhoto();
    }
    
    public static String setUserPhoto(Id attachmentId, String fileText, String fileName){
        String attchId = GBI_BC_Studies.uploadAttachment(attachmentId, fileText, fileName);
        return GBI_BC_Studies.setUserPhoto(attchId);
    }
}