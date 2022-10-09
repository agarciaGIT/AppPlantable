public without sharing class CancelBooks {
    
    public Opportunity contextRecord { get; set; }
    
    public List<SelectOption> selectOptions { get; set; }

        public Wrapper viewModel { get; set; }
    
    public class Wrapper{
        public String upsStage            { get; set; }
        public boolean CancelBooks         { get; set; }
        public boolean HasBooks            { get; set; }
       
    }
    
    public PageReference doSave(){
        if(contextRecord != null){
            
            contextRecord.Ups_Stage__c               = viewModel.upsStage;
            contextRecord.Cancel_Books__c            = viewModel.CancelBooks;
            contextRecord.Has_Books__c               = viewModel.HasBooks;
                        
                        UPDATE contextRecord;
 
            PageReference ref = new PageReference('/' + contextRecord.Id);
            
            ref.setRedirect(true);
            
            return ref;
            
        }else{
            
            return null;
            
        }
    }
        
    public CancelBooks(ApexPages.StandardController ctrl){
        
        selectOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.UPS_Stage__c.getDescribe();
        for(Schema.PicklistEntry f: fieldResult.getPicklistValues()){
            selectOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            
            contextRecord = [
                SELECT Id, Name, Shipping_First_Name__c, Has_Books__c, Cancel_Books__c ,Country_Code_for_UPS__c, Shipping_Last_Name__c,Tracking_Number__c, UPS_Stage__c, UPS_Service_Code_For_XML__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c
                FROM Opportunity
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')
                LIMIT 1
            ];
            
            Wrapper w = new Wrapper();
            
            w.upsStage                  = contextRecord.Ups_Stage__c;
            w.CancelBooks            = contextRecord.Cancel_Books__c;
            w.HasBooks            = contextRecord.Has_Books__c;
            
            viewModel = w;
            
        }else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This Opportunity does not exist.'));
            
        }
        
    }
    
}