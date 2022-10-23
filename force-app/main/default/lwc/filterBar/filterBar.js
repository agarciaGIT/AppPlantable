import { LightningElement } from 'lwc';

export default class FilterBar extends LightningElement {
  statusValue = 'inProgress';

  get statusOptions() {
      return [
          { label: 'In Progress', value: 'inProgress' },
          { label: 'Completed', value: 'completed' },
      ];
  }
  
  get riskBucketOptions() {
      return [
          { label: 'Buy-Side', value: 'Buy-Side' },
          { label: 'Climate', value: 'Climate' },
          { label: 'Leverage', value: 'Leverage' },
          { label: 'Liquidity', value: 'Liquidity' },
          { label: 'Resiliency', value: 'Resiliency' },
          { label: 'Total Capital', value: 'Total Capital' },
          { label: 'Trading Book', value: 'Trading Book' },
          { label: 'Other', value: 'Other' }
      ];
  }
  
  get riskTypesOptions() {
      return [
        { label: 'Central Counterparties', value: 'Central Counterparties' },
        { label: 'Climate Risk', value: 'Climate Risk' },
        { label: 'Counterparty Credit Risk', value: 'Counterparty Credit Risk' },
        { label: 'CVA', value: 'CVA' },
        { label: 'FRTB', value: 'FRTB' },
        { label: 'Leverage Ratio', value: 'Leverage Ratio' },
        { label: 'Liquidity Risk', value: 'Liquidity Risk' },
        { label: 'Market Risk', value: 'Market Risk' },
        { label: 'Merchant Banking', value: 'Merchant Banking' },
        { label: 'Net Stable Funding', value: 'Net Stable Funding' },
        { label: 'Third-Party', value: 'Third-Party' },
        { label: 'Total Capital', value: 'Total Capital' },
        { label: 'Other', value: 'Other' }
      ];
  }
  
  get coverageOptions() {
      return [
        { label: 'Canada', value: 'Canada' },
        { label: 'Europe', value: 'Europe' },
        { label: 'Global', value: 'Global' },
        { label: 'North America', value: 'North America' },
        { label: 'Scandinavia', value: 'Scandinavia' },
        { label: 'US', value: 'US' }
      ];
  }
  
  get yearsOptions() {
      return [
        { label: '2021', value: '2021' },
        { label: '2020', value: '2020' },
        { label: '2019', value: '2019' },
        { label: '2018', value: '2018' },
        { label: '2017', value: '2017' },
        { label: '2016', value: '2016' },
        { label: '2015', value: '2015' }
      ];
  }

  handleChangeStatusOptions(event) {
    this.statusValue = event.detail.value;
  }
  handleChangeRiskBucketOptions(event) {
    this.riskBucketValue = event.detail.value;
  }
  handleChangeRiskTypesOptions(event) {
    this.riskTypesValue = event.detail.value;
  }
  handleChangeCoverageOptions(event) {
    this.coverageValue = event.detail.value;
  }
  handleChangeYearsOptions(event) {
    this.yearsValue = event.detail.value;
  }
}