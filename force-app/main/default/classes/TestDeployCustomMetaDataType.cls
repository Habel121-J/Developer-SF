public class TestDeployCustomMetaDataType implements Metadata.DeployCallback{
    
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext mdt2){
        if(result.status == Metadata.DeployStatus.Succeeded){
            	
            System.debug('result--->');
            

        }else {
            System.debug('error----->'+result);
        }
        
        	
        
    }
   
    
}