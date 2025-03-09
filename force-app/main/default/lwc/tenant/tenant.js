import { LightningElement, wire } from "lwc";
import getTenants from "@salesforce/apex/TenantListController.getTenants";
import {NavigationMixin} from "lightning/navigation";

export default class Tenant extends NavigationMixin(LightningElement) {
    tenants=[];
    error;
    columns=[
        {label:'Tenant Name',fieldName:'Name'},
        {label:'Email',fieldName:'Email__c'},
        {label:'Phone Number',fieldName:'Phone_Number__c'}
    ];

    @wire(getTenants)
        wiredTenants({data,error}){
            if(data){
                this.tenants=data;
            }
            else if(error){
                this.error=error;
                this.tenants=[];
            }
        }
    
        navigateToNewTenant(){
            this[NavigationMixin.Navigate]({
                type: "standard__objectPage",
                attributes: {
                  objectApiName: "Tenant__c",
                  actionName: "new",
                }
              });
    }
}