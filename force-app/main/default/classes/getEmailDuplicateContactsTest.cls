@isTest 
public class getEmailDuplicateContactsTest {
    public static testmethod void testduplicatecontacts(){
        List<Contact> conList = new  List<Contact>(); 
        Contact con = new Contact(); 
        con.LastName = 'Test LastName';
        con.FirstName = 'Test FirstName';
        con.Email = 'test@test.com';
        conList.add(con);
        Contact con1 = new Contact(); 
        con1.LastName = 'Test LastName1';
        con1.FirstName = 'Test FirstName1';
        con1.Email = 'test@test.com';
        conList.add(con1);
        insert conList;
        test.startTest(); 
        getEmailDuplicateContacts batchable = new getEmailDuplicateContacts();
        database.executeBatch(batchable);
        test.stopTest();
    } 
}