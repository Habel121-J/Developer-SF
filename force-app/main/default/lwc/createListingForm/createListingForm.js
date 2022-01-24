import { LightningElement, track, api } from 'lwc';
import getCategoryPickList from '@salesforce/apex/CreateListingForm.getCategoryPickList';
import getDurationPickList from '@salesforce/apex/CreateListingForm.getDurationPickList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getStateList from '@salesforce/apex/CreateListingForm.getStateList';
import getStatusList from '@salesforce/apex/CreateListingForm.getStatusList';
import insertList from '@salesforce/apex/CreateListingForm.insertList';
const MAX_FILE_SIZE = 100000000; //10mb  


export default class createListingForm extends LightningElement {

    @api recordId;
    @track categoryPL;
    @track durationPL;
    @track statePL;
    @track statusPL;

    uploadedFiles = []; file; fileContents; fileReader; content; fileName

    connectedCallback() {
        getCategoryPickList()
            .then(result => {
                let opt = [];
                result.forEach(element => {
                    opt.push({
                        label: element,
                        value: element
                    })
                });
                this.categoryPL = opt;

            })

        getDurationPickList()
            .then(result => {
                let opt = [];
                result.forEach(element => {
                    opt.push({
                        label: element,
                        value: element
                    })
                });
                this.durationPL = opt;

            })



        getStateList()
            .then(result => {
                let opt = [];
                result.forEach(element => {
                    opt.push({
                        label: element,
                        value: element
                    })
                });
                this.statePL = opt;

            })



        getStatusList()
            .then(result => {
                let opt = [];
                result.forEach(element => {
                    opt.push({
                        label: element,
                        value: element
                    })
                });
                this.statusPL = opt;
                //    console.log('Map values'+JSON.stringify(this.categoryPL));
            })
    }

    listname;
    category;
    duration;
    street;
    city;
    state;
    zip;
    country;
    status;
    base;
    days;
    price;
    guestMin;
    guestMax;
    items;
    pickup;
    desc;
    whats;
    consd;

    //onchange event for information section
    handlevent(event) {

        if (event.target.label == 'Listing Name') {
            this.listname = event.target.value

        }
        if (event.target.label == 'Category') {
            this.category = event.target.value

        }
        if (event.target.label == 'Duration') {
            this.duration = event.target.value


        }
        console.log('asd', event.target.label)
        if (event.target.label == 'Street') {
            this.street = event.target.value



        }
        if (event.target.label == 'City') {
            this.city = event.target.value


        }
        if (event.target.label == 'State') {
            this.state = event.target.value

        }
        if (event.target.label == 'Zip/Postal Code') {
            this.zip = event.target.value


        }
        if (event.target.label == 'Country') {
            this.country = event.target.value

        }
        if (event.target.label == 'Status') {
            this.status = event.target.value


        }
        if (event.target.label == 'Base Price') {
            this.base = event.target.value


        }
        if (event.target.label == 'Number of Days') {
            this.days = event.target.value


        }
        if (event.target.label == 'Price Per Person') {
            this.price = event.target.value


        }
        if (event.target.label == 'Guest Min Capacity') {
            this.guestMin = event.target.value


        }
        if (event.target.label == 'Guest Max Capacity') {
            this.guestMax = event.target.value


        }
        if (event.target.label == 'Items to Bring') {
            this.items = event.target.value


        }
        if (event.target.label == 'Pick Up Location') {
            this.pickup = event.target.value


        }

    }

    //onchange event for fill out section
    getChange(event) {
        if (event.target.label == 'Description') {
            this.desc = event.target.value
            console.log('desc', this.desc)

        }
        if (event.target.label == 'What\'s Include') {
            this.whats = event.target.value
            console.log('whats', this.whats)

        }
        if (event.target.label == 'Other Considerations') {
            this.consd = event.target.value
            console.log('consider', this.consd)

        }


    }

    //onchange event for file upload
    onFileUpload(event) {
        if (event.target.files.length > 0) {
            this.uploadedFiles = event.target.files;
            this.fileName = event.target.files[0].name;
            this.file = this.uploadedFiles[0];
            if (this.file.size > this.MAX_FILE_SIZE) {
                alert("File Size Can not exceed" + MAX_FILE_SIZE);
            }
        }
    }



    onSaveDetails() {
        console.log('call from save')
        var vals = {};

        vals.Name = this.listname;
        console.log('listname', this.listname)
        vals.Category__c = this.category;
        vals.Duration__c = this.duration;
        vals.Street__c = this.street;
        vals.City__c = this.city;
        vals.State2__c = this.state;
        vals.Zip_Postal_Code__c = this.zip;
        vals.Country__c = this.country;
        vals.Status__c = this.status;
        vals.Price__c = this.base;
        vals.Number_Of_Days__c = this.days;
        vals.Guest_Max__c = this.guestMax;
        vals.Guest_Min_Capacity__c = this.guestMin;
        vals.Items_To_Bring__c = this.item;
        vals.Pick_Up_Location__c = this.pickup;
        vals.Description__c = this.desc;
        vals.Whats__c = this.whats;
        vals.Other_Considerations__c = this.consd;
        console.log('sssssssssss.....')
        console.log('save vals', JSON.stringify(vals));
        console.log('before file reafer')

        this.fileReader = new FileReader();
        console.log('after file reader')
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            let base64 = 'base64,';
            this.content = this.fileContents.indexOf(base64) + base64.length;
            this.fileContents = this.fileContents.substring(this.content);
            console.log('hi')
            insertList();
        });
        const isInputCorrect = [...this.template.querySelectorAll('lightning-input,lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputCorrect) {
            this.fileReader.readAsDataURL(this.file);

            insertList({
                gtList: vals,
                file: encodeURIComponent(this.fileContents),
                fileName: this.fileName
            })
            console.log('insertKsting')
                .then(() => {

                    const toastEvent = new ShowToastEvent({
                        title: 'Record Saved',
                        message: 'Record Saved successfully',
                        variant: 'success',
                    })
                    this.dispatchEvent(toastEvent);
                    [...this.template
                        .querySelectorAll('lightning-input,lightning-combobox')]
                        .forEach((input) => { input.value = ''; });


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

    resetPage() {
        [...this.template
            .querySelectorAll('lightning-input,lightning-combobox,ligihtning-input-rich-text')]
            .forEach((input) => { input.value = ''; });

    }



}