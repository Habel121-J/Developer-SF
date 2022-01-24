/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2022-01-04
* @modified      
* @systemLayer      Apex Class
*/

//@description to Update owner field of Task Object whenever Contact Owner in Contact is updaetd
public  class TaskTrigger 
{
    public static void isAfterUpdate(List<Contact> conList)
    {
           isAfterUpdateCon(conList);
    }
    public static void  isAfterUpdateCon(List<Contact> conList) 
    {
        List<Task> insertTask = new List<Task>();
          
        
        System.debug('conTaskdata '+conList);
        Map<Id,List<Task>> taskList = new  Map<Id,List<Task>>();
        for(Task ts :  [select WhatId,WhoId,OwnerId,Subject from TASk]) 
        {
            if(!taskList.containsKey(ts.WhoId)){
            taskList.put(ts.WhoId, new List<Task>());
            }
            taskList.get(ts.WhoId).add(ts);
        }
       
        System.debug('mapofidtask '+taskList);

        for(Contact c : conList){
 
            Contact cons = (Contact)trigger.oldMap.get(c.Id);
            System.debug('oldrecs '+cons);
            if(taskList.containsKey(c.Id)){
            for(Task t : taskList.get(c.Id)){
                if(cons.OwnerId != c.OwnerId ){
                    t.OwnerId = c.OwnerId;
                    t.Description  = 'TESTFROMTRIGGER';
                    System.debug('inside task update '+t);
                   

                    insertTask.add(t);
                }
            }
            }
        }
        if(!insertTask.isEmpty()){
            upsert insertTask;
        }
    }
}