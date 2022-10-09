global class batchMoveUserPhotos implements Database.Batchable<SObject>, Database.AllowsCallouts
{

    public String mode;  

  global batchMoveUserPhotos(String modeIn){
        system.debug('Function: batchMoveUserPhotos');
        system.debug('mode:' + modeIn);
        
        this.mode= modeIn;            
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        if(Test.isRunningTest()){
            return Database.getQueryLocator('select id,Name,ContactID,FullPhotoUrl,SmallPhotoUrl from user where FullPhotoUrl !=\'\' and IsActive=true and (NOT FullPhotoUrl like \'%005/F\') AND ContactID not in (select Contact__c from User_Photo__c) Limit 1');
        } else if(mode != NULL) {
          return Database.getQueryLocator('select id,Name,ContactID,FullPhotoUrl,SmallPhotoUrl from user where FullPhotoUrl !=\'\' and IsActive=true and (NOT FullPhotoUrl like \'%005/F\') AND ContactID not in (select Contact__c from User_Photo__c) AND ContactID = :mode');  
        } else {
          return Database.getQueryLocator('select id,Name,ContactID,FullPhotoUrl,SmallPhotoUrl from user where FullPhotoUrl !=\'\' and IsActive=true and (NOT FullPhotoUrl like \'%005/F\') AND ContactID not in (select Contact__c from User_Photo__c) Limit 2000');
        }
        
        
    }
    
    
    global void execute(Database.BatchableContext BC, List<user> scope){

        List<User_Photo__c> newUserPhotos = new  List<User_Photo__c>();
        List<User_Photo__c> deleteUserPhotos = new  List<User_Photo__c>();
        List<Attachment> newPhotos = new  List<Attachment>();
        

        Set<String> cids = new Set<String>();
        for(user u :scope) {
            cids.add(u.ContactID);
        }
        System.Debug('cids:'+cids);
        
        List<User_Photo__c> lstPhotos = [select Id, Contact__c, Orginal_Photo_URL__c from User_Photo__c where Contact__c in :cids];
        MAP<String,User_Photo__c> mapPhotos = new MAP<String,User_Photo__c>();
        for(User_Photo__c up :lstPhotos) {
            mapPhotos.put(up.Contact__c,up);
        }
        System.Debug('mapPhotos:'+mapPhotos);        
        
        
                
        for(user usr : scope)
        {
            System.Debug('usr:' + usr );
                            
            if((usr.FullPhotoUrl != NULL && usr.FullPhotoUrl.indexOf('profilephoto/005/F') == -1) || Test.isRunningTest()) {
            
                User_Photo__c fndPhoto = mapPhotos.get(usr.ContactID);
                System.Debug('fndPhoto:' + fndPhoto );
                
                if(!Test.isRunningTest() && fndPhoto != NULL && fndPhoto.Orginal_Photo_URL__c !=NULL && fndPhoto.Orginal_Photo_URL__c == usr.FullPhotoUrl) { 
                    System.Debug('skip!');
                    continue;
                }
                
                if(fndPhoto != NULL && fndPhoto.Orginal_Photo_URL__c !=NULL && fndPhoto.Orginal_Photo_URL__c != usr.FullPhotoUrl) { 
                    deleteUserPhotos.add(fndPhoto); 
                    System.Debug('deleteUserPhotos:' + deleteUserPhotos);
                }
            
                User_Photo__c uf = New User_Photo__c(Name=usr.Name, Contact__c=usr.ContactID, Orginal_Photo_URL__c=usr.FullPhotoUrl);
                
                ConnectApi.Photo ph = ConnectApi.UserProfiles.getPhoto(null, usr.Id);
                System.debug('@@ph.standardEmailPhotoUrl'+ph.standardEmailPhotoUrl);        

                HttpRequest r = new HttpRequest();
                r.setMethod('GET');
                r.setEndpoint(ph.standardEmailPhotoUrl);
                Http http = new Http();
                blob image;
                if(!Test.isRunningTest()) {
                    HttpResponse res = http.send(r);
                    image = res.getBodyAsBlob();
                }else{
                    image = Blob.valueOf('Test body blob');
                }

                insert uf;
                Attachment a = new Attachment();
                a.body = image;
                a.ParentId = uf.ID;
                a.contentType = 'image/jpeg';
                a.name = 'photo';                                
                insert a;
                
                List<Contact> lstCont = [select Id, Name, Photo_URL__c from Contact where id = :usr.ContactID];
                if(lstCont != NULL && lstCont.size() > 0) {
                    lstCont[0].Photo_URL__c = '/servlet/servlet.FileDownload?file=' + a.id;
                    update lstCont;
                }

            }
            
        }
        
        if(!scope.isEmpty())
            update scope;
            
        if(!deleteUserPhotos.isEmpty()) 
            delete deleteUserPhotos;
        
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
        
    }


}