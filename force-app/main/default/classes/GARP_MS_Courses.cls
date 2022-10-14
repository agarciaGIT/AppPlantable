public class GARP_MS_Courses {

    // GetFRRRegistrationInfo
     
    public class getFRRRegistrationInfo {
        public List<GARP_Common.productInfo> Products;
        public GARP_Common.screenInfo ScreenInfo;
        public GARP_Common.existingContactInfo ExistingContactInfo;
    }
    
    
    public class getFFRRegistrationInfo {
        public List<GARP_Common.productInfo> Products;
        public GARP_Common.screenInfo ScreenInfo;
        public GARP_Common.existingContactInfo ExistingContactInfo;
    }
    
    // Methods
    
    @RemoteAction
    public static getFRRRegistrationInfo GetFRRRegistrationInfo() {
        return GARP_BC_Courses.GetFRRRegistrationInfo();
    }
    
    @RemoteAction
    public static getFFRRegistrationInfo GetFFRRegistrationInfo() {
        return GARP_BC_Courses.GetFFRRegistrationInfo();
    }
    
    @RemoteAction
    public static GARP_Common.verifyExistingCustomerInfo VerifyExistingFRRCustomer(String email, String firstName, String lastName, String cta) {
        return GARP_Common.VerifyExistingCustomer(email, firstName, lastName, 'course-icbrr', cta);
    }
    
    @RemoteAction
    public static GARP_Common.verifyExistingCustomerInfo VerifyExistingFFRCustomer(String email, String firstName, String lastName, String cta) {
        return GARP_Common.VerifyExistingCustomer(email, firstName, lastName, 'course-fbr', cta);
    }
    
    public GARP_MS_Courses(sfdcAppRemoter ctrl){}
}