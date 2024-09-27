public  class  GetAccountRelatedContacts {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccCons(Id recordId){
       return [SELECT Id,Name,Email, Title FROM Contact WHERE AccountId =:recordId];
    }

    @AuraEnabled
    public static void unassignContact(Contact cont){
        update cont;
    }

    
    @AuraEnabled
    public static Contact createContact(Contact newcon, Id recordId) {

        newcon.AccountId = recordId;
        insert newcon;
        System.debug('contact id'+newcon.Id);
        return [SELECT Id,Name,Email, Title FROM Contact WHERE Id =: newcon.Id];
    }

    @AuraEnabled
    public static void updateContact( Id recordId, Contact[] conList) {

        System.debug('inside update contact'+conList);
        try{
            for(Contact c: conList){

                c.AccountId  = recordId;
            }
                System.debug('conlist'+conList);
            update conList;
        }
        catch(Exception  e){
                System.debug('error'+e.getMessage());
        }
         
    }

    

    @AuraEnabled
    public static List<Contact> searchCons(String searchterm, String Id){
        String term = searchterm+'%';
        String partialSearch = '%'+ searchterm + '%';
        List<Contact> listCons = [SELECT Name,Email,Title,AccountId FROM Contact WHERE Name LIKE: term  AND AccountId !=: Id LIMIT 5];
        Set<Id> conIds = new Set<Id>();
        for(Contact c : ListCons){
            conIds.add(c.Id);
        }      
        if(ListCons.size()<5){
            Integer limiter = 5 - ListCons.size();
            for(Contact con: [SELECT Name,Email, Title,AccountId FROM Contact WHERE NAME LIKE :partialSearch AND Id NOT IN: conIds AND  AccountId !=: Id LIMIT: limiter]){
                ListCons.add(con);
            }
        }
        return ListCons;
    }

    @AuraEnabled
    public static List<ColumnWrapper> dynamicFields(String fields,String objName){

        List<ColumnWrapper> WrapperCols = new List<ColumnWrapper>();

                 System.debug('inside dynamic fields'+fields);

            if(!String.isBlank(fields) && !String.isBlank(objName)){

                String[] fieldAPI = fields.split(',');
                System.debug('field values'+fieldAPI);
                 Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        
                for(String s :fieldAPI ){

                    if(fieldMap.containsKey(s)){
                
                    Schema.DescribeFieldResult fieldsDes = fieldMap.get(s).getDescribe();

                    ColumnWrapper colWrap = new  ColumnWrapper();
                     colWrap.Label =  fieldsDes.getLabel();
                    colWrap.fieldName = fieldsDes.getName();
                    colWrap.Type =  String.valueOf(fieldsDes.getType());
                    WrapperCols.add(colWrap);
                    } 
                }   
            }
            System.debug('dis'+WrapperCols);
        
 
        return WrapperCols;
    }

    public class ColumnWrapper{

        @AuraEnabled
        public String Label;

        @AuraEnabled
        public String Type;
        
        
        @AuraEnabled
        public String FieldName;
    }

}