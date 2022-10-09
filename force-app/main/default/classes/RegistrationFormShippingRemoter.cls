public class RegistrationFormShippingRemoter {

    @RemoteAction
    public static Response.Detail validateAddress(String jsonString){

        try{

            Lead lead = (Lead)JSON.deserialize(jsonString, Lead.class);

            return RegistrationFormShippingHelper.validateAddress(lead);

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }

    } 

    @RemoteAction
    public static Response.Detail fetchShippingOptions(String countryCode, String postalCode, List<String> productIds){
        
        try{
            
            Set<String> uniqueProductIds = new Set<String>();
            
            uniqueProductIds.addAll(productIds);
            
            return RegistrationFormShippingHelper.fetchShippingOptions(countryCode, postalCode, uniqueProductIds);
            
        }catch(Response.ResponseException e){
            
            return new Response.Detail(e.getMessage(), e.status, e.errors);
            
        }catch(Exception e){
            
            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});
            
        }
        
    } 

    public RegistrationFormShippingRemoter(sfdcAppRemoter ctrl) {}

}