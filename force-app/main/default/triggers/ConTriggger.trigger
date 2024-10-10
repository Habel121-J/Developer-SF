trigger ConTriggger on Contact (after insert,after update,after delete, after undelete) {
    

    switch on Trigger.OperationType{

        when AFTER_INSERT,AFTER_UNDELETE{
            ContactTriggerHandler.updateCount(Trigger.New,new Map<Id,Contact>());


        }

        when AFTER_UPDATE{
            ContactTriggerHandler.updateCount(Trigger.New,Trigger.oldMap);

        }

        when AFTER_DELETE{

            ContactTriggerHandler.updateCount(Trigger.old,new Map<Id,Contact>());


        }
    }
    



    
}


