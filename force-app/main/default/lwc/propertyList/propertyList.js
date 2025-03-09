import { LightningElement } from 'lwc';
import getProperties from '@salesforce/apex/PropertyListController.getProperties';

export default class PropertyList extends LightningElement {
    properties=[];
    showFilters=false;
    totalRecords=0;
    pageNumber=1;
    pageSize=25;
    totalPages=1;
    columns=[
        {label:'Property Name',fieldName:'recordLink',type:'url',
            typeAttributes:{
                label:{fieldName:'Name'},
                target:'_self'
        }},
        {label:'Address',fieldName:'Address__c'},
        {label:'City',fieldName:'City__c'},
        {label:'State',fieldName:'State__c'},
        {label:'Rent',fieldName:'Rent__c'},
        {label:'Status',fieldName:'Status__c'},
        {label:'Furnishing Status',fieldName:'Furnishing_Status__c'}
    ]


    minRent=0;
    maxRent=null;
    availabilityStatus='';
    furnishingStatus='';
    availabilityOptions=[
        {label:'--None--',value:''},
        {label:'Occupied',value:'Occupied'},
        {label:'Available',value:'Available'}
    ];
    furnishingOptions=[
        {label:'--None--',value:''},
        {label:'Furnished',value:'Furnished'},
        {label:'Semi-Furnished',value:'Semi-Furnished'},
        {label:'Unfurnished',value:'Unfurnished'}
    ];
    userLat=null;
    userLong=null;
    maxDistance=null;

    connectedCallback(){
        this.fetchProperties();
    }

    fetchProperties(){
        getProperties({pageNumber:this.pageNumber,pageSize:this.pageSize,minRent:this.minRent,maxRent:this.maxRent,status:this.availabilityStatus,
            furnishingStatus:this.furnishingStatus,userLat:this.userLat,userLong:this.userLong})
            .then(result=>{
                this.properties=result.map(prop=>({
                    ...prop,
                    recordLink:`/lightning/r/Property__c/${prop.Id}/view`
                }));
                console.log('properties',this.properties);
                console.log('Result Length',this.properties.length);
            })
            .catch(error=>{
                console.error('Error fetching properties:',error);
                console.error('Error Message:',error.body.message);
                console.error('Error Stack',error.body.stackTrace);
            })
    
    }

    handleChange(event){
        console.log('Field value',event.detail.value);
        console.log('Event',event.target.dataset.fieldName)
        const field=event.target.dataset.fieldName;
        if(field=='availabilityStatus'){
            this.availabilityStatus=event.detail.value;
        }
        else if(field=='furnishingStatus'){
            this.furnishingStatus=event.detail.value;
        }
        else if(field=='minRent'){
            this.minRent=event.detail.value;
        }
        else if(field=='maxRent'){
            this.maxRent=event.detail.value;
            console.log('Length',this.maxRent.length);
            if(this.maxRent.length==0){
                this.maxRent=null;
            }
        }
    }

    toggleFilters(){
        this.showFilters= !this.showFilters;
    }

    resetFilters(){
        this.minRent=0;
        this.maxRent=null;
        this.availabilityStatus='';
        this.furnishingStatus='';
    }
    applyFilter(){
        this.fetchProperties();
    }

    handleNextPage(){
        if(this.pageNumber < this.totalPages){
            this.pageNumber++;
            this.fetchProperties();
        }
    }

    handlePrevPage(){
        if(this.pageNumber>1){
            this.pageNumber--;
            this.fetchProperties();
        }
    }

    get isFirstPage(){
        return this.pageNumber ===1;
    }

    get isLastPage(){
        return this.pageNumber >= this.totalPages;
    }


}