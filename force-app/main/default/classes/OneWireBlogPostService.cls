public class OneWireBlogPostService implements Schedulable{
    
    public static Integer offsetSize = 0;
    public static Integer batchSize = 100;
    public static String contentBlogPostRecordTypeId = RecordTypeHelper.getRecordTypeId('Content__c', 'Blog Post');
    
    public class Wrapper{
        public Integer count_total { get; set; }
        public List<Post> posts { get; set; }
    }
    
    public class Post{
        public String id { get; set; }
        public String url { get; set; }
        public String title { get; set; }
        public String excerpt { get; set; }
        public String thumbnail { get; set; }
        public String date_x { get; set; }
        public String modified { get; set; }
        public String content { get; set; }
        public Author author { get; set; }
        public List<Tag> tags { get; set; }
    }
    
    public class Author{
        public String id { get; set; }
        public String first_name { get; set; }
        public String last_name { get; set; }
      }
    
    public class Tag{
        public String id { get; set; }
        public String slug { get; set; }
        public String title { get; set; }
    }
    
    public static String doCallout(String method, String endpoint){
        
        Http http = new Http();
        
        HttpRequest req = new HttpRequest();
        
        req.setMethod(method);
        req.setEndpoint(endpoint);
        req.setTimeout(120000);
        
        HttpResponse res = http.send(req);
        
        return res.getBody();
        
    }
        
    public static Integer getOneWireBlogPostsCount(){
        
        String endpoint = 'https://resources.onewire.com/api/get_posts/?count=1';
        
        OneWireBlogPostService.Wrapper wrapper = (OneWireBlogPostService.Wrapper)JSON.deserialize(doCallout('GET', endpoint), OneWireBlogPostService.Wrapper.class);

        return wrapper.count_total;   
        
    }
    
    public static String getOneWireBlogPosts(Integer count, Integer offset){
        
        String endpoint = 'https://resources.onewire.com/api/get_posts/?count=' + count;
        if(offset != null) endpoint += '&offset=' + offset;
       	
        System.debug(endpoint);
        
        return doCallout('GET', endpoint);       
    
    }
       
    public static String safeReplaceAll(String input, String delimiter, String regex, String replace){
        
        Matcher m = Pattern.compile(delimiter).matcher(input);
        
        List<String> splitInput = new List<String>();
        
        Integer index = 0;
        Integer lastEnd = 0;
        Integer limitTo = 2;

        while(!m.hitEnd()){
            
            while(index < limitTo + 1 && !m.hitEnd()){
            
                if(m.find()){
                    splitInput.add(input.substring(lastEnd, m.start()));
                    lastEnd = m.end();                  
                }else{
                    splitInput.add(input.substring(lastEnd));
                    lastEnd = input.length();
                }
                
                index++;
                
            }
            
            m.reset(input);
            m.region(lastEnd, m.regionEnd());
            
            index = 0;
            
        }
        
        List<String> output = new List<String>();
        
        for(String s: splitInput){
            
            output.add(s.replaceAll(regex, replace));
            
        }
        
        return String.join(output, delimiter);
        
    }
    
    public static Map<String, Content__c> convertJsonToContentMap(String uncleaned){
        
        String cleaned = safeReplaceAll(uncleaned, ':', '\\"date\\"', '\\"date_x\\"');
        
        OneWireBlogPostService.Wrapper wrapper = (OneWireBlogPostService.Wrapper)JSON.deserialize(cleaned, OneWireBlogPostService.Wrapper.class);   
                        
        Map<String, Content__c> contents = new Map<String, Content__c>();

        for(Post post: wrapper.posts){
            
            Content__c content = new Content__c();    
            
            content.RecordTypeId            = contentBlogPostRecordTypeId;
            content.Media_Type__c           = 'OneWire Blog Posts';
            content.External_ID__c          = post.id;
            content.Third_Party_URL__c      = post.url;
            content.Content_Name__c         = post.title;
            content.Image__c                = post.thumbnail;
            content.Raw_HTML__c             = (post.content.length() < 32000) ? post.content : null;
            content.Story__c                = (post.content.length() < 32000) ? post.content : null;
            content.Third_Party_Author__c   = post.Author.first_name + ' ' + post.Author.last_name;
            
            if(post.date_x != null){
                String yyyymmdd = post.date_x.split('\\s')[0].trim();
                String[] dateArr = yyyymmdd.split('-');
                content.Published_Date__c = Date.newInstance(Integer.valueOf(dateArr[0]), Integer.valueOf(dateArr[1]), Integer.valueOf(dateArr[2])); 
            }
          
            contents.put(content.External_ID__c, content);
           
        }
        
        return contents;
        
    }
    
    public static void performCrudOperations(Map<String, Content__c> externalMap){
               
        Map<String, Content__c> internalMap = new Map<String, Content__c>();
        
        for(Content__c content: [
            SELECT Id, Name, RecordTypeId, Media_Type__c, External_ID__c, Third_Party_URL__c, Content_Name__c, Published_Date__c, Tags__c, Third_Party_Author__c, Raw_HTML__c
            FROM Content__c 
            WHERE RecordTypeId = :contentBlogPostRecordTypeId AND Media_Type__c = 'OneWire Blog Posts'
        ]){
            internalMap.put(content.External_ID__c, content);
        }

        List<Content__c> toUpdate = new List<Content__c>();        
        List<Content__c> toInsert = new List<Content__c>();
        List<Content__c> toDelete = new List<Content__c>();

        for(Content__c content: internalMap.values()){
            if(!externalMap.containsKey(content.External_ID__c)){
                toDelete.add(internalMap.remove(content.External_ID__c));
            }else{
                externalMap.get(content.External_ID__c).Id = content.Id;
                internalMap.put(content.External_ID__c, externalMap.get(content.External_ID__c));
            }
        }
        
        toUpdate.addAll(internalMap.values());
        
        for(Content__c content: externalMap.values()){
            if(internalMap.containsKey(content.External_ID__c)) continue;
            toInsert.add(content);
        } 
        
        if(!toUpdate.isEmpty()) UPDATE toUpdate;
        if(!toInsert.isEmpty()) INSERT toInsert;
        if(!toDelete.isEmpty()) DELETE toDelete;
        
    }
    
    @future(callout=true)
    public static void retrieveOneWireBlogPosts(){
    	System.enqueueJob(new OneWireBlogPostServiceQueueable(batchSize, offsetSize, getOneWireBlogPostsCount(), new Map<String, Content__c>()));      
    }
    
    public static void execute(SchedulableContext sc){
        retrieveOneWireBlogPosts();
    }
    
}