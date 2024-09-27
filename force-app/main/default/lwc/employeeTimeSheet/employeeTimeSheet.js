import { LightningElement } from 'lwc';


const columns = [{ title: '', label: '', date: '' },
{ title: 'Project', label: 'Project', date: '' },
{ title: 'Task', label: 'Task', date: '' },
{ title: 'Monday', label: 'Monday' },
{ title: 'Tuesday', label: 'Tuesday' },
{ title: 'Wednesday', label: 'Wednesday' },
{ title: 'Thursday', label: 'Thursday' },
{ title: 'Friday', label: 'Friday' }]

export default class EmployeeTimeSheet extends LightningElement {

headerLabels = columns

}