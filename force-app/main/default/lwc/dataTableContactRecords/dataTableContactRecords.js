import { LightningElement, api, wire, track } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import getContactsData from '@salesforce/apex/FetchContacts.getContactsData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import updateCons from '@salesforce/apex/FetchContacts.updateCons';

export default class DataTableContactRecords extends LightningElement {

    @api recordId;
    isedit = false;
    issaved= false;
    @track conList = [];
    @api objectApiName
    @track wiredCons
    currId;
    

    @wire(getContactsData, { accId: '$recordId' })
    wiredContactData(result) {
         
        // console.log('da1ta string', JSON.stringify(result));
        // console.log('da1ta parse', JSON.parse(JSON.stringify(result)));
        // console.log('da1ta data', JSON.stringify(result.data));
        this.wiredCons = result;
        console.log('da1ta', JSON.stringify(result))
        if (result.data) {

            var cons = [];
            cons = result.data;
           // console.log('cons data', JSON.stringify(cons))
            cons.forEach(eles => {
                this.conList.push({
                    Id: eles.Id,
                    Name: eles.Name,
                    Phone: eles.Phone,
                    Email: eles.Email,
                    Department: eles.Department,
                    isedit : false,
                    issaved : false
                })

            });
          
            console.log('cons data', JSON.stringify(this.conList))
        } else if (result.error) {
            console.log(error);
            this.error = result.error;
            this.conList = undefined;

        }   
    }

    handleDelete(event) {
        
        var recId = event.target.value;
        
        deleteRecord(recId)
            .then(() => {
                
                const toastEvent = new ShowToastEvent({

                    title: 'Record Deleted',
                    message: 'Record deleted successfully',
                    variant: 'success',

                })
                this.dispatchEvent(toastEvent);
           
              
            
           
            
            })
            .catch(error => {
                console.log('Unable to delete record due to ' + error.body.message);
            });
        
            return refreshApex(this.wiredCons);
    }
    list;
    handleEdits(event) {
        console.log('sdsd')
        this.currId = event.target.dataset.id;
        console.log('currId :',this.currId)
       this.list=this.conList.find(eles => eles.Id===this.currId);
        this.list.isedit=true;
        this.list.issaved=true;
       
    }

     
    handleChange(event){
      var arry = [];
        var presentId = event.target.dataset.id;
        arry = this.conList.find(eles => eles.Id === presentId);
        
      console.log('temp data from on chagne',JSON.stringify(this.arry));
      
     
      if (event.target.label === 'name') {
        arry.Name = event.target.value;
        
    }
    else if (event.target.label === 'phone') {
        arry.Phone = event.target.value;
    }
    else if (event.target.label === 'email') {
        arry.Email = event.target.value;
    }
    else if(event.target.label === 'department'){
        arry.Department = event.target.value;
    }

    console.log('from onchange list',JSON.stringify(this.conList))
      
        
    }
    
    
    handleSave(){
       console.log('list from save',JSON.stringify(this.conList))
       
       this.conList.isedit=false; 
       this.c
        updateCons({upcon : this.conList})
       console.log('ss')    
           
        .then(() => {
            
                                
                const toastEvent = new ShowToastEvent({
                title:'Record Saved',
                message:'Record Saved successfully',
                variant:'success',
            })
            this.dispatchEvent(toastEvent);
        return  refreshApex(this.result);
                 
             })
              .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.message,
                        variant: 'error',
                    }),                    
         console.log(error)
                );
              });


    }
  


}
