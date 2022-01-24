/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-11-30
* @modified      
* @systemLayer     Apex Class
*/

//@description   Apex class which returns list of records from account based on id
public with sharing class GetAccounts {
    
    /* @description ---> collecting the data from Accounts based on id
     * @param  String accId
     * @return List<Account> getACcounts
    */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsData(String accId) {
    return [SELECT Id, Industry, Phone, Mail__c, Site__c, SLAExpirationDate__c, Website FROM Account WHERE ID  = : accId];
    
    }

}