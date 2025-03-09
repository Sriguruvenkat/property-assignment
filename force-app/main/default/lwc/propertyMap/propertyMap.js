import { LightningElement,wire,api } from 'lwc';
import getPropertyGeolocation from '@salesforce/apex/PropertyListController.getPropertyGeolocation';

export default class PropertyMap extends LightningElement {
    @api recordId;
    mapMarkers=[];
    isMapAvailable=true;

    @wire(getPropertyGeolocation,{propertyId:'$recordId'})
    wiredGeolocation({data,error}){
        if(data){
            this.mapMarkers=[
                {
                    location:{
                        Latitude:data.latitude,
                        Longitude:data.longitude
                    },
                    title:'Property Location',
                    description:'This is the property selected.'
                }
            ];
        }
        else if(error){
            this.isMapAvailable=false;
        }
    }
}