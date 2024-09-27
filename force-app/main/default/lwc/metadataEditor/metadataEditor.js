import { LightningElement, wire } from 'lwc';
import fieldDefitions from '@salesforce/apex/MetadataEditorHelper.fieldDefitions'
import fetchMdtRecords from '@salesforce/apex/MetadataEditorHelper.fetchMdtRecords'
import fetchMetaObjects from '@salesforce/apex/MetadataEditorHelper.fetchMetaObjects'
import createMdtRecords from '@salesforce/apex/CustomMetadata_Services.createMdtRecords'
import checkStatusForNew from '@salesforce/apex/CustomMetadata_Services.checkStatusForNew'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'


export default class MetadataEditor extends LightningElement {

    metaOptions;
    columns = [];
    tableData = [];
    isShowModal = false;
    inputCols = [];
    mdtName = ''
    titleText
    variant
    titleText


    // picklist values for combobox
    @wire(fetchMetaObjects)
    wiredResult({ data, error }) {
        if (data) {
            this.metaOptions = data;
        } else if (error) {
            console.log('error---');
        }
    }

    obj = {}
    masterLabel = ''
    handleInputChange(event) {
        if (event.target.label == 'Label') {
            this.masterLabel = event.target.value;
            console.log('label', this.masterLabel)

        } else {
            this.obj[event.target.dataset.field] = event.target.type == 'checkbox' ? event.target.checked : event.target.value;
            console.log('ibj', JSON.stringify(this.obj))
        }


    }

    async handleCreateNew() {
        let inputFields = this.template.querySelectorAll('lightning-input');
        for (let f of inputFields) {
            if (!f.checkValidity()) {
                f.reportValidity();
                return;
            }

        }
        let jobId;
        this.mdtName = this.template.querySelector('lightning-combobox').value;
        let obj = JSON.stringify(this.obj);
        let masterLabel = this.masterLabel;
        await createMdtRecords({ mdtName: this.mdtName, Label: masterLabel, fieldValues: obj }).then(result => {
            jobId = result;


        })
        let newData = JSON.parse(obj)
        newData.MasterLabel = masterLabel;
        // console.log('tabledata', [...this.tableData, newData])
        this.tableData = [...this.tableData, newData];
        this.isShowModal = !this.isShowModal;
        var result = {}
        try {
            for (let i = 0; i <= 30; i++) {
                result = await this.checkDeployStatus(jobId)
                console.log('result: ', JSON.stringify(result))
                if (result.status.toLowerCase() === 'pending' || result.status.toLowerCase() === 'inprogress') {
                    this.titleText = 'Deployment In Progress'
                    this.variant = 'info'
                    this.messageText = 'The deployment job has been queued for execution.'
                    this.showNotification()
                    continue;
                } else if (result.status.toLowerCase() === 'succeeded') {
                    this.titleText = 'Deployment successful'
                    this.variant = 'success'
                    this.messageText = 'The deployment successful.'
                    this.showNotification();
                    break;


                } else if (result.status.toLowerCase() === 'failed') {
                    this.titleText = 'Deployment failed'
                    this.variant = 'error'
                    this.messageText = 'The deployment job has failed due to ' + result.errorMessage
                    this.showNotification()
                    break;
                }


            }

        } catch (error) {
            console.log('errorr---', error);
        }


    }


