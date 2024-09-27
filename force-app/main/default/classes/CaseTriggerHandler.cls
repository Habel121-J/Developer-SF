public class CaseTriggerHandler {



public static void updateAccount(List<Case> recList){

    Map<Id,Case> accMap = new Map<Id, Case>();

    for(Case cs : recList){

        if(String.isNotBlank(cs.AccountId)){

            accMap.put(cs.AccountId, cs);
        }
    }

    List<Account> accList = [SELECT Id, Name FROM Account WHERE Id IN : accMap.keySet()];


    for(Account acc : accList){

        acc.Description = accMap.get(acc.Id).CaseNumber;
    }

    if(!accList.isEmpty()){

        update accList;
    }

}

public static void updateContactOnCase(List<Case> csList) {

    Set<Id> accIds = new Set<Id>();
    Map<Id, Contact> mapAccContacts = new Map<Id,Contact>();

    for(Case cs : csList){

        if(String.isNotBlank(cs.AccountId)){


            accIds.add(cs.AccountId);
        }
    }
    List<Contact> conList = [SELECT Id,AccountId FROM Contact WHERE AccountId IN : accIds ORDER BY CreatedDate DESC LIMIT 1];
    
    if(!conList.isEmpty()){

        for(Contact con : conList){
        
        mapAccContacts.put(con.AccountId, con);
    
        }
        
    }
   

    for(Case cs : csList){
       
        cs.ContactId = mapAccContacts.get(cs.AccountId) <> null ? mapAccContacts.get(cs.AccountId).Id : null;
    }


}

}