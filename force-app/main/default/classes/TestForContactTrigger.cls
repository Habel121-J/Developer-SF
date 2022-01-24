@isTest(SeeAllData = false)
public with sharing class TestForContactTrigger
{
    public TestForContactTrigger()
    {
    }
    //Test method is used to test the trigger
    @isTest
    public static void checkContacts()
    {
        Contact contact = new Contact();
        contact.firstname = 'habel';
        contact.lastname = 'prasanna';
        insert contact;
        list<Account> acc = [SELECT id, count__c FROM Account];
        //Used to compare the expected value and Actual Value
        try{
            system.assertEquals(1, acc[0].count__c);
        }catch(ListException e){
            System.debug('List exception fired');        
        }
    }
}