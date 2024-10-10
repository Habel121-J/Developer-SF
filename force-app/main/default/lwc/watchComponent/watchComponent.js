import { LightningElement } from 'lwc';

export default class WatchComponent extends LightningElement {

    timeNow;

    timeNow = 'asdaskdj'






    
    get timeComponent(){


        return `${this.timeNow}`;
    }




}