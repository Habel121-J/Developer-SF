trigger ContactReltaedTask on Contact(after update) {

    if(trigger.isAfter){
        if(trigger.isUpdate) {
            system.debug('from inside contact update');
            TaskTrigger.isAfterUpdate(Trigger.new);       
        }
    }
}