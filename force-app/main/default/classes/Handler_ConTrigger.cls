/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-12-31
* @modified      
* @systemLayer      Apex Class
*/

//@description to Update Custom Email Object field when a contact is created or inserted

public  class Handler_ConTrigger {

    public static String camp = System.Label.Campus;
    public static String alter = System.Label.Alter;
    public static String other = System.Label.Other;

    public static void isAfterUpdate(List<Contact> conList){

    isAfterUpdateCon(conList);

    }

    public static void isAfterInsert(List<Contact> conList)
    {

        isAfterInsertCon(conList);
        
    }
 
    public static boolean isNewChanged(string fieldAPiName, SObject conObj){

        SObject newRecords =  Trigger.NewMap != null ? Trigger.NewMap.get(conObj.ID) : null;
        System.debug('New Records'+newRecords);
        System.debug('field name ');
        if(newRecords.get(fieldAPiName)!=null)
        {
            return true;
        }
        return false;
    }

    public static void  isAfterInsertCon(List<Contact> conList) {

        List<Email__c> Insertmail = new List<Email__c>();
        //Email__c newEmail =new Email__c();
        System.debug('from insert');
        
        for(Contact conObj : conList )
        {
            System.debug('from inside for loop');
         
           
            
            if(isNewChanged('CampusEmail__c',conObj))
            {
                Email__c insEmail = new Email__c();                   
                System.debug('inside campus conOBJ '+conObj);
                System.debug('conObj  '+conObj.CampusEmail__c);
                insEmail.Email__c  = conObj.CampusEmail__c;
                insEmail.Emai_Type__c = camp;
                insEmail.Active__c = true;
                insEmail.ContactId__c= conObj.Id; 
                Insertmail.add(insEmail);
             
            }
            if(isNewChanged('AlternativeEmail__c',conObj))
            {
                System.debug('inside alternative ');
                Email__c insEmail = new Email__c();
                insEmail.Email__c  = conObj.AlternativeEmail__c;
                insEmail.Emai_Type__c = alter;
                insEmail.Active__c = true;
                insEmail.ContactId__c= conObj.Id;
                Insertmail.add(insEmail);
              
            }
            if(isNewChanged('OtherEmail__c',conObj))
            {
                System.debug('inside other ');
                Email__c insEmail = new Email__c();
                insEmail.Email__c  = conObj.OtherEmail__c;
                insEmail.Emai_Type__c = other;
                insEmail.Active__c = true;
                insEmail.ContactId__c= conObj.Id;
                Insertmail.add(insEmail);
               
            }   
            //Insertmail.add(insEmail);
        
        }
        Insert Insertmail;
    }

    public static boolean isExistingChanged(string fieldAPiName, SObject conObj){

        SObject oldRecords =  Trigger.oldMap != null ? Trigger.oldMap.get(conObj.ID) : null;

        System.debug('old records'+oldRecords);

        if(oldRecords.get(fieldAPiName)!= conObj.get(fieldAPiName))
        {
            return true;
        }
        return false;
    }

    public static void isAfterUpdateCon(List<Contact> conList)
    {
        List<Email__c> ems = [SELECT id,ContactId__c, Emai_Type__c, Email__c from Email__c where  Active__c = true];
        //Map<Id, List<Email__c>> mapOfConIdEmail = new Map<Id, List<Email__c>>();
        List<Email__c> mail = new List<Email__c>();
        for(Contact conObj : conList)
        {  
          
            if(isExistingChanged('CampusEmail__c',conObj))
            {
                Email__c newEmail = new Email__c();   
                System.debug('inside campus ');
                System.debug('conObj  '+conObj.CampusEmail__c);
                newEmail.Email__c  = conObj.CampusEmail__c;
                newEmail.Active__c = true;
                newEmail.Emai_Type__c = camp;
                newEmail.ContactId__c = conObj.Id;
                mail.add(newEmail);
            }
            if(isExistingChanged('AlternativeEmail__c',conObj))
            {
                Email__c newEmail = new Email__c();
                System.debug('inside alternative ');
                newEmail.Email__c  = conObj.AlternativeEmail__c;
                newEmail.Emai_Type__c = alter;
                newEmail.ContactId__c = conObj.Id;
                mail.add(newEmail);
            }
            if(isExistingChanged('OtherEmail__c',conObj))
            {
                Email__c newEmail = new Email__c();
                System.debug('inside alternative');
                newEmail.Email__c  = conObj.OtherEmail__c;
                newEmail.Emai_Type__c = other;
                newEmail.ContactId__c = conObj.Id;
                mail.add(newEmail);
            }
        }
        Map<Id,List<Email__c>> emilst = new Map<Id,List<Email__c>>();
        for(Email__c em : [SELECT id,ContactId__c, Emai_Type__c, Email__c from Email__c where  Active__c = true]) {
               
                if(emilst.get(em.ContactId__c) == null)
                {
                    emilst.put(em.ContactId__c,new List<Email__c>());
                }
                emilst.get(em.ContactId__c).add(em);
            }
        
        for(Contact con : conList)  
        {
            Contact c = (Contact) trigger.oldMap.get(con.Id);
            
                for(Email__c e: emilst.get(con.Id))
                {
                    if(e.Emai_Type__c == 'Campus Email' && con.CampusEmail__c != c.CampusEmail__c)
                    {
                        e.Active__c = false;
                        
                        mail.add(e);
                    }
                    if(e.Emai_Type__c == 'Alternative Email' && con.AlternativeEmail__c != c.AlternativeEmail__c)
                    {
                        e.Active__c = false;
                       
                        mail.add(e);
                    }
                    if(e.Emai_Type__c == 'Other Email' && con.OtherEmail__c != c.OtherEmail__c)
                    {
                        e.Active__c = false;
                        
                        mail.add(e);
                    }
                }
            
        }    
        upsert mail;
    }
}