public  class ContactTriggerHandler {
    public void UpdateCountOnInsert(List<Contact> conList){
    Set<Id> accIds = new Set<Id>();    
    for(Contact con : conList){         
        if(con.AccountId!= null){                
            accIds.add(con.AccountId);
        }else{
                
                
        } 
    }
    List<Account> AccList = [SELECT Id, TotalContacts__c, (Select Id from Contacts) From Account WHERE Id IN : accIds];
    System.debug('accList'+AccList);

    for(Account acc : AccList){

        acc.TotalContacts__c = acc.Contacts.size();
    }
        update AccList;
    }


}