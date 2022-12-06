@isTest
public class GARP_MemberProfile_test {
    
    Static Account acct;
    Static Contact cont;
    Static Country_Code__c cc;
    Static Province__c pv;
    Static String RecordTypeId;
    Static Institution__c inst;
    
    static void testSetup() {
        acct = new Account(
            Name = 'TestAccount',
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Individual'),
            CurrencyIsoCode  = 'USD'
        );
        insert acct;
        
        cont = new Contact(AccountId = acct.id, FirstName='Cont', LastName='Last', Email='a@a.com',
                                   Corporate_Title__c='Entry Level',
                                   Job_Function__c='Consulting',
                                   How_Did_You_Hear_About_Us__c='advertisement',
                                   Area_of_Concentration__c='Education Services'
                                  );
        insert cont;
		
		cc = new Country_Code__c(
			Name='US',
			PK_Country__c='227',
			Country__c='United States',
			PhoneCode__c='1',
			Currency__c='USD',
			LetterCode__c='US',
			RegionID__c='5',
			ISOCode__c='USA'
		);
        insert cc;
		
		pv = new Province__c(
			Name='New York',
			Country_Code__c=cc.id,
			Code__c='NY'
		);
        insert pv;
        
        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Institution__c','Organization');
            
        Institution__c inst = new Institution__c (
            Institution_Name__c='Compy',
            RecordTypeId=RecordTypeId
        );
        insert inst;

    }
    
    public static testmethod void test1() {
        
        testSetup();
        Test.startTest();
        GARP_BC_MemberProfile.getCountries();
        GARP_BC_MemberProfile.getInstitutions();
        GARP_MS_MemberProfile.searchInstitutions('Com', 'Organization'); 
        GARP_BC_MemberProfile.getPickListValues('Contact','Area_of_Concentration__c');
        
        GARP_MC_PublicForms.searchInstitutions('Com', 'Organization'); 
            
        Test.stopTest();
        
    }
    
    public static testmethod void test2() {
        
        testSetup();
        Test.startTest();
    	
        GARP_MS_MemberProfile.memberProfileEdit mpe = GARP_MS_MemberProfile.getMemberProfileForEdit(cont.Id);
        GARP_MS_MemberProfile.memberProfileEdit mpe1 = GARP_MS_MemberProfile.getMemberProfileForEdit(null);
        
        GARP_MS_MemberProfile.memberProfileUpdate profileUpdate = new GARP_MS_MemberProfile.memberProfileUpdate();
        profileUpdate.profileParts = new GARP_MS_MemberProfile.profileParts();
        profileUpdate.ContactId = cont.Id;
        
        profileUpdate.profileParts.NameEmail = True;
        profileUpdate.FirstName = 'first';
        profileUpdate.LastName = 'last';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);


        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = True;
        profileUpdate.Mailing_Address_Company = 'Comp';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);

        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = False;
        profileUpdate.profileParts.PhoneNumbers = True;
        profileUpdate.HomePhone = '111111111';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);

        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = False;
        profileUpdate.profileParts.PhoneNumbers = False;
        profileUpdate.profileParts.EmploymentInformation = True;
        profileUpdate.Currently_Working_Status = 'Working';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);
        
        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = False;
        profileUpdate.profileParts.PhoneNumbers = False;
        profileUpdate.profileParts.EmploymentInformation = False;
        profileUpdate.profileParts.AcademicInformation = True;
        profileUpdate.School_Name = 'School';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);
        
        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = False;
        profileUpdate.profileParts.PhoneNumbers = False;
        profileUpdate.profileParts.EmploymentInformation = False;
        profileUpdate.profileParts.AcademicInformation = False;
        profileUpdate.profileParts.CompanyTitle = True;
        profileUpdate.Company = 'Comp';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);

        profileUpdate.profileParts.NameEmail = False;
        profileUpdate.profileParts.MailingAddress = False;
        profileUpdate.profileParts.PhoneNumbers = False;
        profileUpdate.profileParts.EmploymentInformation = False;
        profileUpdate.profileParts.AcademicInformation = False;
        profileUpdate.profileParts.CompanyTitle = False;
        profileUpdate.profileParts.Survey = True;
        profileUpdate.Company = 'Comp';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);

        profileUpdate.ContactId = null;
		profileUpdate.AccountId = acct.id;
		profileUpdate.profileParts.BillingAddress = True;
        profileUpdate.Billing_Address_Company = 'Comp';
        GARP_MS_MemberProfile.setMemberProfile(profileUpdate);
        
        Test.stopTest();
        
    }
    
	public static testmethod void test3() {
        
        testSetup();
        Test.startTest();
        
        GARP_MC_MemberProfile.getMemberProfileForEdit(cont.Id);
        
        GARP_MS_MemberProfile.memberProfileUpdate profileUpdate = new GARP_MS_MemberProfile.memberProfileUpdate();
        profileUpdate.profileParts = new GARP_MS_MemberProfile.profileParts();
        profileUpdate.ContactId = cont.Id;
        profileUpdate.AccountId = acct.id;
        
        profileUpdate.profileParts.NameEmail = True;
        profileUpdate.FirstName = 'first';
        profileUpdate.LastName = 'last';
        
        GARP_MC_MemberProfile.setMemberProfile(profileUpdate);
        GARP_BC_Authentication.isAuthenticated();
        
        Test.stopTest();
        
    }
}