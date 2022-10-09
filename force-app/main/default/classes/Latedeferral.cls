public class Latedeferral
{
    public Exam_Attempt__c objEA{get;set;}
    public List<Exam_Attempt__c> lstEA{get;set;}
    public List<deferredWrap> lstDeferredWrap{get;set;}
    public Case caseRec;
    public String currentExamGrp{get;set;}
    public String chargeProcessing{get;set;}
    public String Freedeferral{get;set;}
   // public String 
    
    public Latedeferral(Apexpages.StandardController std)
    {
        objEA = new Exam_Attempt__c();
        caseRec = [select id,contactid from case where id =: std.getId()];
        
        //examAttemptDetails();
        
    }

    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }

    
    
    public pageReference examAttemptDetails()
    {
        lstDeferredWrap = new List<deferredWrap>();
        for(Exam_Attempt__c objEA : [select id,name,Member__c,Result__c,Section__c,Candidate_Commitment__r.AccountId,Exam_Site__r.Name,Exam_Site__r.Site__r.Name,Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c,Exam_Site__r.Exam_Date__c,Exam_Site__r.Exam__r.Exam__c,Exam_Date__c,Other_Exam_Registrations__r.Exam_Date__c from Exam_Attempt__c where  Member__c =: caseRec.contactId  and Opportunity_StageName__c ='closed' and result__C =:null and Defered__c !=:'Approved' order by Exam_Date__c DESC limit 2])
        {
            lstDeferredWrap.add(new deferredWrap(objEA));
        }
        return null;
    
    }
    
   
    public pageReference updateDeffered()
    {
        Integer iCount = 0;
        String strPaymentId = '';
        Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
        String examName = 'Exam Deferral';
        if(currentExamGrp == 'Yes'&& Freedeferral == 'No')
                examName = 'Late Exam Deferral';

        if(currentExamGrp == 'Yes' && Freedeferral == 'Yes')
                examName = 'Free Late Exam Deferral';
                
          if(currentExamGrp == 'No' && Freedeferral == 'Yes')
                examName = 'Free Exam Deferral';


        boolean bWire = false;
        if(chargeProcessing == 'Yes')
            bWire = true;

        for(deferredWrap objWrap : lstDeferredWrap)
        {
            if(objWrap.isDeferred)
                iCount++;
        }
        if(iCount >= 2)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select only one.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else
        {
            for(deferredWrap objWrap : lstDeferredWrap)
            {
                if(objWrap.isDeferred)
                {
                    if(objWrap.objEA.Section__c != '' && (objWrap.objEA.Section__c.toLowerCase() == 'frm part 1' || objWrap.objEA.Section__c.toLowerCase() == 'frm part 2'))
                        //strPaymentId = portalClass.checkExamAttempts(objWrap.ObjEA.Id,'FRM1','4020',true);
                        wco = portalClass.createOppRecord(objWrap.ObjEA,examName,'FRM1','4020',bWire); 
                    else
                        wco = portalClass.createOppRecord(objWrap.ObjEA,examName,'ENC','4020',bWire);
                        //strPaymentId = portalClass.checkExamAttempts(objWrap.ObjEA.Id,'ENC','4020',true);
                    //strPaymentId = portalClass.checkExamAttempts(objWrap.ObjEA.Id,'FRM1','4020',true);
                
                }
            }
        }
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Deferred process has been initiated, customer needs to make a payment.Please contact account team.');
            ApexPages.addMessage(myMsg);
        
        return null;
    
    }
    
    
    public class deferredWrap
    {
        public Exam_Attempt__c objEA{get;set;}
        public boolean isDeferred{get;set;}
        
        public deferredWrap(Exam_Attempt__c objExamAttempt)
        {
            objEA = objExamAttempt;
            isDeferred = false;
        }
    
    }
    
}