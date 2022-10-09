public class BackupExamRegistrationHelper {
    
    public static void disableManualRollback(){
        //ExamRegistrationFormRemoter.disableManualRollback = TRUE;
    }
    
    public static void disableCreditCardProcessing(){
        //ExamRegistrationFormRemoter.disableCreditCardProcessing = TRUE;
    }
    
    public static void disableCaptcha(){
        Utilities.disableCaptcha = true;
    }
    
    public static User checkForExistingUser(String email){
        
        List<User> users = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Contact.Email = :email AND Contact.RecordType.Name = 'Member'
        ];
        
        if(!users.isEmpty()){
            return users[0];
        }else{
            return null;
        }
        
    }
    
    public static Lead mapMongoDbExamRegistrationToLead(Id batchId, MongoDbExamRegistration mongoDbExamRegistration){
        
        Lead lead = new Lead();
        
        lead.Backup_Exam_Registration_Batch_ID__c = batchId;
        lead.Backup_Exam_Registration__c = TRUE;
        lead.Backup_Exam_Registration_MongoDB_OID__c = mongoDbExamRegistration.id.oid;
        lead.Backup_Exam_Registration_MongoDB_JSON__c = JSON.serializePretty(mongoDbExamRegistration);
        lead.Company = mongoDbExamRegistration.company;
        lead.FirstName = mongoDbExamRegistration.fname;
        lead.LastName = mongoDbExamRegistration.lname;
        lead.Email = mongoDbExamRegistration.email;
        lead.Phone = mongoDbExamRegistration.phone;
        lead.ID_Type__c = mongoDbExamRegistration.idtype;
        lead.ID_Number__c = mongoDbExamRegistration.idnum;
        lead.Full_Name_in_Chinese__c  = mongoDbExamRegistration.chinesename;
        lead.Name_as_it_Appears_on_ID__c = mongoDbExamRegistration.fname + mongoDbExamRegistration.lname;
        lead.Billing_Address_1__c = mongoDbExamRegistration.billaddr1;
        lead.Billing_Address_2__c = mongoDbExamRegistration.billaddr2;
        lead.Billing_Address_3__c = mongoDbExamRegistration.billaddr3;
        lead.Billing_City__c = mongoDbExamRegistration.billcity;
        lead.Billing_State__c = mongoDbExamRegistration.state;
        lead.Billing_Company__c = mongoDbExamRegistration.billcompany;
        lead.Billing_Phone_Number__c = mongoDbExamRegistration.billphone;
        lead.Billing_Country__c =  mongoDbExamRegistration.billcountry;
        lead.Billing_Postal_Code__c = mongoDbExamRegistration.billzip;
        lead.Shipping_Address_1__c = mongoDbExamRegistration.billaddr1;
        lead.Shipping_Address_2__c = mongoDbExamRegistration.billaddr2;
        lead.Shipping_Address_3__c = mongoDbExamRegistration.billaddr3;
        lead.Shipping_City__c = mongoDbExamRegistration.billcity;
        lead.Shipping_State__c = mongoDbExamRegistration.state;
        lead.Shipping_Company__c = mongoDbExamRegistration.billcompany;
        lead.Shipping_Phone_Number__c = mongoDbExamRegistration.billphone;
        lead.Shipping_Country__c =  mongoDbExamRegistration.billcountry;
        lead.Shipping_Postal_Code__c = mongoDbExamRegistration.billzip;
        lead.Shipping_Address_Same_as_Billing_Address__c = TRUE;
        
        String paymentType = mongoDbExamRegistration.payment;
        
        if(paymentType == 'cc'){
            lead.Payment_Type__c = 'Credit Card';
        }else if(paymentType == 'wire'){
            lead.Payment_Type__c = 'Wire Transfer';
        }else if(paymentType == 'check'){
            lead.Payment_Type__c = 'Check';
        }
        
        return lead;
        
    }
    
    public static void createExamRegistration(Id batchId, MongoDbExamRegistration mongoDbExamRegistration){
        
        disableCaptcha();
        disableManualRollback();
        disableCreditCardProcessing();
        
        String examType = mongoDbExamRegistration.regType.toUpperCase();
        
        User user = checkForExistingUser(mongoDbExamRegistration.email);
        
        //ExamRegistrationFormHelper.runAsUser = user;
        
        Lead lead = mapMongoDbExamRegistrationToLead(batchId, mongoDbExamRegistration);
        
        ExamRegistration.Site selectedSite = new ExamRegistration.Site();
        
        //Map<String, ExamRegistration.Site> availableSites = ExamRegistrationFormHelper.createMap(
            //ExamRegistrationFormHelper.getExamSites()
        //); 
        
        //for(ExamRegistration.Site site: availableSites.values()){
        //    if(site.label == mongoDbExamRegistration.examsite){
        //        selectedSite = site;
        //        break;
        //    }
        //}
        
        ExamRegistration.Exam selectedExam = null;
        
        Map<String, ExamRegistration.Exam> availableExams = null;
        if(user != null){
            //availableExams = ExamRegistrationFormHelper.createMap(
                //ExamRegistrationFormHelper.getAvailableExamsAuthenticated(examType, user)
            //); 
        }else{
            //availableExams = ExamRegistrationFormHelper.createMap(
                //ExamRegistrationFormHelper.getAvailableExamsPublic(examType)
            //); 
        }
        
        if(availableExams == null){
            //lead.Backup_Exam_Registration_Import_Failed__c = true;
			//lead.Backup_Exam_Registration_Logging__c = 'No available exams for user (' + user.Id + ').';
            //UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            return;      
        }

        for(ExamRegistration.Exam exam: availableExams.values()){
            if(mongoDbExamRegistration.exam == 'FRM Exam Part I and FRM Exam Part II'){
                if(exam.label.contains('FRM Exam Part I') && exam.label.contains('FRM Exam Part II') && exam.label.contains('and')){
                    selectedExam = exam;
                    break;
                }                
            }else if(mongoDbExamRegistration.exam == 'FRM Exam Part II'){
                if(exam.label.contains('FRM Exam Part II')){
                    selectedExam = exam;
                    break; 
                }
            }else if(mongoDbExamRegistration.exam == 'FRM Exam Part I'){
                if(exam.label.contains('FRM Exam Part I') && !exam.label.contains('FRM Exam Part II')){
                    selectedExam = exam;
                    break;
                }  
            }else if(mongoDbExamRegistration.exam == 'ERP Exam Part I and ERP Exam Part II'){
                if(exam.label.contains('ERP Exam Part I') && exam.label.contains('ERP Exam Part II') && exam.label.contains('and')){
                    selectedExam = exam;
                    break;
                }                
            }else if(mongoDbExamRegistration.exam == 'ERP Exam Part II'){
                if(exam.label.contains('ERP Exam Part II')){
                    selectedExam = exam;
                    break;
                }
            }else if(mongoDbExamRegistration.exam == 'ERP Exam Part I'){
                if(exam.label.contains('ERP Exam Part I') && !exam.label.contains('ERP Exam Part II')){
                    selectedExam = exam;
                    break;
                }  
            } 
        }        
        
        if(selectedExam == null){
            lead.Backup_Exam_Registration_Import_Failed__c = true;
			lead.Backup_Exam_Registration_Logging__c = 'User (' + user.Id + ') is ineligible to take this exam (' + mongoDbExamRegistration.exam + ').';
            UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            return;      
        }
                
        try{
        
            UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            
            String token = Utilities.getFormSessionToken();
            
            //ExamRegistrationFormRemoter.RegistrationRequest registrationRequest = new ExamRegistrationFormRemoter.RegistrationRequest();
            
            //registrationRequest.token = token;
            //registrationRequest.lead = lead;
            //registrationRequest.exam = selectedExam;
            //registrationRequest.site = selectedSite;
            //registrationRequest.registrationType = examType;
            //registrationRequest.products = new Map<String, ExamRegistration.Item>();
                                           
            //Response.Detail res = ExamRegistrationFormRemoter.createExamRegistrationOrder(JSON.serialize(registrationRequest)); 
            
            //if(res.status != 200){
            //    lead.Backup_Exam_Registration_Import_Failed__c = true;
            //    lead.Backup_Exam_Registration_Logging__c = JSON.serialize(res);
            //    UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            //    return;
            //}
            
            //ExamRegistrationFormRemoter.RegistrationResponse registrationResponse = (ExamRegistrationFormRemoter.RegistrationResponse)res.data;
            
            //if(registrationResponse.opportunity.Amount != Decimal.valueOf(mongoDbExamRegistration.totalCost)){
            //    lead.Backup_Exam_Registration_Import_Failed__c = true;
            //    lead.Backup_Exam_Registration_Logging__c = 'The total cost of the order placed, versus the order generated are different.';
            //    UPDATE lead;
            //    return;
            //}
            
            //ExamRegistrationFormRemoter.ChargeRequest chargeRequest = new ExamRegistrationFormRemoter.ChargeRequest();
            
            //chargeRequest.token = token;
            //chargeRequest.lead = registrationResponse.lead;
            //chargeRequest.exam = selectedExam;
            //chargeRequest.site = selectedSite;
            //chargeRequest.card = null;
            //chargeRequest.registrationType = examType;
            
            //res = ExamRegistrationFormRemoter.payExamRegistrationOrder(JSON.serialize(chargeRequest));
            
            //if(res.status != 200){
            //    lead.Backup_Exam_Registration_Import_Failed__c = true;
            //    lead.Backup_Exam_Registration_Logging__c = JSON.serialize(res);
            //    UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            //    return;
            //}
            
            //ExamRegistrationFormRemoter.ChargeResponse chargeResponse = (ExamRegistrationFormRemoter.ChargeResponse)res.data;                                                   
            
            if(lead.Payment_Type__c == 'Credit Card'){
                
                ChargentSFA__Transaction__c  trans = new ChargentSFA__Transaction__c();
                
                trans.ChargentSFA__Type__c = 'Charge';
                trans.ChargentSFA__Amount__c = Decimal.valueOf(mongoDbExamRegistration.totalCost);
                trans.ChargentSFA__Response__c = mongoDbExamRegistration.RESPMSG;
                trans.ChargentSFA__Response_Status__c = mongoDbExamRegistration.RESULT;
                trans.ChargentSFA__Gateway_ID__c = mongoDbExamRegistration.PNREF;
                trans.ChargentSFA__Payment_Method__c = 'Credit Card';
                trans.ChargentSFA__Credit_Card_Type__c = 'TODO';
                //trans.ChargentSFA__Opportunity__c = registrationResponse.opportunity.Id;
                
                INSERT trans;
                
                //Opportunity opportunity = registrationResponse.opportunity;
                
                //opportunity.StageName = 'Closed';
                
               // UPDATE opportunity;
                
            }
            
        }catch(Exception e){

            lead.Backup_Exam_Registration_Import_Failed__c = true;
			lead.Backup_Exam_Registration_Logging__c += '\n' + e.getStackTraceString();
            UPSERT lead Backup_Exam_Registration_MongoDB_OID__c;
            
        }
        
    }
    
}