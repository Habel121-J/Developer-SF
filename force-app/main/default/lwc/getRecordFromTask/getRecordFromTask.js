import { LightningElement, wire, api, track } from 'lwc';
import getDetails from '@salesforce/apex/GetDetailsFromTask.getDetails';
import { getRecord } from 'lightning/uiRecordApi';
import ASSIGNED_TO_FIELD from '@salesforce/schema/Task.OwnerId';
import SUBJECT_FIELD from '@salesforce/schema/Task.Subject';
import DUE_DATE_FIELD from '@salesforce/schema/Task.ActivityDate';
import PRIORITY_FIELD from '@salesforce/schema/Task.Priority';
import STATUS_FIELD from '@salesforce/schema/Task.Status';
import NAME_FIELD from '@salesforce/schema/Task.WhoId';
import RELATED_TO_FIELD from '@salesforce/schema/Task.WhatId';
import COMMENTS_FIELD from '@salesforce/schema/Task.Description';
export default class GetRecordFromTask extends LightningElement {
  @track data;
  @track columns = [
    { label: 'Assigned To', fieldName: 'OwnerId', type: 'Lookup' },
    { label: 'Subject', fieldName: 'Subject', type: 'Picklist' },
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'Date' },
    { label: 'Priority', fieldName: 'Priority', type: 'Picklist' },
    { label: 'Status', fieldName: 'Status', type: 'Picklist' },
    { label: 'Name', fieldName: 'WhoId', type: 'Lookup' },
    { label: 'Related To', fieldName: 'WhatId', type: 'Lookup' },
    { label: 'Comments', fieldName: 'Description', type: 'Long Text Area' },
  ];
  @wire(getDetails) accountRecords({ error, data }) {
    if (data) {
      this.data = data;
    }
    else if (error) {
      this.data = undefined;
    }
  }
}