trigger CaseTrigger on Case (before insert,after insert) {

    if(Trigger.isBefore && Trigger.isInsert){

        CaseTriggerHandler.updateContactOnCase(Trigger.New);

    }

    if(Trigger.isAfter && Trigger.isInsert){
        CaseTriggerHandler.updateAccount(Trigger.New);
    }

}