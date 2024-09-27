trigger ContactTrigger on Contact(after insert,after update, after delete){    
    
    if(CheckRecursion.isOnce){
      
        CheckRecursion.isOnce = false;
        if(Trigger.isAfter && Trigger.isInsert){
            System.debug('--------');            

                ContactTriggerHandler.UpdateCountOnInsert(Trigger.new);
        }

        if(Trigger.isAfter && Trigger.isUpdate){

                ContactTriggerHandler.countOnUpdate(Trigger.new,Trigger.oldMap);
        }


        
    }



}