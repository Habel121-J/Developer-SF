import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
//import Sample_Css from '@salesforce/resourceUrl/SampleCard';


export default class OfferingForm extends LightningElement {

    
    // renderedCallback() {
        
    //     Promise.all([
    //         loadStyle( this, Sample_Css )
    //         ]).then(() => {
    //             console.log('Files');
    //         })
    //         .catch(error => {
    //             console.log( error.body.message );
    //     });

    // }
        

    handlechange(event){
        console.log(event.target.value);
        
    }
}