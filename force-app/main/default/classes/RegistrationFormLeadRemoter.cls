public class RegistrationFormLeadRemoter {

    @RemoteAction
    public static Response.Detail upsertLead(String jsonLeadString, String formKey){

        try{

            Lead lead = (Lead)JSON.deserialize(jsonLeadString, Lead.class);

            if(formKey == null || formKey == ''){
                throw new Response.ResponseException(
                    'Form Key is missing.', 400,
                    new List<String>{'Form Key is missing.'}
                ); 
            }

            formKey = formKey.toLowerCase();

            List<User> users = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId()];

            if(users.isEmpty()){
                throw new Response.ResponseException(
                    'Invalid user ID.', 404,
                    new List<String>{'Invalid user ID.'}
                );
            }

            User user = users[0];
            Boolean isAuthenticated = false;

            // Implies running under Community User context
            if(user.ContactId != null){
                isAuthenticated = true;
            }

            Response.Detail res = new Response.Detail();
            
            String email = lead.Email;
        
            if(lead.Id != null && email != null){

                List<Contact> contacts = [
                    SELECT Id, Email, RecordType.Name 
                    FROM Contact 
                    WHERE Email = :email AND RecordType.Name = 'Member'
                ];
            
                if(!contacts.isEmpty() && !isAuthenticated){
                                    
                    /**
                    * See if a contact already exists in the system via the
                    * provided email address.
                    **/             
                    
                    throw new Response.ResponseException(
                        'Contact with the email address ' + email + ' already exists.', 205,
                        new List<String>{'Contact with the email address ' + email + ' already exists.'}
                    );

                }
                
                List<Lead> leads = [
                    SELECT Id, Email, IsConverted, ConvertedContactId 
                    FROM Lead 
                    WHERE Id = :lead.Id
                ];
                
                if(!leads.isEmpty() && !leads[0].IsConverted && leads[0].Email != email){

                    /**
                    * If a converted lead is found with the email address
                    * defined, for user to login.
                    */
                    List<Lead> convertedLeads = [
                        SELECT Id, Email, IsConverted, ConvertedContactId 
                        FROM Lead 
                        WHERE Email = :email AND IsConverted = TRUE AND Backup_Exam_Registration__c = FALSE
                    ];                  

                    if(!convertedLeads.isEmpty()){
                        throw new Response.ResponseException(
                            'Contact ' + convertedLeads[0].ConvertedContactId + ' with from converted Lead ' + convertedLeads[0].Id + ' already exists.', 205,
                            new List<String>{'Contact ' + convertedLeads[0].ConvertedContactId + ' with from converted Lead ' + convertedLeads[0].Id + ' already exists.'}
                        );
                    }

                    /**
                    * If the user changes their email address
                    * in the same context and a Lead has already
                    * been created, UPDATE the Lead Email to the 
                    * new revised email address.
                    */                    
                    
                    leads[0].Email = email;
                    
                    UPDATE leads[0];
                    
                    res.data = leads[0];
                    res.status = 204;
                    res.message = 'Unconverted Lead with Id ' + leads[0].Id + ' already exists.  Updated email address of existing Lead to ' + leads[0].Email + '.';

                }else if(!leads.isEmpty() && !leads[0].IsConverted && leads[0].Email == email){

                    res.data = leads[0];
                    res.status = 100;
                    res.message = 'Unconverted Lead with Id ' + leads[0].Id + ' already exists.';

                }else if(!leads.isEmpty() && leads[0].IsConverted){

                    throw new Response.ResponseException(
                        'Contact ' + leads[0].ConvertedContactId + ' with from converted Lead ' + leads[0].Id + ' already exists.', 205,
                        new List<String>{'Contact ' + leads[0].ConvertedContactId + ' with from converted Lead ' + leads[0].Id + ' already exists.'}
                    );

                }

                return res;    

            }else if(email != null){

                List<Contact> contacts = [
                    SELECT Id, Email, RecordType.Name 
                    FROM Contact 
                    WHERE Email = :email AND RecordType.Name = 'Member'
                ];
            
                if(!contacts.isEmpty() && !isAuthenticated){
                                        
                    throw new Response.ResponseException(
                        'Contact with the email address ' + email + ' already exists.', 205,
                        new List<String>{'Contact with the email address ' + email + ' already exists.'}
                    );

                }

                List<Lead> unconvertedLeads = [
                    SELECT Id, Email 
                    FROM Lead 
                    WHERE Email = :email AND IsConverted = FALSE
                ];

                if(!unconvertedLeads.isEmpty()){
                
                    res.data = unconvertedLeads[0];
                    res.status = 200;
                    res.message = 'Unconverted Lead with the email address ' + email + ' already exists.';

                    return res;

                }

                if(unconvertedLeads.isEmpty()){

                    lead = new Lead(
                        Email=email, 
                        LeadSource=formKey,
                        LastName=lead.LastName, 
                        FirstName=lead.FirstName, 
                        Company=lead.LastName + ', ' + lead.FirstName
                    );
                    
                    INSERT lead;
                                                            
                    Form_Data__c formData = new Form_Data__c(
                        Email__c = lead.Email,
                        First_Name__c = lead.FirstName,
                        Last_Name__c = lead.LastName
                    );

                    Utilities.manageFormSubmission(formData, formKey);
                    
                    res.data = lead;
                    res.status = 201;
                    res.message = 'Lead created for ' + email + '.';

                    return res;                      

                }
                                                                    
            }else if(email == null){

                throw new Response.ResponseException(
                    'No email address was provided.', 400,
                    new List<String>{'No email address was provided.'}
                );

            }

            return res;

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{
                e.getMessage(),
                e.getLineNumber(),
                e.getStackTraceString()
            });

        } 

    }

    public RegistrationFormLeadRemoter(sfdcAppRemoter ctrl){}

}