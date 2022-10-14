public class GARP_MS_Membership {
	
    // GetMembershipRegistrationInfo
        
    public class getMembershipRegistrationInfo {
        public List<GARP_Common.productInfo> Products;
        public GARP_Common.screenInfo ScreenInfo;
    }
    
    // SetMembershipOrder
    
    public class setMembershipOrderInfo {
        public setMembershipOrderCustomerInfo CustomerInfo;
        public setMembershipOrderPaymentInfo PaymentInfo;
        public List<GARP_Common.productInfo> ProductsSelected;
        public setMembershipOrderOptions Options;
        public GARP_Common.captchaInfo captchaInfo;
    }
    
    public class setMembershipOrderCustomerInfo {
        public String FirstName;
        public String LastName;
        public String Email;
        public String LeadId;
        public String Phone;
    }
    
    public class setMembershipOrderPaymentInfo {
        public String CardNumber;
        public String CardName;
        public String CCV;
        public Integer ExpireMonth;
        public Integer ExpireYear;
        public String BillingCompany;
        public String BillingStreet1;
        public String BillingStreet2;
        public String BillingCountry;
        public String BillingCity;
        public String BillingState;
        public String BillingPostalCode;
        public String BillingPhone;
        public String ExistingOrderId;
    }
    
    public class setMembershipOrderOptions {
		public Boolean AutoRenew;
    }
    
    public class setMembershipOrderReturnInfo {
        public String Status;
        public String Message;
        public String ContactId;
        public String OrderId;
    }
    
    // Methods
    @RemoteAction
    public static getMembershipRegistrationInfo GetMembershipRegistrationInfo() {
        return GARP_BC_Membership.GetMembershipRegistrationInfo();
    }
    
    @RemoteAction
    public static GARP_Common.verifyExistingCustomerInfo VerifyExistingMembershipCustomer(String email, String firstName, String lastName, String cta) {
        return GARP_Common.VerifyExistingCustomer(email, firstName, lastName, 'membership-individual', cta);
    }
    
    public GARP_MS_Membership(sfdcAppRemoter ctrl){}
}