import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ID_FIELD from '@salesforce/schema/Account.Id';
import Industry from '@salesforce/schema/Account.Industry';
import Phone from '@salesforce/schema/Account.Phone';
import Mail__c from '@salesforce/schema/Account.Mail__c';
import Site__c from '@salesforce/schema/Account.Site__c'
import SLAExpirationDate__c from '@salesforce/schema/Account.SLAExpirationDate__c';
import getAccountsData from '@salesforce/apex/GetAccounts.getAccountsData';

export default class CreateForm extends LightningElement {
    @track Buttontrue = true;
    @api recordId;
    @track today;
    @track falseEvent = false;
    result;
    industry;
    phone;
    site;
    mail;
    expiry;

    value1 = '';
    value2 = '';
    value3 = '';
    value4 = '';
    value5 = '';

    @wire(getAccountsData, { accId: '$recordId' })
    wiredAccounts({ data, error }) {
        if (data) {
            console.log('data', data);
            this.result = data[0];
            this.industry = this.result.Industry;
            this.phone = this.result.Phone;
            this.site = this.result.Site__c;
            this.mail = this.result.Mail__c;
            this.expiry = this.result.SLAExpirationDate__c;

        } else if (error) {
            console.log(error);
            this.error = result.error;
            this.data = undefined;

        }
    }

    handleChange(event) {

        if (event.target.label == 'Industry') {
            this.value1 = event.target.value;
            console.log(this.value1)
        }
        else if (event.target.label == 'Phone') {
            this.value2 = event.target.value;
        }
        else if (event.target.label == 'Site') {
            this.value3 = event.target.value;
        }
        else if (event.target.label == 'Mail')
            this.value4 = event.target.value;

    }

    handleChangeDate(event) {

        var d = new Date();
        this.today = (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear();
        if (event.target.label == 'SLA Expiration Date') {
            this.value5 = event.target.value;

        }

    }
    editForm() {

        this.Buttontrue = false;
        this.falseEvent = false;

    }
    resetForm() {


        this.Buttontrue = true;
        this.falseEvent = true;


    }

    handleSave() {
        if (this.Buttontrue == false) {

            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            console.log('>>>>>', this.recordId)
            fields[Industry.fieldApiName] = this.value1;
            fields[Phone.fieldApiName] = this.value2;
            fields[Site__c.fieldApiName] = this.value3;
            fields[Mail__c.fieldApiName] = this.value4;
            fields[SLAExpirationDate__c.fieldApiName] = this.value5;

            console.log('retyuio[p')

            const recordInput = {
                fields: fields
            };
            updateRecord(recordInput)
                .then(() => {
                    console.log('prasanna')
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Details Added Successfully',
                            variant: 'success',
                        }),
                    );




                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });

        }
    }
}