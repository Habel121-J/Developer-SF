/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-12-06
* @modified      
* @systemLayer     Apex Class
*/

//@description to insert records In Listing Custom Object
public with sharing class SaveListingRecords {
    
    @AuraEnabled
    public static void  SaveListing(Listing__c Details) { 
        List<Listing__c> listrecords = new List<Listing__c>();
        listrecords.add(Details);
        Insert listrecords;


    }
}
