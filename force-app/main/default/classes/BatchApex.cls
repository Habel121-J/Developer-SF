public class BatchApex implements Database.Batchable<SObject>{

    public static  Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator('SELECT');


    }

    public void execute(Database.BatchableContext bc, List<sObject> ac){


    }

    public void finish(Database.BatchableContext bc){

    }
}