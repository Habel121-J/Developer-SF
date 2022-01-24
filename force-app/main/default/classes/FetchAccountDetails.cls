/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-11-30
* @modified      
* @systemLayer     Apex Class
*/

//@description   Apex class which returns list of records from account based on id
public with sharing class FetchAccountDetails {
    
    /* @description ---> collecting the data from Accounts based on id
     * @param  String accId
     * @return List<Account> getACcounts
    */
    @AuraEnabled
    public static List<Account> fetchAccount(String accId) {
      System.debug('from inside acc');
    List<Account> acc =  [SELECT Id, Industry, Phone,Website, Mail__c, Site__c, SLAExpirationDate__c FROM Account WHERE ID  = : accId];
    system.debug('acc '+acc);
    return acc;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> fetchAccountRelatedContact(String acId) {
        List<Contact> con =  [SELECT LastName,AccountId, Title, Phone,Department FROM Contact WHERE AccountId  = : acId];
        System.debug('condata '+con);
          return con;
        }

}
