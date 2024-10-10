trigger OpportunityTrigger on Opportunity(after insert, before insert, after update, before update){


    switch on Trigger.OperationType{

        when BEFORE_INSERT{


        }

        when AFTER_INSERT{

            
        }
    }


}