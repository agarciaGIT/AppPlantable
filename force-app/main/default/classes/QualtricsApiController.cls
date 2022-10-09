public class QualtricsApiController {

    @RemoteAction
    public static Response.Detail getQualtricsDistributionLink(Id studyAccountId){

        try{

            Response.Detail res = new Response.Detail();

            List<Study_Account__c> studyAccounts = [
                SELECT
                Id, 
                Qualtrics_Mailing_List_ID__c, 
                Qualtrics_Contact_ID__c,
                Qualtrics_Survey_Integration_Status__c,
                Qualtrics_Last_Distribution_ID__c,
                Qualtrics_Last_Distribution_Link__c,
                Qualtrics_Last_Distribution_Link_Expiry__c,
                Study__r.Qualtrics_Survey_ID__c, 
                Study__r.Qualtrics_Survey_Sync_Study__c,
                Study__r.Qualtrics_Survey_Integration_Status__c
                FROM Study_Account__c
                WHERE Id = :studyAccountId
            ];

            if(studyAccounts.isEmpty()){
                throw new Response.ResponseException(null, 404, new List<String>{'Invalid Study Account ID.'});
            }

            FINAL Study_Account__c studyAccount = studyAccounts[0]; 
            FINAL Id studyId = studyAccount.Study__r.Id;
            FINAL String directoryId = Label.Qualtrics_Directory_ID;
            FINAL String surveyId = studyAccount.Study__r.Qualtrics_Survey_ID__c;

            if(studyAccount.Study__r.Qualtrics_Survey_Integration_Status__c != 'Enabled'){
                throw new Response.ResponseException('This survey has been disabled.', 403, new List<String>{'This survey has been disabled.'});
            }

            if(studyAccount.Qualtrics_Survey_Integration_Status__c != 'Enabled'){
                throw new Response.ResponseException('Your organization is not a participant in this survey.', 403, new List<String>{'Your organization is not a participant in this survey.'});
            }

            if(studyAccount.Qualtrics_Mailing_List_ID__c == null){
                throw new Response.ResponseException('The Qualtrics_Mailing_List_ID__c is not set.', 400, new List<String>{'The Qualtrics_Mailing_List_ID__c is not set.'});
            }
            
            if(studyAccount.Qualtrics_Last_Distribution_Link__c != null){

                res.message = 'Existing Qualtrics temporary access link found.';

                QualtricsApiService.QualtricsElement qualtricsElement = new QualtricsApiService.QualtricsElement();

                qualtricsElement.link = studyAccount.Qualtrics_Last_Distribution_Link__c;
                qualtricsElement.linkExpiration = studyAccount.Qualtrics_Last_Distribution_Link_Expiry__c;

                res.data = qualtricsElement;
                res.status = 200;
                return res;

            }

            String qualtricsDistributionId = null;

            if(studyAccount.Qualtrics_Mailing_List_ID__c != null){

                QualtricsApiService.response generateDistributionLinksResponse = QualtricsApiService.generateDistributionLinks(
                    surveyId, 
                    studyAccount.Qualtrics_Mailing_List_ID__c,
                    studyId,
                    studyAccountId
                );

                if(generateDistributionLinksResponse.meta == null || generateDistributionLinksResponse.meta.httpStatus != '200 - OK'){
                    throw new Response.ResponseException(null, 400, new List<String>{JSON.serializePretty(generateDistributionLinksResponse)});
                }

                qualtricsDistributionId = generateDistributionLinksResponse.result.id;
                
            }

            QualtricsApiService.response getDistributionLinksResponse = QualtricsApiService.getDistributionLinks(
                surveyId, 
                qualtricsDistributionId, 
                studyId, 
                studyAccountId
            );

            if(getDistributionLinksResponse.meta == null || getDistributionLinksResponse.meta.httpStatus != '200 - OK'){
                throw new Response.ResponseException(null, 400, new List<String>{JSON.serializePretty(getDistributionLinksResponse)});
            }

            studyAccount.Qualtrics_Last_Distribution_ID__c = qualtricsDistributionId;
            studyAccount.Qualtrics_Last_Distribution_Link__c = (String)getDistributionLinksResponse.result.elements[0].link;
            studyAccount.Qualtrics_Last_Distribution_Link_Expiry__c = (String)getDistributionLinksResponse.result.elements[0].linkExpiration;

            UPDATE studyAccount;

            // Remove properties from response
            getDistributionLinksResponse.result.elements[0].contactId = null;
            getDistributionLinksResponse.result.elements[0].externalDataReference = null;

            res.message = 'Qualtrics temporary access link created successfully.';
            res.data = getDistributionLinksResponse.result.elements[0];
            res.status = 200;
            return res;

        }catch(Response.ResponseException e){
            return new Response.Detail(e.getMessage(), e.status, e.errors);
        }catch(Exception e){
            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});
        }

    }

    public QualtricsApiController(graAppRemoter ctrl) {}

}