    showNotification() {
        const evt = new ShowToastEvent({
            title: this.titleText,
            message: this.messageText,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }


    async handleCreateButton() {
        this.isShowModal = !this.isShowModal
        let apiName = this.template.querySelector('lightning-combobox').value;
        await this.buildColumns(apiName);


    }
    hideModalBox() {
        this.isShowModal = !this.isShowModal;
    }
    async handleChange(event) {
        try {
            let mdtObj = event.target.value
            await this.buildColumns(mdtObj);
            await fetchMdtRecords({ mdtName: mdtObj }).then(result => {
                this.tableData = result;
            })
        } catch (error) {
            console.log('errrrrrrrrrr----', error);
        }
    }

    async checkDeployStatus(jobId) {
        let deployResult = {}
        await checkStatusForNew({ jobId: jobId }).then(result => {
            console.log('status result----- ', result);
            deployResult = result

        }).catch(error => {
            console.log('errrrrrrrrrr from catch----', error);
        })

        return deployResult;

    }


    async handleSave(event) {
        let isOnce = true
        let editRecords = event.detail.draftValues;
        let recIds = editRecords.map(ele => ele.Id)
        this.tableData = this.tableData.map(ele => {
            if (recIds.includes(ele.Id)) {
                return { ...ele, Status: 'SAVING' }
            } else {
                return ele
            }
        })
        console.log('tableData ALL SAVE', this.tableData)

        let mdtName = this.template.querySelector('lightning-combobox').value;
        console.log('draft values--->', JSON.stringify(editRecords))

        if (isOnce) {
            isOnce = false;
            this.columns = [{ label: 'Status', fieldName: 'Status', type: "text",
                cellAttributes: {
                class: { fieldName: 'textColor' },
            }, typeAttributes: { linkify: true }, "editable": false }, ...this.columns];
        }



        try {
            let jobId
            var result = {}
            for (let item of editRecords) {
                console.log('edit recfromTabel', item);
                let record = this.tableData.find(ele => ele.Id == item.Id);
                console.log('record---->', record);
                await createMdtRecords({ mdtName: mdtName, Label: record.Label, fieldValues: JSON.stringify(item) }).then(result => {
                    jobId = result
                    console.log('result---->', result);

                }).catch(error => {
                    console.log('errrrrrrrrrr from created records----', error);
                })



                for (let i = 0; i <= 30; i++) {
                    let tempData = []
                    result = await this.checkDeployStatus(jobId)
                    if (result.status.toLowerCase() === 'inprogress' || result.status.toLowerCase() === 'pending') {
                        tempData = this.tableData.map(ele => {
                            return ele.Id == item.Id ? { ...ele, Status: 'SAVING' } : ele

                        })
                        this.tableData = tempData

                    } else if (result.status.toLowerCase() === 'succeeded') {
                        tempData = this.tableData.map(ele => {
                            return ele.Id == item.Id ? { ...ele, Status: 'SAVED', textColor: 'slds-text-color_success'  } : ele

                        })
                        this.tableData = tempData
                        break



                    } else if (result.status === 'failed') {
                        tempData = this.tableData.map(ele => {
                            return ele.Id == item.Id ? { ...ele, Status: `Failed ${result.errorMessage}` ,textColor : 'slds-text-color_error' } : ele

                        })
                        this.tableData = tempData

                    }
                }

            }


        } catch (error) {
            console.log('error--->', error.message);
        }




    }

    async buildColumns(mdtObj) {
        var columnsToHide = ['Id', 'Label', 'NamespacePrefix', 'SystemModstamp', 'Language', 'NamespacePrefix', 'DeveloperName', 'QualifiedApiName'];
        let tempCols = []
        let inputCols = []
        try {
            await fieldDefitions({ mdtName: mdtObj }).then(result => {
                if (result) {
                    result.forEach(ele => {
                        if (!columnsToHide.includes(ele.fieldApiName)) {
                            tempCols.push({
                                label: ele.fieldLabel,
                                fieldName: ele.fieldApiName,
                                type: ele.type.toLowerCase(),
                                editable: ele.fieldLabel == 'Label' ? false : ele.isEditable,
                                required: !ele.isNillable,
                                displayReadOnlyIcon: ele.fieldLabel == 'Label' ? true : false
                            })

                            inputCols.push({
                                label: ele.fieldLabel,
                                fieldName: ele.fieldApiName,
                                required: !ele.isNillable,
                                type: ele.type == 'BOOLEAN' ? 'checkbox' : ele.type.toLowerCase()


                            })

                        }

                    })
                }

            })
            this.columns = tempCols;
            this.inputCols = inputCols;
        } catch (error) {
            console.log('error----', error);
        }

    }
}