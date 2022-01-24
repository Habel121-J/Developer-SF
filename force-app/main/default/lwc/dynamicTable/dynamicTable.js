import { LightningElement,api,track } from 'lwc';
import insertConData from '@salesforce/apex/InsertContactController.insertConData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class DynamicTable extends LightningElement {

 
   conToSave = {};
   

  fields = [{ fieldapi: 'firstname', fieldtype: 'text', label: 'Name', isEditable: false },
            { fieldapi: 'LastName', fieldtype: 'text', label: 'LastName', isEditable: true },
            { fieldapi: 'phone', fieldtype: 'number', label: 'Phone', isEditable: false },
            { fieldapi: 'email', fieldtype: 'email', label: 'Email', isEditable: true },
            { fieldapi: 'Birthdate', fieldtype: 'date', label: 'Birthdate', isEditable: true }
          ];
                                 
  fetchValue1(event){   
    
  var label = event.detail.label;
  var value = event.detail.value;
  console.log('parentlabel',label)
  console.log('parentvalue',value)
 

  this.conToSave[label]=value

  // if(label=='Name'){
  //   this.conToSave.LastName = value;
  // }
  // else if(label=='Email'){
  //   this.conToSave.Email = value;
  // }

    this.conToSave.Phone = '950230713';
    this.conToSave.sObjectType = 'Contact'
    
       
  }
  
   


  onSave(){
   
    console.log('calling from save ========',this.conToSave)
  
     insertConData({con : this.conToSave })
     .then(()=>{
       this.dispatchEvent(
         new ShowToastEvent({
           title : 'sucess',
           message : 'contact created',
           variant : 'success',
         }),
       );
     });

  }

  
}