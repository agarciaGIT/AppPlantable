public class cariiClass {

    public class uriItem {
        String uri;
    }
    
    // Register / Auth
    
    public class regitserReq {
        String companyId;
        String key;
    }

    public class registerRespItem {
        String key;
    }
    
    public class registerResp {
        String code;
        String message;
        registerRespItem item;
    }

    // Sync 
    
    public class syncReq {
        String type;
        String action;
        //Data
    }

    
    // POST /latest/[valid type]/
    // type = [chat,survey,finisher,tracking]
    public class latestReq {
        String reqDate;
        String page;
        String rowPerPage;
    }
    
    // Chat
    
    public class latestRespChatItemUser {
      String id;
        String username;
        String name;
        String email;
    }
    
    public class latestRespChatItemRoom {
      	String id;
        List<String> usernames;
        List<latestRespChatItemUser> names;
        String t;
        Integer msgs;
        String ts;
        String lm;
    }        
    
    public class latestRespChatItem {
      	String id;
        String msg;
        String ts;
        latestRespChatItemUser u;
        latestRespChatItemRoom room;
    }
    
  public class latestRespChat {
        String code;
        String message;
        Integer count;
        List<latestRespChatItem> result;
    }

    // Survey
    
    public class latestRespSurveyItemPerson {
        String id;
        String email;
        String fullName;
        String fullName_lcase;
    }
    
    public class latestRespSurveyItemChoice {
        String id;
        Integer trackChoiceCode;
        String trackChoiceName;
        String trackChoiceDescriptions;
    }

    public class latestRespSurveyItemBloodWork {
        String date_lastCheck;
        String total_colesterol;
        String ldl;
        String hg_a1c;
        String hs_crp;
    }
    
    public class planCategoryInterest {
        Integer planCode;
        String planName;
    }
    
    public class latestRespSurveyItem {
      String id;
        String createdAt;
        latestRespSurveyItemPerson createdBy;
        Boolean is_male;
        String height;
        String height2;
        Integer weight;
        String weight2;
        String waist;
        String waist2;
        Integer well_beingIndex;
        String hips;
    	String hips2;
        List<latestRespSurveyItemChoice> listChoice;
        latestRespSurveyItemBloodWork bloodWork;
        List<planCategoryInterest> planCategoryInterest;
		String age;        
    }
    
  public class latestRespSurvey {
        String code;
        String message;
        Integer count;
        List<latestRespSurveyItem> result;
    }        

  // Finisher same as survey

    // Tracking
    public class latestRespTrackingItemModuleTrackComply {
        String id;
        Integer trackComplyCode;
        String trackComplyName;
        String trackComplyDescriptions;
        
    }
    
    public class latestRespTrackingItemModule {
      String id;
        String moduleCode;
        String moduleName;
    }
    
    public class latestRespTrackingItemPostContent {
        String measurementDate;
        Integer measurementDate_int;
        List<latestRespTrackingItemModuleTrackComply> trackComply;
        String weight;
        String notes;
        Integer coin;
        
    }
           
    public class latestRespTrackingItem {
        String id;
        String createDate;
        String lastUpdate;
        latestRespSurveyItemPerson createBy;
        latestRespTrackingItemPostContent postContent;
    }
    
    public class latestRespTracking {
        String code;
        String message;
        Integer count;
        List<latestRespTrackingItem> result;
    }      
    
	public static String safeSetString(String inStr, String strOpt) {
        if(inStr != null) {
            return inStr;
        } else if(strOpt != NULL) {
            return strOpt;
        }
        else return '';
    }    
    
    public static String registerCarii() {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://app.euphebe.com/api/register';
        system.debug('endpoint:' + endpoint);
        request.setEndPoint(endpoint);
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');     
        String jsonBody = '{"companyId":"euphebe","key":"EUPHEBE2017"}';
        request.setBody(jsonBody);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        String body='';
        String authKey='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                body = response.getBody();
                if(body != null) {
                	registerResp rr = (registerResp)JSON.deserialize(body, registerResp.class);
                    if(rr != null && rr.item != null && rr.item.key != null) {
                        authKey = rr.item.key;
                    }
                }
            } else {
                body = '{"code": 0,"message": "success","item": {"key": "ca6fed09ef995b1474b8a75ef8c8f22dfc6a8415"}}';
            }
            System.debug('body:' + body);
            System.debug('authKey:' + authKey);
        }
        return authKey;        
    }        

    public static String callCarii(String endPoint, String jsonBody, String authKey) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        //String endpoint = 'https://app.euphebe.com/api/register';
        system.debug('endpoint:' + endpoint);
        request.setEndPoint(endpoint);
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');     
        request.setHeader('companyId', 'euphebe');     
        request.setHeader('Authorization', 'Bearer ' + authKey);     
        
        system.debug('callCarii jsonBody:'+jsonBody);
        request.setBody(jsonBody);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('callCarii statusCode:' + String.valueOf(statusCode));
        String body='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                if(endPoint.indexOf('finisher') > -1 || endPoint.indexOf('survey') > -1)
                	body = '{"code": 0,"message": "success","count": 1,"result": [{"createdAt": "2018-01-05T17:56:51.204Z","createdBy": {"fullName": "Ali Garrity","fullName_lcase": "ali garrity","email": "aligarrity@mac.com","id": "cuKPHStMrMMkdEXLi"},"is_male": false,"height": "5’","height2": "3.0”","weight": 200,"weight2": "0.0","waist": "34”","waist2": "0.0","well_beingIndex": 4,"hips": "","hips2": "0.0","listChoice": [{"trackChoiceCode": 2,"trackChoiceName": "Lose The Junk","trackChoiceDescriptions": "Lose The Junk","id": "eQwAxKAfTW8HDHsj3"},{"trackChoiceCode": 1,"trackChoiceName": "No to sugar","trackChoiceDescriptions": "No to sugar","id": "uahryh8ytWsT7zaWw"},{"trackChoiceCode": 3,"trackChoiceName": "Incessant Snacking","trackChoiceDescriptions": "Incessant Snacking","id": "pFZC9vRcXcRHMfrGE"},{"trackChoiceCode": 4,"trackChoiceName": "No or Low Alcohol","trackChoiceDescriptions": "No or Low Alcohol","id": "m5ovWfhzuzd95pD3h"}],"bloodWork": {"date_lastCheck": "2018-01-05T05:00:00.000Z","total_colesterol": "","ldl": "","hg_a1c": "","hs_crp": ""},"planCategoryInterest": [{"planCode": 1,"planName": "weight loss","plandescriptions": "weight loss descriptions","id": "ZZMQSHRXzKHhLRfmy"}],"photo": "https://euphebe-prod.c3.carii.com/assets/images/survey/cuKPHStMrMMkdEXLi/carii_k56mn2rp4jbxtgry8_photo.jpg","age": "","id": "LXBeemZb3XuoJXs72"}]}';
                else if(endPoint.indexOf('tracking') > -1) 
	                body = '{"code": 0,"message": "success","count": 1,"result": [{"createDate": "2018-07-01T13:10:35.955Z","lastUpdate": "2018-07-01T13:10:35.955Z","createBy": {"fullName": "Darren Nixon","fullName_lcase": "darren nixon","email": "dnixon@chelseapiers.com","id": "cQ2oTZTet65QdAvMF"},"module": {"moduleCode": 6,"moduleName": "track-diet","id": "4NzDxSh4hC7aZWJxW"},"postContent": {"measurementDate": "2018-07-01T04:00:00.000Z","measurementDate_int": 20180701,"trackComply": [{"trackComplyCode": 2,"trackComplyName": "No Crappy","trackComplyDescriptions": "Snacks Junk","id": "yrhipdNokR9kWFair"},{"trackComplyCode": 4,"trackComplyName": "No Booze","trackComplyDescriptions": "No Booze","id": "3BwJtRbdHk4CkJ8ab"},{"trackComplyCode": 3,"trackComplyName": "No Added Sugar","trackComplyDescriptions": "No Added Sugar","id": "2ZbDouLXcjpsKCKag"},{"trackComplyCode": 1,"trackComplyName": "B\'Fast, Lunch & Dinner","trackComplyDescriptions": "B\'Fast, Lunch & Dinner","id": "T9cgCt6TtcJZoNDi3"}],"weight": "181","notes": "Feeling good ","coin": 5},"id": "XgucLGgx3CLAMJ2b5"}]}';
    			else body = '{"code": 0,"message": "success","count": 1,"result": [{"msg": "That\'s fabulous. Keep up the great work (: ","ts": "2018-07-27T18:19:26.330Z","u": {"username": "CoachEuphebe","name": "Coach Euphebe","photo": "https://euphebe-prod.c3.carii.com/assets/images/profile/sR6M2wJJbD4GWw6FM/carii_esrgzdmjjbsfxj83m_photo.jpg","email": "coach@euphebe.com","id": "sR6M2wJJbD4GWw6FM"},"room": {"usernames": ["CoachEuphebe","SamAlpert"],"names": [{"username": "CoachEuphebe","name": "Coach Euphebe","email": "coach@euphebe.com","id": "sR6M2wJJbD4GWw6FM"},{"username": "SamAlpert","name": "Sam Alpert  ","email": "sam.alpert@img.com","id": "GtJyN4PfGWy77ik5Z"}],"t": "d","msgs": 33,"ts": "2018-07-14T14:53:54.131Z","lm": "2018-07-27T18:19:26.330Z","id": "sR6M2wJJbD4GWw6FMGtJyN4PfGWy77ik5Z"},"id": "ftHj4hY6hs2r2DvHu"}]}';
            }
            System.debug('body:' + body);
        }
        return body;        
    }            
    
    public static Integer safeIntConv(String inStr) {
        system.debug('safeIntConv inStr:' + inStr);        
        if(inStr != NULL && inStr.length() > 0) {
            Pattern nonAlphanumeric = Pattern.compile('[^0-9.]');
            Matcher matcher = nonAlphanumeric.matcher(inStr);
            inStr = matcher.replaceAll('');
            
            if(inStr.contains('.')) {
                Decimal dec = Decimal.valueOf(inStr);
                Integer ints = Integer.valueOf(dec);
                inStr = String.valueOf(ints);
            }
            
            if(inStr.length() > 0)
            	return Integer.valueOf(inStr);
            else return null;                        
        } else {
            return null;
        }
    }

    public static Decimal safeDecConv(String inStr) {
        system.debug('safeDecConv inStr:' + inStr);
        if(inStr != NULL && inStr.length() > 0) {
            Pattern nonAlphanumeric = Pattern.compile('[^0-9.]');
            Matcher matcher = nonAlphanumeric.matcher(inStr);
            inStr = matcher.replaceAll('');
            if(inStr.length() > 0)
            	return Decimal.valueOf(inStr);
            else return null;            
        } else {
            return null;
        }
    }
    
    public static Integer convertFeet(String inStr) {
        system.debug('convertFeet inStr:' + inStr);
        if(inStr != NULL && inStr.length() > 0) {
            Pattern nonAlphanumeric = Pattern.compile('[^0-9.]');
            Matcher matcher = nonAlphanumeric.matcher(inStr);
            inStr = matcher.replaceAll('');
            if(inStr.length() > 0)
            	return Integer.valueOf(inStr);
            else return null;                        
        } else {
            return null;
        }
    }

    public static Integer convertInches(String inStr) {
        system.debug('convertInches inStr:' + inStr);
        if(inStr != NULL && inStr.length() > 0) {
            Pattern nonAlphanumeric = Pattern.compile('[^0-9.]');
            Matcher matcher = nonAlphanumeric.matcher(inStr);
            inStr = matcher.replaceAll('');
            if(inStr.length() > 0)
            	return Integer.valueOf(inStr);
            else return null;            
        } else {
            return null;
        }        
    }
    
    public static Decimal convertInchesDec(String inStr) {
        system.debug('convertInches inStr:' + inStr);
        if(inStr != NULL && inStr.length() > 0) {
            Pattern nonAlphanumeric = Pattern.compile('[^0-9.]');
            Matcher matcher = nonAlphanumeric.matcher(inStr);
            inStr = matcher.replaceAll('');
            if(inStr.length() > 0)
            	return Decimal.valueOf(inStr);
            else return null;
        } else {
            return null;
        }        
    }
    
    public static DateTime convDate(String inStr) {
        Datetime dt=null;
        String[] dtParts = inStr.split('T');
        if(dtParts.size() > 1) {
            System.debug('dtParts:' + dtParts);
            String[] dateParts = dtParts[0].split('-');
            if(dateParts.size() > 2) {
                System.debug('dateParts:' + dateParts);    
                
                String[] timeParts = dtParts[1].split(':');
                if(timeParts.size() > 2) {
                    System.debug('timeParts:' + timeParts);  
                    
                    String[] secondParts = timeParts[2].split('\\.');
                    if(secondParts.size() > 0) {
                        String seconds =  secondParts[0];
                        dt = DateTime.newInstance(Integer.valueOf(dateParts[0]), Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[2]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(seconds));
                        System.debug('dt:' + dt);
                    }
                }
            }
        }
		return dt;
    }
        
    // Mode = Survey | Finisher
    @future(callout=true)
    public static void loadSurvey(String fromDate, String Mode, Integer pageNum) {
        Integer loadCnt = 0;
        latestRespSurvey lrs;
        
        if(pageNum == null)
            pageNum = 0;
        
        String authKey = cariiClass.registerCarii();
		String jbody = '{"lastDate" : "' + fromDate + '","RowPerPage" :1, "page" : ' + pageNum + '}';
        String respBody;
        
        if(mode == 'Finisher')
            respBody = cariiClass.callCarii('https://app.euphebe.com/api/latest/finisher/',jbody,authKey);
        else respBody = cariiClass.callCarii('https://app.euphebe.com/api/latest/survey/',jbody,authKey);
        
        if(respBody != null) {
        
            // Fix repsonse JSON
            respBody = respBody.replace('"weight":""','"weight":null');
            respBody = respBody.replace('"well_beingIndex":""','"well_beingIndex":null');
            respBody = respBody.replace('"trackChoiceCode":""','"trackChoiceCode":null');
                            
            lrs = (latestRespSurvey)JSON.deserialize(respBody, latestRespSurvey.class);
            System.debug('lrs:' + lrs);
            
            List<Health_Survey__c> lstHS = [select Id, Name, Carii_ID__c from Health_Survey__c];
            Set<String> setIDs = new Set<String>();
            for(Health_Survey__c hs :lstHS) {
                if(hs.Carii_ID__c != Null)
                    setIDs.add(hs.Carii_ID__c);
            }
            
            List<Account> lstAcct = [select Id, Name, Email__c from Account];
			Map<String,String> mapAcct = new Map<String,String>();
            for(Account acct :lstAcct) {
                if(acct.Email__c != null)
                    mapAcct.put(acct.Email__c, acct.Id);
            }
            
            if(lrs != NULL && lrs.result != NULL) {
                
                List<Health_Survey__c> addHS = new List<Health_Survey__c>();
                
                for(latestRespSurveyItem si :lrs.result) {                    
                    System.debug('si:' + si);
                    
                    Boolean fndId = setIDs.contains(si.id);
                    System.debug('fndId:' + fndId);
                    
                    if(si.createdBy != null && si.createdBy.email != Null) {
                        String accId = mapAcct.get(si.createdBy.email);
                        System.debug('accId:' + accId);
                        
                        // No Accounts in Dev so skip this check for now
                        //if(fndId == False && accId != Null) {
                        if(fndId == False) {
                            System.debug('createdBy.email:' + si.createdBy.email);
                            
                            Health_Survey__c newHS = new Health_Survey__c();
                            
                            // If no Account found add data with email
                            if(accId != Null)
                            	newHS.Account__c = accId;
                            else newHS.Email_Address__c = si.createdBy.email;
                            
                            if(mode == 'Finisher')
                                newHS.Is_Finisher_Survey__c = true;
                            
                            newHS.Age__c = si.age;
                            newHS.Carii_ID__c = si.id;                            
                            newHS.Height_Feet__c = convertFeet(si.height);
                            newHS.Height_Inches__c = convertInchesDec(si.height2);
                            newHS.HG_A1C__c = safeDecConv(si.bloodWork.hg_a1c);
                            newHS.Hips_Inches__c = convertInches(si.hips);
                            newHS.HS_CRP__c = safeDecConv(si.bloodWork.hs_crp);
                            newHS.Is_Male__c = si.is_male;
                            newHS.LDL__c = safeIntConv(si.bloodWork.ldl);
                            newHS.Survey_Date__c = convDate(si.createdAt);
                            newHS.Total_Colesterol__c = safeIntConv(si.bloodWork.total_colesterol);
                            newHS.Waist__c = convertInches(si.waist);
                            newHS.Weight__c = si.weight;
                            newHS.Well_Being_Index__c = si.well_beingIndex;
                            
                            String strPoison = '';
                            if(si.listChoice != NULL && si.listChoice.size() > 0) {
                                for(latestRespSurveyItemChoice lc :si.listChoice) {

                                   	// No to sugar
                                    if(lc.trackChoiceCode != NULL && lc.trackChoiceCode == 1) {
                                        if(strPoison == '')
                                            strPoison = 'No added sugar';
                                        else strPoison += ';No added sugar';
                                    }

                                   	// Lose The Junk - Not sure where it goes??
                                    if(lc.trackChoiceCode != NULL && lc.trackChoiceCode == 2) {
                                        if(strPoison == '')
                                            strPoison = 'No refined grains';
                                        else strPoison += ';No refined grains';
                                    }
                                    
									// Incessant Snacking - not sure if these are the same??
                                    if(lc.trackChoiceCode != NULL && lc.trackChoiceCode == 3) {
                                        if(strPoison == '')
                                            strPoison = 'No crappy snacks';
                                        else strPoison += ';No crappy snacks';
                                    }

									// No or Low Alcohol
                                    if(lc.trackChoiceCode != NULL && lc.trackChoiceCode == 4) {
                                        if(strPoison == '')
                                            strPoison = 'No or low alcohol';
                                        else strPoison += ';No or low alcohol';
                                    }

                                }
                            }
                            
                            newHS.Whats_your_poison__c = strPoison;
                            
                            String strInIt = '';
                            if(si.planCategoryInterest != NULL && si.planCategoryInterest.size() > 0) {
                                for(planCategoryInterest lc :si.planCategoryInterest) {

                                   	// Weight loss
                                    if(lc.planCode != NULL && lc.planCode == 1) {
                                        if(strInIt == '')
                                            strInIt = 'Weight loss';
                                        else strInIt += ';Weight loss';
                                    }

                                   	// Improved energy
                                    if(lc.planCode != NULL && lc.planCode == 2) {
                                        if(strInIt == '')
                                            strInIt = 'Improved energy';
                                        else strInIt += ';Improved energy';
                                    }

                                   	// Improved blood markers
                                    if(lc.planCode != NULL && lc.planCode == 3) {
                                        if(strInIt == '')
                                            strInIt = 'Improved blood markers';
                                        else strInIt += ';Improved blood markers';
                                    }

                                   	// Loss of belly fat
                                    if(lc.planCode != NULL && lc.planCode == 4) {
                                        if(strInIt == '')
                                            strInIt = 'Loss of belly fat';
                                        else strInIt += ';Loss of belly fat';
                                    }                                    
                                    
                                   	// Improved mind clarity
                                    if(lc.planCode != NULL && lc.planCode == 5) {
                                        if(strInIt == '')
                                            strInIt = 'Improved mind clarity';
                                        else strInIt += ';Improved mind clarity';
                                    }

                                   	// Sustainable lifestyle change
                                    if(lc.planCode != NULL && lc.planCode == 6) {
                                        if(strInIt == '')
                                            strInIt = 'Sustainable lifestyle change';
                                        else strInIt += ';Sustainable lifestyle change';
                                    }
                                    newHS.Whats_in_it_for_you__c = strInIt;
                                }
                            }
                            
                            //newHS.Whats_in_it_for_you__c = si.age;
                            newHS.Whats_your_poison__c = strPoison;
                            
                            system.debug('newHS: ' + newHS);
                            addHS.add(newHS);
                        }
                    }
                }
                if(addHS.size() > 0)
                    insert addHS;
            }
        }
        //return loadCnt;
    }
    
    // fromDate = YYYY/MM/DD
    @future(callout=true)
    public static void loadTracking(String fromDate, Integer pageNum) {
        Integer loadCnt = 0;
        latestRespTracking lrt;
        
        if(pageNum == null)
            pageNum = 0;
        
        String authKey = cariiClass.registerCarii();
		String jbody = '{"lastDate" : "' + fromDate + '","RowPerPage" :1, "page" : ' + pageNum + '}';
        String respBody;
        
        respBody = cariiClass.callCarii('https://app.euphebe.com/api/latest/tracking/',jbody,authKey);
        
        if(respBody != null) {
        
            // Fix repsonse JSON
            respBody = respBody.replace('"weight":""','"weight":null');
            respBody = respBody.replace('"well_beingIndex":""','"well_beingIndex":null');
            respBody = respBody.replace('"trackChoiceCode":""','"trackChoiceCode":null');
            
            lrt = (latestRespTracking)JSON.deserialize(respBody, latestRespTracking.class);
            System.debug('lrt:' + lrt);
            
            List<Progress_Tracking__c> lstPT = [select Id, Name, Carii_ID__c from Progress_Tracking__c];
            Set<String> setIDs = new Set<String>();
            for(Progress_Tracking__c pt :lstPT) {
                if(pt.Carii_ID__c != Null)
                    setIDs.add(pt.Carii_ID__c);
            }
            
            List<Account> lstAcct = [select Id, Name, Email__c from Account];
			Map<String,String> mapAcct = new Map<String,String>();
            for(Account acct :lstAcct) {
                if(acct.Email__c != null)
                    mapAcct.put(acct.Email__c, acct.Id);
            }
            
            if(lrt != NULL && lrt.result != NULL) {
                
                List<Progress_Tracking__c> addPT = new List<Progress_Tracking__c>();
                
                for(latestRespTrackingItem ti :lrt.result) {                    
                    System.debug('ti:' + ti);
                    
                    Boolean fndId = setIDs.contains(ti.id);
                    System.debug('fndId:' + fndId);
                    
                    if(ti.createBy != null && ti.createBy.email != Null) {
                        String accId = mapAcct.get(ti.createBy.email);
                        System.debug('accId:' + accId);
                        
                        // No Accounts in Dev so skip this check for now
                        //if(fndId == False && accId != Null) {
                        if(fndId == False) {
                            System.debug('createBy.email:' + ti.createBy.email);
                            
                            Progress_Tracking__c newPT = new Progress_Tracking__c();
                            
                            // If no Account found add data with email
                            if(accId != Null)
                            	newPT.Account__c = accId;
                            else newPT.Email_Address__c = ti.createBy.email;
                            
                            if(ti.postContent != NULL) {
                            
                                newPT.Weight__c = safeDecConv(ti.postContent.weight);
                                newPT.Notes__c = ti.postContent.notes;
                                newPT.Points__c = ti.postContent.coin;
                                newPT.Measurement_Date__c = convDate(ti.postContent.measurementDate);
                                
                                if(ti.postContent.trackComply != NULL && ti.postContent.trackComply.size() > 0) {
                                    for(latestRespTrackingItemModuleTrackComply tc :ti.postContent.trackComply) {
                                        
                                        if(tc.trackComplyCode == 1) {
                                            newPT.Approved_BLD__c = true;
                                        } else if(tc.trackComplyCode == 2) {
                                            newPT.No_Junk__c = true;                                            
                                        } else if(tc.trackComplyCode == 3) {
                                            newPT.No_Sugar__c = true;                                            
                                        } else if(tc.trackComplyCode == 4) {
                                            newPT.No_Alcohol__c = true;                                            
                                        }
                                        
                                    }
                                }                                
                            }
                                                        
                            system.debug('newPT: ' + newPT);
                            addPT.add(newPT);
                        }
                    }
                }
                if(addPT.size() > 0)
                    insert addPT;
            }
        }
        //return loadCnt;
    }    
    
    // fromDate = YYYY/MM/DD
    @future(callout=true)
    public static void loadChat(String fromDate, Integer pageNum) {
        Integer loadCnt = 0;
        latestRespChat lrc;
        
        if(pageNum == null)
            pageNum = 0;
        
        String authKey = cariiClass.registerCarii();
		String jbody = '{"lastDate" : "' + fromDate + '","RowPerPage" :1, "page" : ' + pageNum + '}';
        String respBody;
        
        respBody = cariiClass.callCarii('https://app.euphebe.com/api/latest/chat/',jbody,authKey);
        
        if(respBody != null) {
        
            // Fix repsonse JSON
            //respBody = respBody.replace('"weight":""','"weight":null');
                            
            lrc = (latestRespChat)JSON.deserialize(respBody, latestRespChat.class);
            System.debug('lrc:' + lrc);
            
            List<Chat__c> lstChat = [select Id, Name, Carii_ID__c from Chat__c];
            Set<String> setIDs = new Set<String>();
            for(Chat__c c :lstChat) {
                if(c.Carii_ID__c != Null)
                    setIDs.add(c.Carii_ID__c);
            }
            
            List<Account> lstAcct = [select Id, Name, Email__c from Account];
			Map<String,String> mapAcct = new Map<String,String>();
            for(Account acct :lstAcct) {
                if(acct.Email__c != null)
                    mapAcct.put(acct.Email__c, acct.Id);
            }
            
            if(lrc != NULL && lrc.result != NULL) {
                
                List<Chat__c> addChat = new List<Chat__c>();
                
                for(latestRespChatItem ci :lrc.result) {                    
                    System.debug('ci:' + ci);
                    
                    Boolean fndId = setIDs.contains(ci.id);
                    System.debug('fndId:' + fndId);
                    
                    if(ci.u != null && ci.u.email != Null) {
                        String accId = mapAcct.get(ci.u.email);
                        System.debug('accId:' + accId);
                        
                        // No Accounts in Dev so skip this check for now
                        //if(fndId == False && accId != Null) {
                        if(fndId == False) {
                            System.debug('ci.u.email:' + ci.u.email);
                            
                            Chat__c newChat = new Chat__c();
                            
                            // If no Account found add data with email
                            if(accId != Null)
                            	newChat.Account__c = accId;
                            
                            newChat.Email_Address__c = ci.u.email;
                            
                            if(ci.msg != NULL) {
                            
                                newChat.Message__c = ci.msg;
                                newChat.Message_Date__c = convDate(ci.ts);
                                
                                if(ci.room != null && ci.room.names != null && ci.room.names.size() > 0) {
                                    
                                    for(latestRespChatItemUser ri :ci.room.names) {
                                        // Other person
                                        if(ri.email != NULL && ri.email != newChat.Email_Address__c) {
                                            
                                            String fndAcct = mapAcct.get(ri.email);
                                            if(fndAcct != null)
                                            	newChat.To_Account__c = fndAcct;
                                            newChat.To_Email_Address__c = ri.email;
                                            
                                            // Set Account to User No Coach
                                            if(ci.u.email == 'coach@euphebe.com' && fndAcct != null) {
                                                newChat.Account__c = fndAcct;
                                            }
                                        }
                                    }
                                }
                                
                                newChat.Carii_ID__c = ci.id;
                                                   
                            }
                                                        
                            system.debug('newChat: ' + newChat);
                            addChat.add(newChat);
                        }
                    }
                }
                if(addChat.size() > 0)
                    insert addChat;
            }
        }
        //return loadCnt;
    }        

 	@future(callout=true)
    public static void sendCarriOrder(String apiReqId, String orderId) {    

        String start_date = '';
        String delivery_date;
        
        String authKey = registerCarii();
        System.debug('authKey: ' + authKey);
        
        if(authKey!= null) {
            List<API_Request__c> apiReqs = [select Id, Name, OrderId__c, Customer_Email__c, Billing_Street1__c, Billing_Street2__c, Billing_City__c, Billing_Company__c, Billing_State__c, Billing_Country__c, Billing_Zip__c, Shipping_Street1__c, Shipping_Street2__c, Shipping_State__c, Shipping_Phone__c, Shipping_Last_Name__c, Shipping_First_Name__c, Shipping_Country__c, Shipping_City__c, Shipping_Zip__c from API_Request__c where Id = :apiReqId];
            System.debug('apiReqs: ' + apiReqs);
            
            if(apiReqs != null && apiReqs.size() > 0) {
                API_Request__c apiReq = apiReqs[0];   
                
                List<Opportunity> lstOpp = [select Id, Name from Opportunity where Id = :orderId];
                System.debug('lstOpp: ' + lstOpp);
    
                if(lstOpp != null && lstOpp.size() > 0) {
                    Opportunity opp = lstOpp[0];   
                    
                    List<Shipment__c> lstShip = [select Id, Name, Product_Name__c, Scheduled_Date__c, Delivery_Date__c from Shipment__c where Opportunity__c = :orderId order by Delivery_Date__c ASC];
                    System.debug('lstShip: ' + lstShip);
                    
                    if(lstShip != null && lstShip.size() > 0) {
                        Shipment__c ship = lstShip[0];   
                        
                        if(ship.Scheduled_Date__c != NULL && ship.Delivery_Date__c != NULL) {
                            
                            DateTime dt = DateTime.newInstance(ship.Scheduled_Date__c.Year(), ship.Scheduled_Date__c.Month(), ship.Scheduled_Date__c.Day());
                            start_date = dt.format('MM/dd/yyyy');
                            System.debug('start_date:' + start_date);
                            
                            dt = DateTime.newInstance(ship.Delivery_Date__c.Year(), ship.Delivery_Date__c.Month(), ship.Delivery_Date__c.Day());
                            delivery_date = dt.format('MM/dd/yyyy');
                            System.debug('delivery_date:' + delivery_date);
                            
                            String jsonData = '{"type": "transaction","action": "create","data" :{ "id" : "' + safeSetString(apiReq.OrderId__c,NULL) + '","first_name":"' + safeSetString(apiReq.Shipping_First_Name__c,NULL) + '","last_name": "' + safeSetString(apiReq.Shipping_Last_Name__c,NULL) + '","email" : "' + safeSetString(apiReq.Customer_Email__c,NULL) + '", "start_date" : "' + start_date + '","billing_address" :  {"address_1" : "' + safeSetString(apiReq.Billing_Street1__c,NULL) + '","address_2" : "' + safeSetString(apiReq.Billing_Street1__c,NULL) + '","country":"' + safeSetString(apiReq.Billing_Country__c,NULL) + '","state":"' + safeSetString(apiReq.Billing_State__c,NULL) + '","city":"' + safeSetString(apiReq.Billing_City__c,NULL) + '","postal_code":"' + safeSetString(apiReq.Billing_Zip__c,NULL) + '"}, "shipping_address" : {"address_1" : "' + safeSetString(apiReq.Shipping_Street1__c,NULL) + '","address_2" : "' + safeSetString(apiReq.Shipping_Street2__c,NULL) + '","country":"' + safeSetString(apiReq.Shipping_Country__c,NULL) + '","state":"' + safeSetString(apiReq.Shipping_State__c,NULL) + '","city":"' + safeSetString(apiReq.Shipping_Country__c,NULL) + '","postal_code":"' + safeSetString(apiReq.Shipping_Zip__c,NULL) + '"},"product" : "' + safeSetString(ship.Product_Name__c,NULL) + '","address":"","delivery_date":"' + delivery_date + '","mobile":"' + safeSetString(apiReq.Shipping_Phone__c,NULL) + '" }}';
                            System.debug('jsonData: ' + jsonData);
                            
                            Http httpProtocol = new Http();
                            HttpRequest request = new HttpRequest();
                            String endpoint = 'https://app.euphebe.com/api/sync/';
                            system.debug('endpoint:' + endpoint);
                            
                            request.setEndPoint(endpoint);
                            request.setMethod('POST');        
                            
                            request.setHeader('content-type', 'application/json');
                            request.setHeader('authorization', 'Bearer ' + authKey);
                            request.setHeader('companyid', 'euphebe');
                            request.setHeader('cache-control', 'no-cache');
                            
                            request.setBody(jsonData);
                            
                            HttpResponse response;
                            Integer statusCode;
                            
                            if(!Test.isRunningTest()){
                                response = httpProtocol.send(request);
                                system.debug('response:'+ response);
                                statusCode = response.getStatusCode();
                            } else {
                                response = new HttpResponse();
                                statusCode = 200;
                            }
                            system.debug('statusCode:'+ statusCode);
                        }
                    }                
                }            
            }
    	}
    }
        
    @InvocableMethod(label='cariiMethods' description='Operate Carii Class Methods.')
    public static void cariiMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
		String method;
        String param1;
        String param2;
        String param3;
        String param4;
        List<String> ids = inputParams[0];
        
        if(!ids.isEmpty()){
            Integer cnt=0;
            for(String idVal :ids) {
                if(cnt==0)
                    method = idVal;
                else if(cnt==1)
                    param1 = idVal;
                else if(cnt==2)
                    param2 = idVal;
                else if(cnt==3)
                    param3 = idVal;
                else if(cnt==4)
                    param4 = idVal;
				cnt++;
            }
            System.debug('method:' + method);
            System.debug('param1:' + param1);
            System.debug('param2:' + param2);
            System.debug('param3:' + param3);
            System.debug('param4:' + param4);
            
            if(method == 'sendCarriOrder') {
                sendCarriOrder(param1, param2);
            } else if(method == 'addContactToCampaignStep') {
                //addContactToCampaignStep(param1, param2, param3);
            } else if(method == 'sendSalesforceEmail') {
                //sendSalesforceEmail(param1, param2, param3, param4);
            } 
        }
   
    }        
}