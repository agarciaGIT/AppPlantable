public class batchSetCompanyAccountAssocUtil {

    public static void updateInsertContactCompanyAccount(Set<Id> contactIds, Account noMatchAcct){
        Map<String, Account> accountNamePermutationsMap = new Map<String, Account>();
        ID busRecId = RecordTypeHelper.GetRecordTypeId('Account','Business');
        ID indvRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        for(Account account :[
            SELECT 
            Id, Name, Alt_Company_Name__c, Clean_Company_Name__c 
            FROM 
            Account 
            WHERE 
           	RecordTypeID != :indvRecId and KPI_Employee_Dont_Use__c = False
        ]) {
            if(account.Alt_Company_Name__c != null){
                for(String permutation: account.Alt_Company_Name__c.split('[\n\r]')){
                    accountNamePermutationsMap.put(permutation, account);//use cleaned alt company names as key to reduce the number of alt account name permutations
                }
            }
            accountNamePermutationsMap.put(account.Clean_Company_Name__c, account);
        }
        
        List<Contact> toUpdate = new List<Contact>();
        for(Contact c: [SELECT Id, Name, Company__c, Company_Clean_Name__c, Company_Account__c FROM Contact WHERE Id IN :contactIds]){
            if(accountNamePermutationsMap.containsKey(c.Company_Clean_Name__c)){
                c.Company_Account__c = accountNamePermutationsMap.get(c.Company_Clean_Name__c).Id;
            } else if(noMatchAcct != null) {
                c.Company_Account__c = noMatchAcct.Id;
            }
            c.Company_Association_Processed__c = true;
            toUpdate.add(c);
        }
        
        if(!toUpdate.isEmpty()){
            UPDATE toUpdate;
        }        
    }
    
}