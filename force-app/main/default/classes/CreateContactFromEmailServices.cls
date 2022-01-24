global class CreateContactFromEmailServices implements Messaging.InboundEmailHandler {
global static Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                        Messaging.InboundEnvelope envelope){
Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

Contact newCon = new Contact();    
String myPlainText= '';
String[] emailData = email.plainTextBody.split('\n');

for (String bodyRow: emailData) {
    String[] rowContents = bodyRow.split(':');
    String label = rowContents[0].trim();
    String value = rowContents[1].trim();
    switch on label {
        when 'LastName' {
            String name = value;
            
            newCon.LastName = name;
        }	
        when 'Phone' {	
            newCon.Phone = value;  
        }
        
        when 'Email' {		  
            newCon.Email = value;
        }
    }
}                
    

try
{
insert newCon;
    System.debug('New Contact Created: '+newCon);
}

catch (Exception e) {
    System.debug('Issue: ' + e);
}
    result.success = true;

return result;
} 
}


