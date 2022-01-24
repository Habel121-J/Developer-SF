public with sharing class PaginationController {
@AuraEnabled(cacheable=true)
    public static List<Listing__c> getListing(){

        return [SELECT Id,Name,State2__c,Country__c,City__c,Status__c FROM Listing__c];
    }


}
