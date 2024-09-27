trigger OpportunityTrigger  on Opportunity (after insert,after update,before insert, after delete, after undelete) {

    if(CheckRecursion.isOnce){
        CheckRecursion.isOnce = false;

        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
    
    
            OpportunityTriggerHandler.updateMaxOpportunity(Trigger.new);
        }

        if(Trigger.isBefore && Trigger.isInsert){

            OpportunityTriggerHandler.updateDescription(Trigger.New, Trigger.oldMap);
        }

        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){

            OpportunityTriggerHandler.updateRecentAmount(Trigger.New);
        }

        
    
    
        if(Trigger.isAfter && Trigger.isDelete){
    
            OpportunityTriggerHandler.updateMaxOpportunity(Trigger.Old);
    
        }
         

    }


}