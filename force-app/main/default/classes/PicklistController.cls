public with sharing class PicklistController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectNames(){
        Map<String,Schema.SObjectType> AllObjectMap=new Map<String,Schema.SObjectType>();
        AllObjectMap=Schema.getGlobalDescribe();
        List<String> l = new List<String>(AllObjectMap.keySet()); 
        System.debug('l from apex '+l);
        return l;
    }
}