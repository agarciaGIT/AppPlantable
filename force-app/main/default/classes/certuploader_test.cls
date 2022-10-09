@isTest
public class certuploader_test {

    static testMethod void unitTest_1(){
        Account a1 = new Account(name = 'Test Account1');
        insert a1;
        Contact c1 = new contact(lastname = 'Doe',firstname='John',AccountID = a1.ID,MailingCity='New York',Mailing_Address_Company__c='1234, New Port Mall',MailingCountry='US', email = 'JohnDoe@contact.com',OtherPhone='123456789',MailingPostalCode = '07301',MailingState='NJ', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing',GARP_Member_ID__c='101010');
        insert c1;
        certificate_shipping__c cert = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert;
        test.startTest();
        List<certificate_shipping__c> lstcer = [Select id,Name from certificate_shipping__c where id =:cert.Id];
        certuploader file = new certuploader();
        file.contentFile = blob.valueOf('<xml><OpenShipment><ProcessMessage><TrackingNumbers><number>1234</number></TrackingNumbers><Reference1>'+lstcer[0].Name+'</Reference1></ProcessMessage></OpenShipment></xml>');
        file.fileName = 'test';
        file.ReadFile();
        test.stopTest();
    }
}