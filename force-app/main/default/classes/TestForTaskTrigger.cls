@isTest
public with sharing class TestForTaskTrigger {
    @isTest
    public static void testConsTask() {
        Profile pf= [Select Id from profile where Name='System Administrator'];   
        List<Contact> condata = new List<Contact>();
        List<Task> tskdata = new List<Task>();
        List<Task> consTask = new List<Task>();
        User u1=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'cenation1011' + '@test' + 'asd10101sd' + '.org', 
                         Username = 'habel009' + '@test' + 'adsd1010xxsd' + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'jyothi00',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id); 
        insert u1;
        
        User u2 = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'saipraneeth1011' + '@test' + 'asd10101sd' + '.org', 
                           Username = 'giyan009' + '@test' + 'adsd1010xxsd' + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = 'pra00',
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id);    
        insert u2;
        
        
        System.runAs(u1) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('Current id   '+UserInfo.getUserId());
            System.debug('Owner id   '+u1.Id);
            
        }
        System.runAs(u2) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('Current id   '+UserInfo.getUserId());
            System.debug(' u2 Owner id   '+u2.Id);
            
        }
        List<Account> accs = new List<Account>();
        Account testAccount = new Account(Name = 'imtesting');
        accs.add(testAccount);
        insert accs;
        Account  a = [select Id  from Account where Name = 'imtesting'];
        Contact testCon = new Contact(LastName = 'prasanna',Email = 'wifi@rg.in',AccountId = a.Id, OwnerId = u1.Id);
        condata.add(testCon);
        insert condata;
        Contact c = [select Id,LastName,Email from Contact LIMIT 1];
        Task testTask  = new Task (Subject = 'Title',Description = 'this is the desc',WhoId = c.Id);
        insert testTask;
        Test.startTest();
        User us = [select Id  from User where Alias = 'pra00' LIMIT 1];
        Contact queryCon = [select OwnerId,LastName,Email from Contact LIMIT 1];
        queryCon.OwnerId = us.Id;
        update queryCon;
        
        Test.stopTest();
    }
   
}