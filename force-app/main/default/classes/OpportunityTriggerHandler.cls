public class OpportunityTriggerHandler {


public static void updateDescription(List<Opportunity> oppRecords){
    
List<Opportunity> newRecords = new List<Opportunity>();

for(Opportunity opp : oppRecords){


    if(opp.Amount <> null && opp.Amount > 100000){

        opp.Description = 'Hot';
    }
}



}

//TO update records
public static void updateRecentAmount(List<Opportunity> oppList){
   Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();
    for(Opportunity opp : oppList){

        if(String.isNotBlank(opp.AccountId)){

            mapOpp.put(opp.AccountId, opp);
            
        }
        List<Account> accList = [SELECT Id, Recent_Opportunity_Amount__c FROM Account WHERE Id IN :mapOpp.keySet()];

        if(!accList.isEmpty()){

            for(Account acc : accList){

                acc.Recent_Opportunity_Amount__c =  mapOpp.get(acc.Id).Amount;





            }

            update accList;



        }





    }






}    


public static void updateMaxOpportunity(List<Opportunity> oppList){
    Set<Id> accIds = new Set<Id>();
    for(Opportunity opp : oppList){
        if(opp.AccountId <> null || !String.isBlank(opp.AccountId)){

            accIds.add(opp.AccountId);
        }   
    }

    List<Account> accList = [SELECT Id, Name, maxOpp__c, (SELECT Id, Amount FROM Opportunities ORDER BY Amount DESC NULLS LAST LIMIT 1) FROM Account WHERE Id IN : accIds];
    for(Account acc : accList){
        
        System.debug('max oppo'+acc.Opportunities[0].amount);
        acc.maxOpp__c = acc.Opportunities[0].amount;
    }


        if(!accList.isEmpty()){
            
         update accList;
        }

    }
}