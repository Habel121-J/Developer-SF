public  class BatchApexClass implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        String query = 'SELECT ID,Name FROM ACCOUNT LIMIT 15';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> accList){

        for(Account acc : accList){
            System.debug('acc'+acc);

            acc.Name = 'acc '+'update from batch';

        }

        update accList;

    }

    public void finish(Database.BatchableContext bc){


        System.debug('ETEA');
    }
    
}