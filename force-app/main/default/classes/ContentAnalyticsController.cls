public class ContentAnalyticsController {

    public static Id contentId;
    public static Id contactId;
    
    public static void doContentAnalytics(){
        if(contentId != null && contactId == null){
            ContentAnalyticsService.getContentDocInternal(contentId);
        }else if(contentId != null && contactId != null){
            ContentAnalyticsService.getContentDocInternal(contentId, contactId);
        }
    }
    
    public ContentAnalyticsController(){
        
        Map<String, String> urlParameters = ApexPages.currentPage().getParameters();
        
        if(urlParameters.containsKey('contentId')) contentId = urlParameters.get('contentId');
        if(urlParameters.containsKey('contactId')) contactId = urlParameters.get('contactId');
                
    }
    
}