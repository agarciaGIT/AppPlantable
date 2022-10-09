public class cloneExamAdminPageContrlr {
    public cloneExamAdminPageContrlr(ApexPages.StandardController controller){
        
    }
    public PageReference redirectToExamAdmin(){
        String newRecordId = ApexPages.currentPage().getParameters().get('newRecordId');
        system.debug('Check this record Id '+ newRecordId);
        PageReference p =  new PageReference('/'+newRecordId+'/e');
        p.getParameters().put('retURL','/'+newRecordId);
        p.setRedirect(true);
        return p;
    }
}