@isTest
public with sharing class TestForGetAccounts{

    
    @isTest       
    public static void getAccountsDataTest(){

      Account acc = new Account(Name='test', Industry='Manufacturings');
        insert acc;
       
        
        list<Account> accList = [SELECT Id, Industry, Phone, Mail__c, Site__c, SLAExpirationDate__c, Website FROM Account WHERE Id =: acc.Id];
        Test.startTest();
        GetAccounts.getAccountsData(acc.Id);
        Test.stopTest();

        system.assertEquals('Manufacturing', accList[0].Industry);
        
    }

}