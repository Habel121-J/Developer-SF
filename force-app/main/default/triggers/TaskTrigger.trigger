trigger TaskTrigger on Task(before delete) {

    if( Trigger.isBefore && Trigger.isDelete ){
         System.debug('tesadasd');
        TaskTriggerHandler.checkUser(Trigger.old);
    }       

}