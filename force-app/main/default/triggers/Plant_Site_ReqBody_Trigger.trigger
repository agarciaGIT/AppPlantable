/******************************************************************************************************************************************
* DESCRIPTION  :   after insert trigger. automate transaction Record hit by Process transaction and Process Payment
* Queueable CLASS :   Plant_ProcessTransaction_Queueable
* TEST CLASS   :    
* 
* CREATED BY   :   HIC Dev(26 Aug)
******************************************************************************************************************************************/
trigger Plant_Site_ReqBody_Trigger on Plant_Site_ReqBody__c (after insert) {
    //if(Trigger.isAfter && Trigger.isInsert){
        //for(Plant_Site_ReqBody__c siteBody:Trigger.new){
            //if(siteBody.Plant_Done__c==False){
                //System.enqueueJob(new Plant_ProcessTransaction_Queueable(siteBody.id));
                //System.enqueueJob(new Plant_ProcessTransaction_Queueable(siteBody));
            //}
        //}
    //}
}