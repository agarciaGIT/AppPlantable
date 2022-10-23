public class GARP_ExamManagementRemoter {
    
    /*
    
    @RemoteAction
    static public GARP_ExamManagement.programInfo getProgramInfo(String programType) {
        GARP_ExamManagement.programInfo pri = new GARP_ExamManagement.programInfo();
        
        return GARP_ExamManagement.getProgramData(programType);
    }

    
    @RemoteAction
    static public GARP_ExamManagement.allProgramData getAllProgramInfo() {
        GARP_ExamManagement.allProgramData apd = new GARP_ExamManagement.allProgramData();
        apd.frm = GARP_ExamManagement.getProgramData('frm');
        apd.erp = GARP_ExamManagement.getProgramData('erp');
        apd.scr = GARP_ExamManagement.getProgramData('scr');
        
        return apd;
    }
    
    @RemoteAction
    static public void updateOSTAIDInfo(Id contactId, String idType, String idNumber, Date expDate) {
        GARP_ExamManagement.updateOSTAIDInfo(contactId, idType, idNumber, expDate);
    }
    
    @RemoteAction
    static public void logFailedAuthorization(String examRegId) {
        AppError__c ae = new AppError__c(Name='CBT Auth Failed',Message__c=examRegId);
        insert ae;
    }
    
    @RemoteAction
    static public void createCBTIntegrationAuthorization(String examRegId) {
        GARP_ExamManagement.createCBTIntegrationAuthorization(examRegId);
    }
    
    @RemoteAction
    static public void processExamRegModsFromClient(Id examRegModId) {
        Set<Id> setExamRegMods = new Set<Id>();
        setExamRegMods.add(examRegModId);
        GARP_ExamManagement.processExamRegMods(setExamRegMods,false,false);
    }
    
    @RemoteAction 
    static public GARP_ExamManagement.examRescheduleData createExamRescheduleFeesOrder(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return GARP_ExamManagement.createExamRescheduleFeesOrderInternal(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false,'Deferral Standard');
    }
    
    @RemoteAction 
    static public GARP_ExamManagement.examRescheduleData getExamRescheduleFees(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return GARP_ExamManagement.getExamRescheduleFeesInternal(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false);
    }
    
    @RemoteAction 
    static public GARP_ExamManagement.examRescheduleData getExamRescheduleInformation(Id examGroupId, String program) {
        String userId = UserInfo.getUserId();
        return GARP_ExamManagement.getExamRescheduleData(examGroupId, program, NULL, NULL, NULL, NULL,userId);
    }
 */       
    public GARP_ExamManagementRemoter(sfdcAppRemoter ctrl){}
}