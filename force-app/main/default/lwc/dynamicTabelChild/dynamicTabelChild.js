import { LightningElement, api } from 'lwc';

export default class DynamicTabelChild extends LightningElement {

    @api fldApi;
    @api fldType;
    @api fldLabel;
    @api isEdit;


    get isText() {
        return this.fldType === 'text';
    }
    get isPhone() {
        return this.fldType === 'number';
    }
    get isEmail() {
        return this.fldType === 'email';
    }
    get isText() {
        return this.fldType === 'text';
    }
    get isDate() {
        return this.fldType === 'date'
    }
    connectedCallback() {

        console.log('from-child', JSON.stringify(this.isEdit))

    }

    handleChange(event) {

        var cons = {};
        cons.label = event.target.label;
        cons.value = event.target.value;
        console.log('fromchildhandle====', cons.label)
        console.log('fromchildhandle====', cons.value)



        const selectedEvent = new CustomEvent('passdata1', {
            detail: cons
        });
        this.dispatchEvent(selectedEvent);
    }


}