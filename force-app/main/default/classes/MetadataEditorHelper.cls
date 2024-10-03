public class MetadataEditorHelper implements Metadata.DeployCallback {    
    @AuraEnabled(cacheable=true)
    public static List<MetaDataInfo> fetchMetaObjects(){
        List<MetaDataInfo> MetaDataInfo = new List<MetaDataInfo>();
        try {
            for(Schema.SobjectType ss : Schema.getGlobalDescribe().values()){
                Schema.DescribeSObjectResult dr = ss.getDescribe();      
                if(dr.getName().endsWith('mdt')){                    
                    MetaDataInfo mr = new MetaDataInfo();
                    mr.label = dr.getLabel();
                    mr.value = dr.getName();
                    MetaDataInfo.add(mr);
                }
            }
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return MetaDataInfo;
    }

    @AuraEnabled
    public static List<FieldDefitions> fieldDefitions(String mdtName){
        List<FieldDefitions> FieldDef = new List<FieldDefitions>();        
            Schema.SObjectType ss = Schema.getGlobalDescribe().get(mdtName);
            Schema.DescribeSObjectResult dr = ss.getDescribe();            
                Map<String,Schema.SObjectField> MapofField = dr.fields.getMap();
                for(String fieldName : MapofField.keySet()){
                    Schema.SObjectField field = MapofField.get(fieldName);
                    Schema.DescribeFieldResult F = field.getDescribe(); 
                    FieldDefitions fd = new FieldDefitions();
                    fd.fieldLabel = F.getLabel();
                    fd.fieldApiName = F.getName();
                    fd.isEditable = F.isAccessible();
                    fd.type =  String.valueOf(F.getType());
                    fd.isNillable = F.isNillable();
                    FieldDef.add(fd);
                }                         
        return FieldDef;       
    }

    @AuraEnabled
    public static List<SObject> fetchMdtRecords(String mdtName){
        List<SObject> recList;
        try {
            List<String> fieldApiNames =  fetchFieldsApiNames(mdtName);
            recList = Database.query('SELECT '+ String.join(fieldApiNames, ',') +' FROM '+ mdtName + ' WITH SECURITY_ENFORCED');
            
            
        }catch(Exception ex){
            System.debug('errorr-->'+ex.getMessage());
        }
        return recList;
    }

    public static List<String> fetchFieldsApiNames(String mdtName){
        List<String> fieldNames = new List<String>();
        Schema.SObjectType ss = Schema.getGlobalDescribe().get(mdtName);
            Schema.DescribeSObjectResult dr = ss.getDescribe();            
                Map<String, Schema.SObjectField> MapofField = dr.fields.getMap();
                for(String fieldName : MapofField.keySet()){
                    Schema.SObjectField field = MapofField.get(fieldName);
                    Schema.DescribeFieldResult F = field.getDescribe();
                    fieldNames.add(F.getName());                   
                }
                
        return  fieldNames;
    }

    @AuraEnabled
    public static Id createMdtRecords(String mdtName, String Label ,String fieldValues){
            System.debug('label'+Label);
            String DevName = Label.replace(' ', '_');    
            Map<String, Object> mapFields = (Map<String, Object>) JSON.deserializeUntyped(fieldValues);    
            System.debug('mapfieldvalues-->'+mapFields);
            Metadata.CustomMetadata Cmdt = new Metadata.CustomMetadata();
            Cmdt.FullName = mdtName + '.' + DevName;
            Cmdt.Label = label;

            for(String  s : mapFields.keySet()){
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.Field = s;
                customField.Value = mapFields.get(s);
        
        Cmdt.values.add(customField);
        }

        System.debug('Cmdt---->'+Cmdt);
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(Cmdt);
        
        MetadataEditorHelper callback = new MetadataEditorHelper();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        return jobId;

    }

   
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext callback){
        if (result.status == Metadata.DeployStatus.Succeeded) {
            // Deployment was successful
        } else {
            // Deployment was not successful
        }
        
    }

    public class FieldDefitions{
        @AuraEnabled
        public String fieldApiName;

        @AuraEnabled
        public String type;

        @AuraEnabled
        public String fieldLabel;

        @AuraEnabled
        public Boolean isEditable;

        @AuraEnabled
        public Boolean isNillable;

        // @AuraEnabled
        // public Boolean isupdateable;
    }

    public class MetaDataInfo {
        @AuraEnabled 
        public String label;

        @AuraEnabled
        public String value;
        
        @AuraEnabled 
        public List<String> fieldApiNames;
    }

    
}