public class ContactTriggerHandler {


    public static void countOnUpdate(List<Contact> conList, Map<Id,Contact> oldRecs){

        Map<Id,List<Contact>> mapAccContacts = new Map<Id,List<Contact>>();
        List<Account> accListToUpdate = new List<Account>();

        Set<Id> accIds = new Set<Id>();

        for(Contact con : conList){            
            if(String.isNotBlank(con.AccountId)){
                accIds.add(con.AccountId);
            }else{

                accIds.add(oldRecs.get(con.Id).AccountId);
            }
        }

        
        for(Contact con :[SELECT Id, AccountId FROM Contact WHERE AccountId IN : accIds]){

            if(!mapAccContacts.containsKey(con.AccountId)){
                mapAccContacts.put(con.AccountId, new List<Contact>());

            }
            mapAccContacts.get(con.AccountId).add(con);


        }
    
        for(Account acc : [SELECT Id, TotalContacts__C FROM Account WHERE ID IN :accIds ]){


            acc.TotalContacts__C  = mapAccContacts.get(acc.Id).size();
            accListToUpdate.add(acc);

        }

        update accListToUpdate;

        
        

            
    }


    public static void UpdateCountOnInsert(List<Contact> conList){
        List<Account> accListToUpdate = new List<Account>();

       
        Set<Id> accIds = new Set<Id>();
        Map<Id,List<Contact>> conMap = new Map<Id,List<Contact>>();

        for(Contact con: conList){

            if(con.AccountId <> null){
                accIds.add(con.AccountId);
            }
        }

        
        for(Contact con  : [SELECT Id, AccountId FROM Contact WHERE AccountId IN : accIds]){

            if(!conMap.containsKey(con.AccountId)){
                conMap.put(con.AccountId, new List<Contact>());

            }
            conMap.get(con.AccountId).add(con);
        }
        System.debug('conmap'+conMap);
        List<Account> accList = [SELECT Id,TotalContacts__c FROM Account WHERE Id IN : accIds];
        for(Account acc: accList){

            acc.TotalContacts__c = conMap.get(acc.Id).size();
            accListToUpdate.add(acc);

        }

        if(!accListToUpdate.isEmpty()){

            update accListToUpdate;
        }
    }
       
        
        



  
    public static void accountUpdateOnDelete(List<Contact> conList){
            List<Account> accList = new List<Account>();
            Set<Id> accIds = new Set<Id>();            
            for(Contact cons : conList){
                accIds.add(cons.AccountId);
            }
            for(Account accs : [SELECT Id, TotalContacts__c, (SELECT Id FROM Contacts) From Account]){
                accs.TotalContacts__c = accs.Contacts.size();
                accList.add(accs);
            }

            
            if(!accList.isEmpty()){
                update accList;
            }
    } 
}