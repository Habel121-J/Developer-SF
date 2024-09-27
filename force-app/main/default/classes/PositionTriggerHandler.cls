public with sharing class PositionTriggerHandler {
    

    public static void updateFields(List<Position__c> recList){

        for(Position__c pos : recList){


            if(pos.isNew__c ==true && pos.Max_Pay__c==null && pos.Min_Pay__c==null && pos.Open_Date__c==null){

                pos.Open_Date__c = system.today();
                pos.Max_Pay__c = 15000;
                pos.Min_Pay__c = 10000;


            }
        }



    }
}