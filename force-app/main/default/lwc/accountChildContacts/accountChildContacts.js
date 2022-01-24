import { LightningElement,api } from 'lwc';

export default class AccountChildContacts extends LightningElement {
   
    @api listData
     
    
    
    
    connectedCallback(){
        console.log('datachild from child ',JSON.stringify(this.listData))
    }
}   