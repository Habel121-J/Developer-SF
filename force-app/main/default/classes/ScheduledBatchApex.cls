/*@author           Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @modifiedBy       Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @maintainedBy     Prasanna Kumar         <habelprasanna5@curious-panda-ue34tv.com>
* @version          1.0
* @created          2021-11-30
* @modified      
* @systemLayer     Apex SCheduler Class
*/

//@description   Apex class which returns list of records from account based on id
public class ScheduledBatchApex implements Schedulable

{
    
    public void execute(SchedulableContext sc)
        
    {
        
        ApexBatchUpdateDate ab = new ApexBatchUpdateDate();
        database.executeBatch(ab);
    }
    
}