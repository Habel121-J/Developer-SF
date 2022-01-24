import { LightningElement } from 'lwc';
import saveCaseDetails from '@salesforce/apex/caseDetailsApexClass.saveCaseDetails';
import sendMails from '@salesforce/apex/caseDetailsApexClass.sendMails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CaseDetails extends LightningElement {
    Name = '';
    Email = '';
    Phone = '';
    Subject = '';
    Description = '';
    values = {};

    getDetails(event) {
        console.log(event.target.label);
        console.log(event.target.value);

        if (event.target.label == 'Name') {
            this.Name = event.target.value;
        }
        if (event.target.label == 'Email') {
            this.Email = event.target.value;
        }
        if (event.target.label == 'Phone') {
            this.Phone = event.target.value;
        }
        if (event.target.label == 'Subject') {
            this.Subject = event.target.value;
        }
        if (event.target.label == 'Description') {
            this.Description = event.target.value;
        }
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.values[inputField.name] = inputField.value;
        });
        return isValid;
    }


    submitDetails() {
        console.log('on send')

        this.values.Name = this.Name;
        this.values.Email = this.Email;
        this.values.Phone = this.Phone;
        this.values.Subject = this.Subject;
        this.values.Description = this.Description;
        this.values.SobjectType = 'Case';
        if (this.isInputValid()) {
            console.log('valid ', this.values);
            saveCaseDetails({ CaseDetails: this.values })
                .then(() => {
                    console.log("the values ", this.values);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'we got your meassge..! we will get back to you',
                            variant: 'success',
                        }),
                    );
                    [...this.template
                        .querySelectorAll('lightning-input, lightning-textarea')]
                        .forEach((input) => { input.value = ''; });
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.message,
                            variant: 'error',


                        }),

                    ); 
                });


            sendMails({ NAME: this.Name, EMAIL: this.Email, PHONE: this.phone, SUBJECT: this.Subject, DESCRIPTION: this.Description })
                .then(result => {
                    console.log('result  ', result);

                })
                .catch(error => {
                    console.log(error);
                    this.error = error;
                    this.contacts = undefined;
                });

        }


    }
}