/*@author           Prasanna Kumar        <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy   Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version        1.0
* @created        2021-11-30
* @modified      
* @systemLayer    Batch Apex Class
*/

//@description  batch Apex class for updataing the contact field with current date
public class ApexBatchUpdateDate implements Database.Batchable<Sobject> {

// collect the batches of records or objects to be passed to execute
public Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'SELECT Id, Name, Selected_Date__c FROM Contact';
    return Database.getQueryLocator(query);
}
/* @description ---> updating contact field with current date
    * @param  List contacts
    */
public void execute(Database.BatchableContext bc, List<Contact> conList){
        for(Contact con : conList){
        con.Selected_Date__c = system.today();
            // system.debug(con.Selected_Date__c);
            
        
    }
    
    update conList;
}

public void finish(Database.BatchableContext BC){
    
    System.debug('Contacts are Updated');
}
}