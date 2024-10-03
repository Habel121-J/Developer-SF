public class CreateMetadataTypes {
    
    Static Id Id;
    
    public static void buildCustomMetadata(){
        try{
            
            Metadata.CustomMetadata mdt = new Metadata.CustomMetadata();
            mdt.fullName  = 'Account_Metadaytype__mdt'+'.'+'Test';
            mdt.label ='Test';    
            mdt.description = 'Used to log the errors from API';
            List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
            Metadata.CustomMetadataValue ac = new Metadata.CustomMetadataValue();
            ac.field = 'Name__c';
            ac.value = 'Kumar';  
            customFields.add(ac);
            mdt.values = customFields;          
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(mdt);
            TestDeployCustomMetaDataType callback = new TestDeployCustomMetaDataType();
            
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer,callback);
            System.debug('JobId---->'+Id);
        }catch(Exception ex){
            
            System.debug('error---->'+ex.getMessage());
        }
    }
}