public class ExamManagementRemoter {
    
    @RemoteAction
    static public ExamManagementController.programInfo getProgramInfo(String programType) {
    	return ExamManagementController.getProgramData(programType);
    }

    
    @RemoteAction
    static public ExamManagementController.allProgramData getAllProgramInfo() {
        return ExamManagementController.getAllProgramInfo();
    }
    
    @RemoteAction
    static public void updateOSTAIDInfo(Id contactId, String idType, String idNumber, String idLocation, Date expDate) {
        ExamManagementController.updateOSTAIDInfo(contactId, idType, idNumber, idLocation, expDate);
    }
    
    @RemoteAction
    static public void logFailedAuthorization(String examRegId) {
        ExamManagementController.logFailedAuthorization(examRegId);
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
    static public ExamManagementController.examRescheduleData createExamRescheduleFeesOrder(String examRegId, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return ExamManagementController.createExamRescheduleFeesOrderInternal(examRegId, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false,false,'Deferral Standard');
    }
    
    @RemoteAction 
    static public ExamManagementController.examRescheduleData getExamRescheduleFees(String examRegId, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII) {
        string userId = userinfo.getUserId();
        return ExamManagementController.getExamRescheduleFeesInternal(examRegId, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,false);
    }
    
    @RemoteAction 
    static public ExamManagementController.examRescheduleData getExamRescheduleInformation(Id examRegId) {
        String userId = UserInfo.getUserId();
        return ExamManagementController.getExamRescheduleData(examRegId, NULL, NULL, NULL, NULL,userId);
    }
    
    @RemoteAction 
    public static Response.Envelope changeExamSiteOnExamRegistrations(Id examRegistrationId, Id targetExamSiteId){
        return ExamManagementController.changeExamSiteOnExamRegistrations(examRegistrationId, targetExamSiteId);
    }
    
    public ExamManagementRemoter(sfdcAppRemoter ctrl){}
}