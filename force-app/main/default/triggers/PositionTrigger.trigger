trigger PositionTrigger on Position__c (before insert) {

    if(CheckRecursion.isOnce){
        CheckRecursion.isOnce = false;


        if(Trigger.isBefore && Trigger.isInsert){

            PositionTriggerHandler.updateFields(Trigger.New);


        }


    }

}