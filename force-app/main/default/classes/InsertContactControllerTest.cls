@isTest
public with sharing class InsertContactControllerTest{
      
    
    @isTest  static void runTest(){
        Test.startTest();
        Contact cont = new Contact();
        cont.LastName='habel';
        cont.Email = 'habelprasanna5@gmail.com';
        cont.MobilePhone = '9502320713';
        
        InsertContactController.insertConData(cont);
        Test.stopTest();
        Contact con = [SELECT LastName,Email from Contact];
        
    }
    System.assertEquals('habel',con.LastName);
    
    
    
    
    
}