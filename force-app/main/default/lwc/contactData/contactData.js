import { LightningElement, api, wire } from 'lwc';
import getAccCons from '@salesforce/apex/GetAccountRelatedContacts.getAccCons';
import unassignContact from '@salesforce/apex/GetAccountRelatedContacts.unassignContact';
import searchCons from '@salesforce/apex/GetAccountRelatedContacts.searchCons';
import createContact from '@salesforce/apex/GetAccountRelatedContacts.createContact';
import updateContact from '@salesforce/apex/GetAccountRelatedContacts.updateContact';
import dynamicFields from '@salesforce/apex/GetAccountRelatedContacts.dynamicFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'


var columns = [
    { label: 'Name',  fieldName: 'Name', type: 'text'},
    { label: 'Title', fieldName: 'Title', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'text' }



];

export default class ContactDetails extends NavigationMixin(LightningElement) {

    @api recordId;
    @api Fields;
    @api objName;
    columns = columns;
    openModal = false;
    openContactForm = false;
    conData = [];
    showFoot = true;
    searchquery = '';
    newCon = {};
    searchResults = [];
    dataTable = [];
    isSearch = false;
    checkRows = [];
    isAdd = false;
    isCreate = true;
    noData = false;
    dynamicCols = [];
    showDyanmic;

        //Records dsiplay based on query search
        ShowTable = false;

    connectedCallback() {

        console.log('objname',this.objName);
        dynamicFields({fields:this.Fields,objName:this.objName})
        .then(result =>{
                 console.log('resut',result);
                this.showDyanmic = result.length>0;
                this.dynamicCols = result

        }).catch(error =>{
            console.log('errror',error);
        })
       
    }

    handleFocus(event){
        this.isCreate = event.target.label === 'Add Existing';
        this.dataTable = [];
        this.ShowTable = false;

    }   
    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
            
        }));
    }
    hanldeAddOrCreate(event){
        if(event.target.title==='Add'){
            let selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
            this.conData = [...this.conData, ...selectedRecords];
            this.openModal = false;
            updateContact({recordId: this.recordId, conList: selectedRecords})
            .then(result =>{
                this.showToast('Added successfully!', 'Contact linked succesfully', 'success');
            }).catch(err =>{
                this.showToast('Error while adding','Unable to link contact!','error');
            }) 
        }
        else if(event.target.title==='Create'){ 
            if (this.checkValidation()) {
                console.log('inisde if ');
                this.openModal = false;
                this.newCon.AccountId = this.recordId;
                createContact({ newcon: this.newCon, recordId: this.recordId})
                .then(result => {
                    this.showToast('Added successfully!', 'Contact linked succesfully', 'success');
                    this.conData = [...this.conData, result];
                    this.newCon = {};
                    console.log('new con----', JSON.stringify(this.newCon));
                })
                .catch(error => {
                    console.log('erorr', JSON.stringify(error.message()));

                })
    
            }
        }
    }

     @wire(getAccCons, { recordId: '$recordId' })
        contactData({ data, error }) {
        if (data) {
            this.conData = data;
        } else if (error) {
        }
    }

    handleUnassign(event) {
        let conId = event.currentTarget.dataset.id;
        let contact = {
            'SObjectType': 'Contact',
            'Id': event.currentTarget.dataset.id,
            'AccountId': null
        };
        unassignContact({ cont: contact })
            .then(result => {
                let newArr = this.conData.filter(c => (c.Id != conId));
                this.conData = newArr;
            }).catch(error => {
        })
    }
    handleOpenModal() {

        this.openModal = true;

    }

    handleCloseModal() {
        this.openModal = false;
        this.openContactForm = false;
        this.ShowTable = [];
    }

    openForm() {
        this.openContactForm = true;
    }

    handleChange(event) {
        if (event.target.label === 'LastName') {
            this.newCon.LastName = event.target.value;

        }
        if (event.target.label === 'FirstName') {
            this.newCon.FirstName = event.target.value;

        }
        if (event.target.label == 'Title') {
            this.newCon.Title = event.target.value;
        }

        if (event.target.label == 'Email') {
            this.newCon.Email = event.target.value;
        }

    }

    checkValidation() {

        console.log('inside check validity');
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        console.log('inside check validity fields', inputFields);
        inputFields.forEach(element => {
            console.log('inside for each', element.checkValidity());
            if (!element.checkValidity()) {
                element.reportValidity();
                isValid = false;
            }


        });

        return isValid;
    }
    searchKeyword(event) {
        let searchTerm = event.target.value;
        if(searchTerm.length >= 3){
            searchCons({ searchterm : searchTerm, Id : this.recordId})
            .then(result => {
                this.searchResults = result;
                this.isSearch = this.searchResults.length >= 0;
                
                this.noData = this.searchResults.length == 0;
            }).catch(err => {
                console.log('error', JSON.stringify(err.message))
            })
        }else if(searchTerm.length === 0 || searchTerm.length < 3){
            console.log('clear dropdown');
            this.isSearch = false;
            this.noData = false;
        }
                
    }

    allIds = [];
    handleSelectedItem(event) {
      
        console.log('inside drop down');
        let selectedId = event.currentTarget.dataset.id;
        this.isSearch = false;
        let selectedItem = this.searchResults.find(ele => ele.Id === selectedId)
        console.log('temp Array', selectedItem);
        
        this.ShowTable = true;
        this.checkRows = [...this.checkRows,selectedId];
            this.dataTable = [selectedItem];
            this.allIds.push(selectedId);
            console.log('this datatable',this.dataTable);
           if(!this.allIds.includes(selectedId)){
            this.dataTable = [...this.dataTable,selectedItem];
            this.allIds.push(selectedId);
        }else{
            console.log('Cannot add duplicates');
        }   
        console.log('dataTable--', JSON.stringify(this.dataTable));
        this.template.querySelector('lightning-input[data-id="clear"]').value = null; 
       
    }
    handleSearchBlur() {
        setTimeout(() => {
            this.isSearch = false;
        }, "500");
    }

    handleTabChange(){

        console.log('inside tab change');
        // this.isCreate = false;
        this.isAdd = true;
    }



    navigateToContact(evt) {
        let Id = evt.currentTarget.dataset.id;
        console.log('inside id ', Id);


        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: 'Contact',
                actionName: 'view',

            },
        });

    }
}