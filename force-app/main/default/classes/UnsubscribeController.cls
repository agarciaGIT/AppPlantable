public class UnsubscribeController {

    Public String mode {get; set;}
    
    public PageReference UnsubscribeController() {
        mode = ApexPages.currentPage().getParameters().get('donotemail');
    	return null;   
    }
    
}