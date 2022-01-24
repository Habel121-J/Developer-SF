import { LightningElement,track, wire } from 'lwc';
import fetchState from '@salesforce/apex/FetchListingState.fetchState';
//import getListing from '@salesforce/apex/PaginationController.getListing';



export default class   extends LightningElement {
 
    @track listrecs;
    @track img;
    name;
    listingdata;

    handleLocation(event){
    if(event.target.label == 'Your Trip Location')
    this.name=event.target.value;
    console.log('name',this.name)   
    }
      
    
    handleSearch(){
        console.log('go click')
        fetchState({lstStateName: this.name})
        .then(result =>{
          this.listrecs = result; 
          console.log('list data',this.listrecs)
            
            })

            
        }


      
    
 







}