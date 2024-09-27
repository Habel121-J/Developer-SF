public class CustomMetadata_Services implements Metadata.DeployCallback  {

    @AuraEnabled
    public static deployResult checkStatusForNew(Id jobId){
        try {
            System.debug('IDDD'+jobId);    

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Salesforce/services/data/v57.0/metadata/deployRequest/'+ jobId+'?includeDetails=true');
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            Map<String, Object> result = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            String ResBody = JSON.serialize(result.get('deployResult'));
            Metadata.DeployResult mdtResult = (Metadata.DeployResult) JSON.deserialize(ResBody, Metadata.DeployResult.class);
            System.debug('status---->'+mdtResult.status);
            deployResult dr = new deployResult();
            dr.status = String.valueOf(mdtResult.status);
            dr.errorMessage = mdtResult.errorMessage;
            
            System.debug('success---->'+mdtResult.success);
            return dr;
        }catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw e;
        }
    }

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext callback){
        if (result.status == Metadata.DeployStatus.Succeeded) {

            // System.debug('deployment successful'+result);
            // Deployment was successful

        } else {
            // Deployment was not successful
        }
        
    }

    @AuraEnabled
    public static Id createMdtRecords(String mdtName, String Label ,String fieldValues){
            String DevName = Label.replace(' ', '_');
            System.debug('mdtnMae'+mdtName);
            System.debug('devname'+DevName);    
            Map<String, Object> mapFields = (Map<String, Object>) JSON.deserializeUntyped(fieldValues);    
            System.debug('mapfieldvalues-->'+mapFields);
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.FullName = mdtName + '.' + DevName;
            System.debug('Fullname'+mdtName + '.' + DevName);
            customMetadata.Label = label;
            for(String s : mapFields.keySet()){
                if(s <> 'Id'){                    
                    Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();                   
                        customField.Field = s;
                        customField.Value = mapFields.get(s);        
                        customMetadata.values.add(customField);          
                }


                }
                
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);        
        CustomMetadata_Services callback = new CustomMetadata_Services();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        return jobId;
    }

    public class deployResult{
        @AuraEnabled
        public String status;

        @AuraEnabled
        public String errorMessage;
    }

}