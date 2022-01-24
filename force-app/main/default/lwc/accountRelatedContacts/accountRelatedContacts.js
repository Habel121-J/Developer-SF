import { LightningElement,api,track, wire } from 'lwc';
import fetchAccount from '@salesforce/apex/FetchAccountDetails.fetchAccount';
import fetchAccountRelatedContact from '@salesforce/apex/FetchAccountDetails.fetchAccountRelatedContact';


export default class AccountRelatedContacts extends LightningElement {

    @track columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name'},
        { label: 'Industry', fieldName: 'Industry'},
        { label: 'Website', fieldName: 'Website'},
        { label: 'Phone', fieldName: 'Phone'},
        { label: 'SLAExpirationDate__c', fieldName: 'SLAExpirationDate__c'}
    ];    
    
    @api recordId;
    @track accList = [];
    @api conData = [];
    
    
    

    connectedCallback(){

        fetchAccount({accId : this.recordId})
        .then(result=>{
            this.accList =  result;
            console.log('test');
            console.log('data from parent ',JSON.stringify(this.accList))
        })
        .catch(error=>{
            this.error = error;
        })
        
      fetchAccountRelatedContact({acId : this.recordId})
      .then(result=>{
        this.conData = result;
        console.log('condata from parent ',JSON.stringify(this.conData))
          
      })
      .catch(error=>{
          this.error =error;
      })
   
    }

     
    
}