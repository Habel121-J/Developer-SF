trigger LeadAccountTrigger on Lead (after insert,after update) {
    
    if(trigger.isAfter){
        if(trigger.isUpdate)
        {
            HandlerLeadController.isAfterUpdate(Trigger.new);    
        }
        if(trigger.isInsert)
        {
            HandlerLeadController.isAfterInsert(Trigger.new);    
        }
    }

}