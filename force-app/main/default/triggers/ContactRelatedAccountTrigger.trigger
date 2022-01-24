trigger ContactRelatedAccountTrigger on Contact (after update, after insert)

{
List<String> conid = new List<String>();
for(Contact con : Trigger.New){
    conid.add(con.accountid);      

}

List<account> acc = [SELECT id, Contact_Data__c from account where id in :conid];
List<account> acclist = new List<account>();  
for(account a : acc)
{
for(contact c : trigger.new)
    {
    if(c.accountid==a.id)
        {
        a.Contact_Data__c = c.Department;
        acclist.add(a);
            } 
    
            }
        }
update  acclist;

}