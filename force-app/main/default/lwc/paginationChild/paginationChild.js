import { LightningElement,api} from 'lwc';

export default class PaginationChild extends LightningElement {
    
    totalRecords
    recordSize = 5
    get records(){
        return this.visibleRecords
    }

    @api 
    set records(data){
        this.totalRecords = data
        console.log('ss',JSON.stringify(this.totalRecords))
        this.visibleRecords = data.slice(0,this.recordSize)
        this.totalPage = Math.ceil(data.length/this.recordSize)
        this.updateRecords() 

    }

    previousHandler(){


    }
    
    nextHandler(){

    }
    updateRecords(){
        this.dispatchEvent(new CustomEvent('update', { 
            detail : {
                records:this.visibleRecords

            }
        }))
    }
}