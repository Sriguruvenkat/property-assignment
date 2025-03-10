import { LightningElement,api} from 'lwc';
import {loadScript} from 'lightning/platformResourceLoader';
import getLeaseAgreementController from '@salesforce/apex/PropertyListController.getLeaseAgreementController';
import JSPDF from '@salesforce/resourceUrl/jsPDF';

export default class LeaseAgreementPdf extends LightningElement {
    @api recordId;
    leaseAgreement;
   renderedCallback(){
    Promise.all([
        loadScript(this, JSPDF)
    ]);
   }
    generatePdf(){
    const { jsPDF  }=window.jspdf;
    const doc=new jsPDF();

    doc.setFontSize(16);
    doc.text('Lease Agreement', 20, 10);

    doc.setFontSize(12);
    doc.text(`Lease Agreement Terms: ${this.leaseAgreement.Terms__c}`, 20, 30);
    doc.text(`Tenant Name: ${this.leaseAgreement.Tenant__r.Name}`, 20, 40);
    doc.text(`Start Date: ${this.leaseAgreement.Start_Date__c}`, 20, 50);
    doc.text(`End Date: ${this.leaseAgreement.End_Date__c}`, 20, 60);
    doc.text(`Amount: Rs.${this.leaseAgreement.Agreed_Monthly_Rent__c}`, 20, 70);

    doc.save(`${this.leaseAgreement.Tenant__r.Name}_Lease_Agreement.pdf`);
   }

   generateData(){
        getLeaseAgreementController({leaseId:this.recordId})
            .then(result=>{
                this.leaseAgreement=result;
                this.generatePdf();
            })
   }

}