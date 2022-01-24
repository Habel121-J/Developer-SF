@isTest
public with sharing class TestForHandlerLeadController {
    @isTest
    public static void  testLeadExisting(){
        
        List<Lead> lds = new List<Lead>();
        List<Account> accList = new  List<Account>();
        
        lds.add(new Lead(LastName = 'testprasanna',Company = 'IND',Phone ='9502320713',Email = 'test@ceo.in'));
            Account accs = new Account();
            accs.Name= 'kumar';
            accs.Phone = '9502320713';
            accs.Email__c = 'test@ceo.in';
            insert accs;
        
           Test.startTest();
        
           insert lds;
           HandlerLeadController.isAfterInsert(lds);	
           Test.stopTest();
    }
    @isTest
    public static void  testLeadNew(){
        
        List<Lead> lds = new List<Lead>();
        List<Account> accList = new  List<Account>();
        
        lds.add(new Lead(LastName = 'testprasanna',Company = 'IND',Phone ='9502320713',Email = 'test@ceo.in'));
            Account accs = new Account();
            accs.Name= 'kumar';
            accs.Phone = '0000000';
            accs.Email__c = 'hi@testing.in';
            insert accs;
        
         Test.startTest();
        
        insert lds;
        HandlerLeadController.isAfterInsert(lds);	
        Test.stopTest();
    }
}