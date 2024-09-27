public class TriggerHandlerContact {
    
    public static void handleNeworUpdate(List<Contact> newList,Map<Id, Contact> newMap){
        
        Map<Id, List<Contact>> mapCons = new Map<Id,List<Contact>>();
        List<Account> accList = [SELECT Id,Name, (SELECT Id, AccountId FROM Contacts WHERE AccountId IN :newMap.keySet()) FROM Account];   
        
        for(Account acc : accList){                
            mapCons.put(acc.Id, new List<Contact>());
            if(!mapCons.containsKey(acc.Id)){
                mapCons.get(acc.Id).add(acc.Contacts);
            }

        }
        
    }
}