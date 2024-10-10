public  class ContactTriggerHandler {
    public static void updateCount(List<Contact> conList, Map<Id,Contact> conMap){

        Map<Id,Integer> conAccs = new Map<Id,Integer>();
        List<Account> accList = new List<Account>();
        Set<Id> accIds = new Set<Id>();

        if(Trigger.isInsert){

            for(Contact con : conList){
                
                if(con.AccountId <> null){

                    accIds.add(con.AccountId);
            }
                }

        }else if(Trigger.isUpdate){

            for(Contact con : conList){

                if(!String.isBlank(con.AccountId)){
                        if(con.AccountId!= conMap.get(con.Id).AccountId){

                            accIds.add(con.AccountId);
                        }
                }else{
                        accIds.add(conMap.get(con.Id).AccountId);
                        

                }
                

               
            }


        }else if(Trigger.isDelete){

            for(Contact con : conList){
                if(con.AccountId!=null){
                    
                    accIds.add(con.AccountId);
                }
            }

        }else if(Trigger.isUndelete){

            for(Contact con : conList){

                if(con.AccountId!=null){

                    accIds.add(con.AccountId);

                }
            }


        }

        for(AggregateResult ag : [SELECT COUNT(Id) cnt,AccountId FROM Contact GROUP BY AccountId]){

            conAccs.put((Id)ag.get('AccountId'), (Integer)ag.get('cnt'));
        }
        
        for(Account acc : [SELECT Id,totalContacts__c from Account WHERE Id IN : accIds]){


            acc.totalContacts__c = conAccs.get(acc.Id);

            accList.add(acc);

        }   

        try {
            if(!accList.isEmpty()){

                update accList;
            }
        } catch (Exception ex) {

            System.debug('exception'+ex.getMessage());
            
        }

       




       




    

    }

}