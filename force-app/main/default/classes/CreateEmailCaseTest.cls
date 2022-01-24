    @isTest
    public with sharing class CreateEmailCaseTest {
        @isTest
        public CreateEmailCaseTest() {
            Messaging.inboundEmail testmail;
            Messaging.InboundEnvelope testmailevnlop;
            Test.startTest();
            CreateEmailCase.handleInboundEmail(testmail,testmailevnlop)
            Test.stopTest();
        }
    }