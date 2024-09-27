// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
Id jobId = '0AfJ30000002r8FKAQ';
//+'?includeDetails=true'
try {
    System.debug('IDDD'+jobId);
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:Salesforce/services/data/v57.0/metadata/deployRequest/'+ jobId+'?includeDetails=true');
    req.setMethod('GET');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    System.debug('BODY-->'+res.getBody());
    Map<String,Object> mf = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
    String ResBody = JSON.serialize(mf.get('deployResult'));
  	Metadata.DeployResult result = (Metadata.DeployResult)JSON.deserialize(ResBody, Metadata.DeployResult.class);
    System.debug('result-->'+result);
  	
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    
}
