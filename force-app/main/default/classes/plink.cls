public class plink {
    
   Public string pubType;
    
    public void plink(){
    }
    
    public PageReference redirect(){
        
        String acctID = ApexPages.currentPage().getParameters().get('i');
        String type;
        String url;
        
        if(Test.isRunningTest()){
            acctID = '123~' + pubType;
        }
        
        if(acctID != NULL && acctID.length() > 0) {
            String[] arrStr = acctID.split('~');
            if(arrStr.size() > 1) {
                acctID = arrStr[0];
                type = arrStr[1];
            }
        }
 
        if(type == '1') {
            url = 'https://my.plantable.com/emailTracker?campname=Reboot%20Completion%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyFinisher%3Fid%3D' + acctID;
        } else if(type == '2') {
            url = 'https://my.plantable.com/emailTracker?campname=Reboot%20Delivery%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyStarter%3Fid%3D' + acctID;
        } else if(type == '3') {
            url = 'https://my.plantable.com/emailTracker?campname=Quickstart%20Completion%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyFinisher%3Fid%3D' + acctID;
        } else if(type == '4') {
            url = 'https://my.plantable.com/emailTracker?campname=Quickstart%20Delivery%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyStarter%3Fid%3D' + acctID;
        } else if(type == '5') {
            url =  'https://my.plantable.com/emailTracker?campname=Quickstart%20Completion%20SMS&acctid=' + acctID + '&meta1=Login&url=https%3A%2F%2Fwww.plantable.com%2Faccount';
        }            
        
        //Write your logic here and redirect
        PageReference retURL = new PageReference(url);
        retURL.setRedirect(true);
        return retURL;
        
    }
    
}