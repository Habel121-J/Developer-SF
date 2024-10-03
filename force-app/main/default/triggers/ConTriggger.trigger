trigger ConTriggger on Contact (after insert) {
    
    List<Contact> conList = new List<Contact>(); 
    
    for(Contact c : Trigger.New){
        	
        c.LastName  = c.LastName + '---';
        
      
    }

}