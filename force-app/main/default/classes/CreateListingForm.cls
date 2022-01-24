public with sharing class CreateListingForm
{
    
    @AuraEnabled
    public static List<String> getCategoryPickList()
    {
        List<String> mapCategory = new List<String>();
        Schema.DescribeFieldResult fieldResult = Listing__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> categoryPickList = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry eachOne : categoryPickList)
        {
            mapCategory.add(eachOne.getValue());
        }
        return mapCategory;
    }
    @AuraEnabled
    public static List<String> getDurationPickList()
    {
        List<String> mapDuration = new List<String>();
        Schema.DescribeFieldResult fieldResult = Listing__c.Duration__c.getDescribe();
        List<Schema.PicklistEntry> durationList = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry eachOne : durationList)
        {
            mapDuration.add(eachOne.getValue());
        }
        return mapDuration;
    }
    @AuraEnabled
    public static List<String> getStateList()
    {
        List<String> mapState = new List<String>();
        Schema.DescribeFieldResult fieldResult = Listing__c.State2__c.getDescribe();
        List<Schema.PicklistEntry> statePickList = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry eachOne : statePickList)
        {
            mapState.add(eachOne.getValue());
        }
        return mapState;
     }
    @AuraEnabled
    public static List<String> getStatusList()
    {
        List<String> mapStatus = new List<String>();
        Schema.DescribeFieldResult fieldResult = Listing__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> statusPickList = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry eachOne : statusPickList)
        {
            mapStatus.add(eachOne.getValue());
        }
        return mapStatus;
    }

    @AuraEnabled
    public static string insertList(Listing__c gtList, string file, string fileName){
          string listId;
        try{  
            insert gtList;  
            listId = gtList.Id;  
            String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
            ContentVersion contentVersionRec = new ContentVersion();  
            contentVersionRec.Title = fileName;  
            contentVersionRec.PathOnClient = '/' + fileName;  
            contentVersionRec.FirstPublishLocationId = gtList.Id;  
            contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
            contentVersionRec.IsMajorVersion = true;  
            Insert contentVersionRec;  
          } catch(Exception ex){  
            system.debug('Exception===>'+ex.getMessage());  
          }  
          return listId;  
        }    
}    


