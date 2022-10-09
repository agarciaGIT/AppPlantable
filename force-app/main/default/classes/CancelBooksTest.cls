@isTest
public class CancelBooksTest {

    @isTest
    public static void doSave(){

        Opportunity o = new Opportunity(
            Name = 'TESTABC',
            Shipping_First_Name__c = 'TESTFIRSTNAME',
            StageName = 'Open',
            CloseDate = Date.today()
        );
        
        INSERT o;
        
        PageReference currentPageRef = Page.CancelBooks;
        
        currentPageRef.getParameters().put('id', o.Id);
        
        Test.setCurrentPage(currentPageRef); 
        
        CancelBooks ctrl = new CancelBooks(new ApexPages.StandardController([
            SELECT Id, Name, Shipping_First_Name__c, Has_Books__c ,Country_Code_for_UPS__c , Cancel_Books__c ,Shipping_Last_Name__c, UPS_Stage__c, UPS_Service_Code_For_XML__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c
            FROM Opportunity
            WHERE Id = :o.Id
            LIMIT 1
        ]));  
        
        ctrl.doSave();
    
    }
    
}