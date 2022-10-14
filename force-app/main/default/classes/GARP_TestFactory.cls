public class GARP_TestFactory {

    public static Contact createMember(String email, Boolean isCertified) {
        Contact cont;
        
        Id individualRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        Account acct = new Account(Name = 'Member' + email, Member_Email__c = email, RecordTypeId = individualRecId);
        insert acct;
        
        Id memContRecId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        cont = new Contact(firstname = 'fn', lastname = 'ln', AccountId = acct.id, 
                              email=email, RecordTypeId=memContRecId);
        insert cont;
        
        Id memProgRecId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        
        Contract memContract = new Contract(Opportunity__c = null, AccountId = acct.id, recordTypeId = memProgRecId, Status='Draft', ContractTerm = 12);
        insert memContract;
        memContract.Status = 'Activated';
        update memContract;
        
        if(isCertified) {
        	Id frmProgRecId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');    
            
            Contract frmContract = new Contract(Opportunity__c = null, AccountId = acct.id, recordTypeId = frmProgRecId, Status='Draft', ContractTerm = 12);
            insert frmContract;
            frmContract.Status = 'Completed';
            update frmContract;
            
        }
        
        return cont;
        
    }
    
    public static Product2 createProduct(String name, String prodCode, String GLCode) {
		return new Product2(Name = name,productCode = prodCode,GL_Code__c = GLCode,isActive = true);        
    }
    
    public static PricebookEntry createPriceBook(String productId, Decimal price) {
        Id pricebookId = Test.getStandardPricebookId();
        return new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = price, IsActive = true);
    }
    
    public static void createCountryCodes() {
        Country_Code__c cc = new Country_Code__c(
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
        
        Province__c pv = new Province__c(
            Name='New York',
            Country_Code__c=cc.id,
            Code__c='NY'
        );
        insert pv;
    }
    
}