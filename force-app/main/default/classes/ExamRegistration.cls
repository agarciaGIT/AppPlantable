public class ExamRegistration {

    public class Card{
        public String expirationMonth   { get; set; }
        public String expirationYear    { get; set; }
        public String fullName          { get; set; }
        public String cardNumber        { get; set; }
        public String securityCode      { get; set; }
    }
    
    public class Shipping{
        public String currencyCode              { get; set; }
        public String guaranteedDaysToDelivery  { get; set; }
        public String label                     { get; set; }
        public String monetaryValue             { get; set; }
        public String scheduledDeliveryTime     { get; set; }
        public String serviceCode               { get; set; }
    }
    
    public class ExamPricebookEntry{
        public String id									        { get; set; }
        public Exam__c exam 								        { get; set; }
        public PricebookEntry pricebookEntry 				        { get; set; }
    }
   
    public class Site{
        public String id									{ get; set; }
        public String label									{ get; set; }
        public Site__c site 								{ get; set; }
    }
     
    public class Exam{
        public String id									{ get; set; }
        public String label									{ get; set; }
        public List<ExamPricebookEntry> examPricebookEntries{ get; set; }
    }
    
    public class Item{
        
        public String id									{ get; set; }
        public String label									{ get; set; }
        public Boolean comped								{ get; set; }
        public Boolean selected     						{ get; set; }
        public Product2 product2     						{ get; set; }    
        public Boolean purchased							{ get; set; }
        public Datetime purchasedDate						{ get; set; }	
        public PricebookEntry pricebookEntry 				{ get; set; }
            
        public Item(){}
        
        public Item(PricebookEntry pricebookEntry){            
            this.id = pricebookEntry.ProductCode;
            this.label = pricebookEntry.Product2.Name;
            this.comped = false;
            this.selected = false;
            this.product2 = pricebookEntry.Product2;
            this.purchased = false;
            this.purchasedDate = null;
            this.pricebookEntry = pricebookEntry;
        }
        
    }
    
}