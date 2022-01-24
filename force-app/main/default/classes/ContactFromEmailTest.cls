@isTest
public with sharing class ContactFromEmailTest {
    @isTest
    public static void CreateContactFromEmailServices() {
        Messaging.inboundEmail testmail;
        Messaging.InboundEnvelope testmailevnlop;
        Test.startTest();
        CreateContactFromEmailServices.handleInboundEmail(testmail,testmailevnlop);
        Test.stopTest();
    }
}