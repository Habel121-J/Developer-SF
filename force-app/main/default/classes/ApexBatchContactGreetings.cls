/*@author         Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy   Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version        1.0
* @created        2022-01-06
* @modified      
* @systemLayer    Batch Apex Class
*/

//@description  batch Apex class for sending greeting to contact email when DOB matches with current date
public class ApexBatchContactGreetings implements Database.Batchable<Sobject> {
    
    // collect the batches of records or objects to be passed to execute
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, Email,Birthdate FROM Contact WHERE Email!=null AND Birthdate!=null';
        return Database.getQueryLocator(query);
    }
    /* @description ---> updating contact field with current date
    * @param  List contacts
    */
    public void execute(Database.BatchableContext bc, List<Contact> conList){
        system.debug('conlist '+conList);
        date dt  = Date.today();
        System.debug('date '+system.now());
        Integer sysDay = dt.Day(); 
        Integer sysMonth = dt.Month(); 
        System.debug('month '+sysMonth);
        List<String> mails = new List<String>();
        for(Contact con : conList){ 
            date conDate =  con.Birthdate;
            integer conDay  = conDate.day();
            integer conMonth = conDate.month();
            if( conDay == sysDay && conMonth == sysMonth){
                System.debug('running if equals');
                mails.add(con.Email); 
            }
            
        }
        System.debug('mails '+mails);
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         message.toAddresses = mails;
         message.subject = 'Greetings of the day';
         message.plainTextBody = 'This is the message body.';
         Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
    public void finish(Database.BatchableContext BC){
       
       
    }
}