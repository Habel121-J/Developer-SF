public class AccountBatchApex implements Database.Batchable<sObject>,Database.Stateful  {
    public Set<Id> AccIds;
    
    public AccountBatchApex(Set<Id> accId){
        
	this.AccIds =         accId;
      //  System.debug('----.')
        
    }
 
    public Database.QueryLocator start(Database.BatchableContext BC){
 	 	return Database.getQueryLocator([SELECT Id,Name FROM Account]);
       
         }
    
    public void execute(Database.BatchableContext BC, List<sObject> accList){
        System.debug('accList-----'+accList);
        
        
    }
    public void finish(Database.BatchableContext BC){
     System.debug('***Batch Finished***');
  }

}