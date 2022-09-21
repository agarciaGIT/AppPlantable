public class Payment {
    
    public String ObjectId      { get; set; }
    public String CardMonth     { get; set; }
    public String CardYear      { get; set; }
    public String PaymentMethod { get; set; }
    public String CardType      { get; set; }
    public String CardSecurity  { get; set; }
    public String CardNumber    { get; set; }
    public Decimal ChargeAmount { get; set; }

    
    public void charge(Id opportunityId){
        
        this.ObjectId = 'a113J000000Tac6QAC';
        this.ChargeAmount = 200;
        
    }

}