trigger ContactTrigger on Contact (after insert,after update) {

        system.debug('from triggr');
        
    if(trigger.isAfter){
        if(trigger.isUpdate) {
            system.debug('from inside update');
            Handler_ConTrigger.isAfterUpdate(Trigger.new);       
         }
         if(trigger.isInsert){
            system.debug('from inside insert');
            Handler_ConTrigger.isAfterInsert(Trigger.new);
        }
        
     }
}
   