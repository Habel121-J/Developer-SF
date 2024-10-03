import { LightningElement, wire } from 'lwc';
import fieldDefitions from '@salesforce/apex/MetadataEditorHelper.fieldDefitions'
import fetchMdtRecords from '@salesforce/apex/MetadataEditorHelper.fetchMdtRecords'
import fetchMetaObjects from '@salesforce/apex/MetadataEditorHelper.fetchMetaObjects'
import createMdtRecords from '@salesforce/apex/MetadataEditorHelper.createMdtRecords'

export default class MetadataEditor extends LightningElement {

    metaOptions;
    columns = [];
    tableData = [];
    isShowModal = false;
    inputCols = [];
    mdtName = ''

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
    Label=''
    handleInputChange(event) {
        if(event.target.label =='Label'){
            this.Label  = event.target.value;
            console.log('label',this.Label)

        }else{
            this.obj[event.target.dataset.field] = event.target.type =='checkbox' ? event.target.checked : event.target.value;
            console.log('ibj', JSON.stringify(this.obj))
        }

       
    }

    async handleCreateNew(){
        this.mdtName = this.template.querySelector('lightning-combobox').value;
        let obj = JSON.stringify(this.obj);
        let Label = this.Label;
        await createMdtRecords({mdtName: this.mdtName, Label : Label, fieldValues : obj}).then(result =>{
            console.log('inside create resut',result);

        })

        
        

    }
    

    async handleCreateButton() {
        this.isShowModal = !this.isShowModal
        let apiName = this.template.querySelector('lightning-combobox').value;
        await this.buildColumns(apiName);


    }
    hideModalBox() {
        this.isShowModal = !this.isShowModal;
    }
    async handleChange(event){
        try {
            let mdtObj = event.target.value
            await this.buildColumns(mdtObj);
            await fetchMdtRecords({mdtName: mdtObj}).then(result => {
            this.tableData = result;
            })
        } catch (error){
            console.log('errrrrrrrrrr----', error);
        }
    }

    isOnce = true
    handleSave() {
        if (this.isOnce) {
            this.isOnce = false;
            let AddLabel = { label: 'Status', fieldName: 'Status', type: "text", "editable": false };
            this.columns = [AddLabel, ...this.columns];
        }

    }

    async buildColumns(mdtObj) {
        var columnsToHide = ['Id', 'Label', 'NamespacePrefix', 'SystemModstamp', 'Language', 'NamespacePrefix', 'DeveloperName', 'QualifiedApiName'];
        let tempCols = []
        let inputCols = []
        try {
            await fieldDefitions({mdtName: mdtObj}).then(result => {
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