public class AccountTriggerHandler {

    public static void updateRating(List<Account> accList){

        for(Account acc : accList){

            if(acc.Industry == 'Media' && !String.isBlank(acc.Industry)){

                acc.Rating = 'Hot';

            }
            if(acc.CopyBillingToShipping__c == true ){
                System.debug('INSIDE ADDRES');
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingState = acc.BillingState;
            }


            System.debug('acc---->'+acc);

            
        }   


    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id recordId){

        return [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = : recordId];


    }





    public static void updateRelatedPhoneNumbers(List<Account> accList, Map<Id,Account> oldRecs){
        /*UPdate Phone if chnaged update description*/
        
        for(Account acc : accList){

            if(acc.Phone != oldRecs.get(acc.Id).Phone){

                acc.Description = 'Phone is Updated! Old value : '+ oldRecs.get(acc.Id).Phone + '& NEw Value  : '+ acc.Phone;

            }
        }
        




      
        // Map<Id, Account> mapAccts = new Map<Id,Account>();  
        // for(Account acc : accList){

        //     if(!mapAccts.containsKey(acc.Id) && String.isNotBlank(acc.Phone)){

        //         mapAccts.put(acc.Id, acc);
        //     }
        // }
        // List<Contact> conList = new List<Contact>();
        // for(Contact con : [SELECT Id, AccountId, HomePhone FROM Contact WHERE AccountId IN : mapAccts.keySet()]){

        //     con.HomePhone = mapAccts.get(con.AccountId).Phone;
        //     conList.add(con);

        // }
        // if(!conList.isEmpty()){

        //     update conList;
        // }   





    }
    public static void createRelatedRecords(List<Account> accList){
        List<sObject> records = new List<sObject>();

    
        for(Account acc : accList){

            if(acc.Contact__c ==true && acc.Opportunity__c == true && acc.Status__c =='Active'){

                records.add(new Contact(LastName = acc.Name, AccountId = acc.Id));
                records.add(new Opportunity(StageName = 'Closed Won', Name= acc.Name, AccountId = acc.Id));

            }if(acc.Contact__c ==true){

                records.add(new Contact(LastName = acc.Name,AccountId = acc.Id));


            }if(acc.Opportunity__C == true){

                records.add(new Opportunity(StageName = 'Closed Won', CloseDate = System.today(), Name=acc.Name, AccountId = acc.Id));
            }
        }

        


       
        insert records;


    }
   
    public void UpdateOpportunities(List<Account> accList){

        Set<Id> accIds = new Set<Id>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();

        for(Account acc: accList){      

            accIds.add(acc.Id);    
        }
        
        for(Opportunity opp : [SELECT Id, AccountId, StageName, CreatedDate FROM Opportunity WHERE AccountId IN :accIds AND  CreatedDate < LAST_N_DAYS:30 AND StageName != 'Closed Won']){

            opp.StageName = 'Closed Lost';
            System.debug('opp'+opp);
            oppListToUpdate.add(opp);
        }

        upsert oppListToUpdate;
    }

    /* Account is created with Industry as Banking then create a contact for account, 
    Contact Lastname as Account name and contact phone as account phone*/
    public static void createContacts(List<Account> accList){
        List<Contact> conList  = new List<Contact>();
        for(Account acc : accList){
            if(acc.Industry == 'Banking'){
                System.debug('inside if ');
                conList.add(new Contact(LastName = acc.Name, Phone = acc.Phone));
            }
        }
        if(!conList.isEmpty()){
            System.debug('list contacts'+conList);
            insert conList;
        }
    }
}