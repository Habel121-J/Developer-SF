public with sharing class FetchListingState {
  @AuraEnabled
  public static map<List<Id>, Listing__c> fetchState (String lstStateName){
    
    String keyNameString = '%' +  lstStateName + '%';
   
    //set<id> ids =new set<id>
    // for(Listing__c ls :lst ){
    // ids.add(lst.Id)
    //  }
       
    map<List<Id>,Listing__c> mapListId = new map<List<Id>,Listing__c>();
    
    for(Listing__c listrec: [Select Id, Country__c, City__c, Street__c, State2__c FROM Listing__c where State2__c LIKE :keyNameString]){
      List<Id> verid = getVerId(listrec.Id);
      mapListId.put(verid,listrec);
      
    }
    System.debug('maplist '+mapListId);
     return mapListId;
  }
   
        
  @AuraEnabled
    public static List<Id> getVerId (String ids){
      List<Id> fileIDs = new List<Id>();
      for (ContentDocumentLink docLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = : ids]) {
          fileIDs.add(docLink.ContentDocumentId);
      } 
    
        List<Id> conversionid = new List<Id>();
      
      for (ContentVersion docLink : [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN : fileIDs]) {
        conversionid.add(docLink.Id);
        
      }
      return conversionid;
    }
            
  
     
  
  }		
  