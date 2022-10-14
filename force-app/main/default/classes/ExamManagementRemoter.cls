public class ExamManagementRemoter {
    
    @RemoteAction
    static public ExamManagementController.programInfo getProgramInfo(String programType) {
        ExamManagementController.programInfo pri = new ExamManagementController.programInfo();
        
        return ExamManagementController.getProgramData(programType);
    }

    
    @RemoteAction
    static public ExamManagementController.allProgramData getAllProgramInfo() {
        ExamManagementController.allProgramData apd = new ExamManagementController.allProgramData();
        apd.frm = ExamManagementController.getProgramData('frm');
        apd.erp = ExamManagementController.getProgramData('erp');
        apd.scr = ExamManagementController.getProgramData('scr');
        
        return apd;
    }
    
    @RemoteAction
    static public void updateOSTAIDInfo(Id contactId, String idType, String idNumber, Date expDate) {
        ExamManagementController.updateOSTAIDInfo(contactId, idType, idNumber, expDate);
    }
    
    @RemoteAction
    static public void logFailedAuthorization(String examRegId) {
        AppError__c ae = new AppError__c(Name='CBT Auth Failed',Message__c=examRegId);
        insert ae;
    }
    
    @RemoteAction
    static public void createCBTIntegrationAuthorization(String examRegId) {
        ExamManagementController.createCBTIntegrationAuthorization(examRegId);
    }
    
    @RemoteAction
    static public void processExamRegModsFromClient(Id examRegModId) {
        Set<Id> setExamRegMods = new Set<Id>();
        setExamRegMods.add(examRegModId);
        ExamManagementController.processExamRegMods(setExamRegMods,false,false);
    }
    
    @RemoteAction 
    static public ExamManagementController.examRescheduleData createExamRescheduleFeesOrder(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return ExamManagementController.createExamRescheduleFeesOrderInternal(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false,'Deferral Standard');
    }
    
    @RemoteAction 
    static public ExamManagementController.examRescheduleData getExamRescheduleFees(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return ExamManagementController.getExamRescheduleFeesInternal(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false);
    }
    
    @RemoteAction 
    static public ExamManagementController.examRescheduleData getExamRescheduleInformation(Id examGroupId, String program) {
        String userId = UserInfo.getUserId();
        return ExamManagementController.getExamRescheduleData(examGroupId, program, NULL, NULL, NULL, NULL,userId);
    }
        
    public ExamManagementRemoter(sfdcAppRemoter ctrl){}
}