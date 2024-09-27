trigger AccountTrigger on Account(after update, after insert,  before update,before insert) {

    if(CheckRecursion.isOnce){

        if(Trigger.isAfter && Trigger.isInsert){

            AccountTriggerHandler.createRelatedRecords(Trigger.New);
            // AccountTriggerHandler.updateRelatedPhoneNumbers(Trigger.New);
        }

        if(Trigger.isBefore && Trigger.isUpdate){

            // AccountTriggerHandler.createRelatedRecords(Trigger.New);
            AccountTriggerHandler.updateRelatedPhoneNumbers(Trigger.New, Trigger.oldMap);
        }

        if(Trigger.isBefore && Trigger.isInsert){

            
            AccountTriggerHandler.updateRating(Trigger.New);
        }
        // if(Trigger.isAfter && (Trigger.isUpdate ||  Trigger.isInsert)){            
        //   //  AccountTriggerHandler.UpdateOpportunities(Trigger.new);
        //   AccountTriggerHandler.accountUpdateOrInsert(Trigger.New);
        // }
        // if(Trigger.isAfter && Trigger.isInsert){            
        //     AccountTriggerHandler.createContacts(Trigger.new);
        // }
        // if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){            
        //     AccountTriggerHandler.accountUpdateOrInsert(Trigger.new);
        // }
        // if(Trigger.isAfter && Trigger.isDelete){
        //    // AccountTriggerHandler.accountUpdateOnDelete(Trigger.old);

        // }


    }
}