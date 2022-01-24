/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-12-06
* @modified      
* @systemLayer     Apex Class
*/

//@description   Apex class which returns list of records from contact based on id
public with sharing class FetchContacts {
    
    /* @description ---> fetching Account related contacts based on id
     * @param  Id accId
     * @return List<Contact> getACcounts
    */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsData(String accId) {
    return [SELECT Id, Name, Phone, Email, Department  
                FROM Contact 
                WHERE AccountId  = : accId];
        }
    @AuraEnabled
    public static void updateCons(List<Contact> upcon){
    List<Contact> data = upcon;
    upsert data;
   

    }


}