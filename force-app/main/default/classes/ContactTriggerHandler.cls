public with sharing class ContactTriggerHandler
{
    public ContactTriggerHandler()
    {
    }
    public static void countContacts(List<contact> con)
    {
            //It is used to get all the accounts
            List<Account> account = new List<Account>();
            //It is used to store all the id's
            List<id> contactid = new List<id>();
            //While we creating New Contact isInsert trigger is used
            if(trigger.isInsert)
            {
                for(Contact contact : con)
                {
                    //Assign the id to the new contact
                    contactid.add(contact.accountId);
                }
            }
            //While we Deleting the Contact isDelete trigger is used
            if(trigger.isDelete)
            {
                for(Contact contact : con)
                {
                    contactid.add(contact.accountId);
                }
            }
            //It is used to get all the details about the account related contacts
            List<account>  account1 = [SELECT id, count__c, (SELECT id FROM Contacts)
                                       FROM Account
                                       WHERE id in :contactid];
            //It is used to Update the Number of Contacts field in Account
            for(Account ac : account1)
            {
                ac.count__c = ac.Contacts.size();
                account.add(ac);
            }
            update account;
    }
}