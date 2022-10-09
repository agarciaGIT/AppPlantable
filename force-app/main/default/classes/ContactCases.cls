public  class ContactCases {


    public List<Case> Cas {get;set;}
    public id cntact {get;set;}
    public case case1 {get;set;}
    public id contactid {get;set;}
    public id caseid {get;set;}


    public ContactCases(ApexPages.StandardController controller) {
       
       this.case1= (case)controller.getRecord();
       caseid = case1.id;
       list<case> cs = [select id , contactid from case where id = :caseid];
       contactid = cs[0].contactid;
       getCas(contactid,caseid);
       
    }

   public List<Case> getCas(id contactid , id caseid)
   {
    
       Cas= [Select id, CaseNumber, Contact.Name, Contactid, Owner.Name, Subject, Status, Priority, CreatedDate, ClosedDate from Case where contactid = :contactid and id !=:caseid] ;
       
       if (cas.size()==0){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'No Related Cases for this contact.'));
       return null;
         }
   
    return Cas;
    
   }}