import { LightningElement, track, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['job_application__c.Salary__c'];

const medicareRate = 0.0145;
const socialSecurityRate = 0.0620;

// Define federal tax brackets and rates
const federalTaxBrackets = [
    { min: 0,       max: 10275,     rate: 0.10 },
    { min: 10276,   max: 41775,     rate: 0.12 },
    { min: 41776,   max: 89075,     rate: 0.22 },
    { min: 89076,   max: 170050,    rate: 0.24 },
    { min: 170051,  max: 215950,    rate: 0.32 },
    { min: 215951,  max: 539900,    rate: 0.35 },
    { min: 539901,  max: Infinity,  rate: 0.37 }
];

const standardSingleDeduction = 13850.00;

export default class TakeHomePayCalculator extends LightningElement {
    @api recordId;

    @track income = 0;
    @track taxableIncome = 0;
    @track takeHomePay = 0;
    @track semiAnnualPay = 0;
    @track monthlyPay = 0;
    @track biWeeklyPay = 0;
    @track federalWithholding = 0;
    @track yearlyPay = 0;
    @track socialSecurityWithholding = 0;
    @track medicareWithholding = 0;
    @track salaryDeductions = 0;
    
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.income = data.fields.Salary__c.value;
            // console.log('***income:', this.income);
            this.handleCalculate();
        } else if (error) {
            console.error('***Error loading record', error);
        }
    }

    handleCalculate() {
        // Calculate the Take Home Pay
        this.federalWithholding = this.calculateFederalTax().toFixed(2);
        this.taxableIncome = this.income > standardSingleDeduction ? this.income - standardSingleDeduction : this.income;
        this.medicareWithholding = this.income * medicareRate;
        this.socialSecurityWithholding = (this.income * socialSecurityRate).toFixed(2);
        // console.log('***this.federalWithholding: ',this.federalWithholding);
        // console.log('***this.medicareWithholding: ',this.medicareWithholding);
        // console.log('***this.socialSecurityWithholding: ',this.socialSecurityWithholding);
        this.salaryDeductions = this.federalWithholding - this.medicareWithholding - this.socialSecurityWithholding;
        this.salaryDeductions = this.salaryDeductions < 0 ? this.salaryDeductions * -1 : this.salaryDeductions;

        // console.log('***this.salaryDeductions: ',this.salaryDeductions);
        this.takeHomePay = (this.income - this.salaryDeductions).toFixed(2);
        this.semiAnnualPay  = (this.takeHomePay / 2).toFixed(2);
        this.monthlyPay     = (this.takeHomePay / 12).toFixed(2);
        this.biWeeklyPay    = (this.takeHomePay / 26).toFixed(2);
    }

    calculateFederalTax() {
        // Calculate the federal tax based on the income
        let federalTax = 0;
        let incomeMinusStandardSingleDeduction = this.income - standardSingleDeduction;
        // console.log('***incomeMinusStandardSingleDeduction: ', incomeMinusStandardSingleDeduction);
        
        for (const bracket of federalTaxBrackets) {
            if (incomeMinusStandardSingleDeduction <= bracket.max || !bracket.max) {
                // console.log('***bracket.rate: ', bracket.rate);
                federalTax = (bracket.rate * (incomeMinusStandardSingleDeduction - bracket.min)) + (bracket.min * bracket.rate);
                break;
            }
        }
        return federalTax > 0 ? federalTax : 0;
    }

    handleChange(event) {
        // Update the corresponding property based on user input
        const fieldName = event.target.label;
        this[fieldName.toLowerCase()] = parseFloat(event.target.value);
    }

    handleInputFocus(event) {
        // modify parent to properly highlight visually
        const classList = event.target.parentNode.classList;
        classList.add('lgc-highlight');
    }

    handleInputBlur(event) {
        // modify parent to properly remove highlight
        const classList = event.target.parentNode.classList;
        classList.remove('lgc-highlight');
    }

}
