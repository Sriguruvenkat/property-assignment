import { LightningElement } from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class CreateProperty extends NavigationMixin(LightningElement) {
    navigateToNewProperty(){
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
              objectApiName: "Property__c",
              actionName: "new",
            }
          });
    }
}