public class HLRedirectController {
    
    public String ssoURL {get;set;}
    public String ReturnUrl {get;set;}
    
     public HLRedirectController() {
         ReturnUrl = ApexPages.currentPage().getParameters().get('ReturnUrl');
         if(ReturnUrl != NULL && ReturnUrl.length() > 0) {
             ssoURL = 'https://connect.garp.com/HigherLogic/Security/SAML/localSAMLLoginService.aspx?binding=HttpPost&ReturnUrl=' + ReturnUrl;
             system.debug('ssoURL: ' + ssoURL );
         }
     }
    
    public PageReference redirect(){
        system.debug('HLRedirectController ReturnUrl: ' + ssoURL );
                
        if(ssoURL != null){
            PageReference pageRef = new PageReference(ssoURL);
            pageRef.setRedirect(true);
            return pageRef;
        }
        else{
            return null;
        }
    }    

}