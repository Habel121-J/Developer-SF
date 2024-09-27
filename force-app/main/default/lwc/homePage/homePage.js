import { LightningElement,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import My_Resource from '@salesforce/resourceUrl/myLogo';
import My_Footer from '@salesforce/resourceUrl/ourFuture';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import insertOffering from '@salesforce/apex/SaveOffering.insertOffering';

export default class HomePage extends LightningElement 
{
 
    @track congregtion;
    @track district;    

    nacLogo =   My_Resource;    

    footerPic = My_Footer;
    date;
    offer;
    attendance;
    witness;
    cong;
    dist;

    offeringData = {}
    


    @wire(getPicklistValuesByRecordType, { objectApiName: 'Offerings__c', recordTypeId: '0125i0000006PwBAAU'}) 
    GetCongregationValues({error, data}) {
        if(data) {

            this.congregtion = data.picklistFieldValues.Congregation__c.values;
            console.log("all picklist values "+JSON.stringify(data.picklistFieldValues.Congregation__c.values));

            this.district = data.picklistFieldValues.District__c.values;
        }
        else if(error) {
            window.console.log('error =====> '+JSON.stringify(error));
        }
    }

    handleChange(event){
        if(event.target.label ==='Date'){

            this.date = event.target.value;
            this.offeringData.Date__c = this.date;
            console.log('date+++ ',event.target.value);
        }
        else if(event.target.label ==='Offering'){
            this.offer = event.target.value;
            this.offeringData.Offering__c = this.offer;
            console.log('offer+++ ',this.offer);
        }
        else if(event.target.label ==='District'){
            console.log('inside district',event.target.value);
            this.dist = event.target.value;
            this.offeringData.District__c = this.dist;
            validateDate();
            console.log('district+++ ',this.dist);       
        }
        else if(event.target.label ==='Total Attendance'){
            this.attendance = event.detail.value;
            this.offeringData.Total_Attendance__c = this.attendance;
            console.log('attendance+++ ',this.attendance);
        }
        else if(event.target.label ==='Witness Name'){
            this.witness = event.target.value;
            this.offeringData.Witness_Name__c = this.witness;
            console.log('witness+++ ',this.witness);
        }
        else if(event.target.label ==='Congregation'){
            console.log('inside coogeraetion',event.target.value);
            this.cong = event.target.value;
            this.offeringData.Congregation__c = this.cong;
            console.log('cong+++ ',this.cong);
        }


    }

    validateDate(){
        console.log(this.date,'from inside validate date');

    }
    toastEventFire(title,msg,variant,mode)
    {
        const e = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(e);
    }  
    
    handleCancel() {
        console.log('inside handlecancel')
        this.template.querySelectorAll('lightning-input').forEach(each => {
            each.value = '';
        });
        this.template.querySelectorAll('lightning-combobox').forEach(each => {
            each.value = '';
        });
    }    

    handleSave(){
        console.log('inside handlesave');
        console.log('offering data',this.offeringData);
        
        insertOffering({ off : this.offeringData})
        .then(result =>{
            
            this.cong='';
            this.witness='';
            this.attendance='';
            this.dist='';
            this.offer = '';
            this.date = '';
            console.log('db offering data',this.offeringData);

            this.toastEventFire('Success','Offering Reciept is Saved','success')                      
        })
        .catch(error =>{
            this.error = error.message;
            alert(JSON.stringify(error))
        })
    }



    
}