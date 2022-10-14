import { LightningElement } from 'lwc';

export default class FilterBar extends LightningElement {
  statusValue = 'inProgress';

  get statusOptions() {
      return [
          { label: 'In Progress', value: 'inProgress' },
          { label: 'Completed', value: 'completed' },
      ];
  }

  handleChange(event) {
    this.statusValue = event.detail.value;
  }
}