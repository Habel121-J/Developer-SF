public with sharing class CaseDetailsApexClass
{
    @AuraEnabled
    public static void saveCaseDetails(Case CaseDetails)
    {
        List<Case> getCase = new List<Case>();
        getCase.add(CaseDetails);
        Insert getCase;        
    }
    @AuraEnabled
    public static void sendMails(String NAME, string EMAIL,string PHONE, string SUBJECT, string DESCRIPTION)
    {
        String body = 'the name of the person--'+ NAME +'.And his Mail is--'+ EMAIL+'   And his phone number is ='+PHONE+' and he added the subject-- '+SUBJECT+' And description is--' +DESCRIPTION;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> allMail = new List<Messaging.SingleEmailMessage>();
        for(User uMail : [SELECT Email from User WHERE Profile.Name ='System Administrator' ]){
            mail.toAddresses = new string[] {uMail.Email};
        }
        
        mail.setSubject('The Case Description');
        mail.setPlainTextBody(body);
        allMail.add(mail);
        Messaging.sendEmail(allMail);
     }
}