public with sharing class SaveOffering {
    @AuraEnabled
    public static void insertOffering(Offerings__c off) {
        try{
            insert off;
            system.debug('off'+off);
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}