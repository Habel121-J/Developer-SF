@isTest
public with sharing class TestForHandler_ConTrigger {
    @isTest
    public static void testCons() {
        List<Contact> testConData = new List<Contact>();
        List<Email__c> testEmailData = new List<Email__c>(); 
        Email__c emsmail = new Email__c();
        testEmailData.add(new Email__c(Email__c = 'im@ceo.in',Active__c= true));
        Contact c = new Contact(LastName='prasanna',CampusEmail__c='im@ceo.in',AlternativeEmail__c = 'pepsico@india.com',OtherEmail__c = 'dattu@ceo.in');
        testConData.add(c);
        Test.startTest();
        insert testConData;
        insert testEmailData;
        Handler_ConTrigger.isAfterInsert(testConData);
        Handler_ConTrigger.isAfterInsertCon(testConData);
        Handler_ConTrigger.isNewChanged('data',c);
        Test.stopTest();
    }
}