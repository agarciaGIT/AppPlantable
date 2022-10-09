global class CurrencyConverter{
    
    public class CurrencyLayer{
        public Boolean success { get; set; }
        public Integer timestamp { get; set; }
        public String source { get; set; }
        public Map<String, Double> quotes { get; set; }
    }
    
    public static Map<String, Double> getCurrencyTypes(){
        
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndPoint('http://www.apilayer.net/api/live?access_key=adb57e02585628c5c6d7b9461f80d29d&format=1'); 
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        CurrencyLayer currencyLayer = (CurrencyLayer)JSON.deserialize(response.getBody(), CurrencyConverter.CurrencyLayer.class);
               
        Map<String, Double> quotes = new Map<String, Double>();
        
        if(currencyLayer != null && currencyLayer.quotes != null){
            
            for(String quoteKey: currencyLayer.quotes.keySet()){
                quotes.put(quoteKey.substringAfter('USD'), currencyLayer.quotes.get(quoteKey));
            }

            return quotes;
            
            /*
            if(quotes.containsKey(type)){
                
                return quotes.get(type);
                
            }else{
                               
            	return 1.00;
                
            }
			*/
            
        }else{
            
            return null;
            
            //return 1.00;
            
        }
        
        
       	
             
    }
}