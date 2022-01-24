/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2022-01-13
* @modified         2022-01-17
* @systemLayer      Apex Class
*/

//@description Whenever Lead with Email,Phone matches with Account's Email,Phone Account name should be updated with Lead Name 
public with sharing class HandlerLeadController {
    
    public static void isAfterInsert(List<Lead> leadList)
    {
      afterInsertLead(leadList);
    }
    public static void afterInsertLead(List<Lead> leadList)
    {
      Boolean isExists = true;  
      List<Account> accList = new List<Account>();
      Set<String> phone = new Set<String>();
      Set<String> email = new Set<String>();
      Map<String, Lead> mapObj = new Map<String, Lead>();
      Map<String, Account> mapMatchData = new Map<String, Account>();
     
        for(Lead lds : leadList)
        {
            phone.add(lds.Phone);
            email.add(lds.Email);
            mapObj.put(lds.Phone+';'+lds.Email,lds);
        }
        for(Account acs: [select Id,name, phone,Email__c from Account where Phone IN : phone AND Email__c IN : email])
        {
           acs.Name = mapObj.get(acs.Phone+';'+acs.Email__c).LastName;
            accList.add(acs);
            mapMatchData.put(acs.Phone+';'+acs.Email__c,acs);
        }
        if(!accList.isEmpty())
        {
            Update accList;
        }
         if(isExists)
        {
            List<Account> newAccList = new List<Account>();
            for(Lead ldsList : leadList)
            {
                System.debug('listofleads '+ldsList);
                if(!mapMatchData.containsKey(ldsList.Phone+';'+ldsList.Email))
                {
                   System.debug('Inside if phone'+ldsList.Phone);
                   System.debug('Inside if email'+ldsList.Email);
                   Account newAcc = new Account();
                   newAcc.Name = ldsList.LastName;
                   newAcc.Phone = ldsList.Phone;
                   newAcc.Email__c = ldsList.Email;
                   newAccList.add(newAcc);
                }
            }
            insert newAccList;
        }
    }
}