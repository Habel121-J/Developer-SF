/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-01-2022
* @modified      
* @systemLayer     Apex Class
*/

//@description to get JSON records from workbench and create account details in Account Object
@RestResource(urlMapping = '/createAccountData/*')
global   class Rest_Servie
{ 
    @HttpPost
    global static  Void createAccount()
    {
        List<SObject> accList = new List<SObject>();
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        RestfulWrapper wrapData = (RestfulWrapper)JSON.deserialize(request.requestBody.toString(), RestfulWrapper.class);
        System.debug(' wrapData '+wrapData);
        //Map<String, Object> fieldMap = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        SObject newSobject;
        
        
       // System.debug(' wrapData '+wrapData);
        //System.debug('wrap data '+wrapData.records[0]);
        //System.debug('--->'+wrapData.records[0].attributes.type);
        
        for(Integer i = 0;i<wrapData.records.size();i++){
             Schema.SObjectType targetType = Schema.getGlobalDescribe().get(wrapData.records[i].attributes.type);
             //Schema.SObjectField fldType = Schema.get
            System.debug('--->'+targetType);
             newSobject = targetType.newSObject();
             newSobject.put('Name',wrapData.records[i].Name);
             newSobject.put('Phone',wrapData.records[i].Phone);
             newSobject.put('Website',wrapData.records[i].Website);
             //newSobject.put('NumberOfEmployees',wrapData.records[i].NumberOfEmployees);
            
             accList.add(newSobject);
            
        }
        Map<String, Object> responseData;
        
        try{
            INSERT accList;	
            responseData = createResponseData(200, 'Sucess', true, accList,'');
        }catch(Exception e){
            System.debug('Error----- '+e);
            responseData = createResponseData(400, 'Error', False, new List<Account>(), e.getMessage());
        }
        
       // System.debug('response data '+responseData);
        response.addHeader('Content-Type','application/json');
        response.responseBody= Blob.valueOf(JSON.serialize(responseData));
        // response.statusCode=(Integer)responseData.get('Statuscode');
    }  
    global static  Map<String, Object> createResponseData(Integer statusCode, String msg, Boolean isSucess, List<Account> accList, String errorMessage ){
        Map<String, Object> responseMap = new Map<String, Object>();
        if(isSucess  && !accList.isEmpty()){
            responseMap.put('Statuscode', statusCode);
            responseMap.put('Message', msg);
            responseMap.put('Status', isSucess);
            responseMap.put('Record Details', accList);
        }
        else{
            responseMap.put('Statuscode', statusCode);
            responseMap.put('Message', msg);
            responseMap.put('Status', isSucess);
            responseMap.put('No Records ', errorMessage);
        }
        return responseMap;
    }
    
    
}