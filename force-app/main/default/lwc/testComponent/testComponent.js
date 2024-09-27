import { LightningElement, api, wire} from 'lwc';
import getContacts from '@salesforce/apex/AccountTriggerHandler.getContacts';


export default class TestComponent extends LightningElement {
    @api recordId;


    @wire(getContacts,{recordId : '$recordId'})
    wiredContacts(result){
        console.log('result',result)
    }

    connectedCallback(){

        console.log('recordId', this.recordId)
    }
}