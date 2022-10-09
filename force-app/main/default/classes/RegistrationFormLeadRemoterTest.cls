@isTest
public class RegistrationFormLeadRemoterTest {

    private final static String FORM_KEY = 'test-form-key';

    @isTest
    public static void upsertLeadWithEmailContactNotFound(){
        
        Lead lead = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'LEAD';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST LEAD';
        
        String jsonString = JSON.serialize(lead);
        
        Response.Detail res = RegistrationFormLeadRemoter.upsertLead(jsonString, FORM_KEY);
        
        System.assertEquals(201, res.status, res.message);
        
    }
    
    @isTest
    public static void upsertLeadWithEmailContactFound(){
        
        Account account = new Account();
        account.Name = 'TEST ACCOUNT';
        INSERT account;
        
        Contact contact = new Contact();
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.Email = 'test@test.com';
        contact.AccountId = account.Id;
        INSERT contact;
        
        Lead lead = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'LEAD';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST LEAD';
        
        String jsonString = JSON.serialize(lead);
        
        Response.Detail res = RegistrationFormLeadRemoter.upsertLead(jsonString, FORM_KEY);
        
        System.assertEquals(205, res.status, res.message);
        
    }
    
    @isTest
    public static void upsertLeadWithEmailAndId(){
        
        Account account = new Account();
        account.Name = 'TEST ACCOUNT';
        INSERT account;
        
        Contact contact = new Contact();
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.Email = 'test@test.com';
        contact.AccountId = account.Id;
        INSERT contact;
        
        Lead lead = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'LEAD';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST LEAD';
        INSERT lead;
        
        String jsonString = JSON.serialize(lead);
        
        Response.Detail res = RegistrationFormLeadRemoter.upsertLead(jsonString, FORM_KEY);
        
        System.assertEquals(205, res.status, res.message);
        
    }
    
    @isTest
    public static void upsertLeadWithEmailAndIdAfterConversion(){
        
        Lead lead = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'LEAD';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST LEAD';
        INSERT lead;
        
        Database.LeadConvert convertLead = new Database.LeadConvert();
        
        convertLead.setLeadId(lead.Id);
        
        LeadStatus leadStatus = [
            SELECT Id, MasterLabel 
            FROM LeadStatus 
            WHERE IsConverted = TRUE LIMIT 1
        ];
        
        convertLead.setConvertedStatus(leadStatus.MasterLabel);
        
        Database.LeadConvertResult leadConvertResult = Database.convertLead(convertLead);
        
        String jsonString = JSON.serialize(lead);
        
        Response.Detail res = RegistrationFormLeadRemoter.upsertLead(jsonString, FORM_KEY); 
        
        System.assertEquals(205, res.status, res.message);
        
    }
    
    @isTest
    public static void upsertLeadWithEmailAndIdDifferentEmail(){
        
        Lead lead = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'LEAD';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST LEAD';
        INSERT lead;
        
        lead.Email = 'changed@test.com';
        
        String jsonString = JSON.serialize(lead);
        
        Response.Detail res = RegistrationFormLeadRemoter.upsertLead(jsonString, FORM_KEY); 
        
        System.assertEquals(204, res.status, res.message);
        
    }

}