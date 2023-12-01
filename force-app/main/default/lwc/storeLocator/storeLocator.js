import { LightningElement } from 'lwc';

export default class StoreLocator extends LightningElement {

isMapVisible=true;
newMapMarkers=[];
//Dummy Location Data
dummyMapMarkers = [
    {
        location: {
            City: 'London',
            Country: 'United Kingdom',
            PostalCode: 'WC2H 7LF',
            State: '49-50 Leicester Square',
            Street: ' Leicester Square',
        },
        value: 'location-1',
        title: 'Smeg Store - Leicester Square',
        description:
            'Our  Authentic Store at Leicester Square: 49-50 Leicester Square, London ',          
    },
    {
        location:{
            City: 'Birmingham',
            Country: 'United Kingdom',
            PostalCode: 'B5 4BG',
            State: 'Bullring',
            Street: 'Unit SU736',
        },
        value: 'location-2',
        title: 'Smeg Store - Bullring',
        description:
            'Our  Authentic Store at Bullring: Unit SU736, Upper Mall West, Bullring, Birmingham ',
        
        
    }, 
        {
        location:{
            City: 'Manchester',
            Country: 'United Kingdom',
            PostalCode: 'M1 1PW',
            State: 'Manchester',
            Street: ' Piccadilly Gardens',
        },
        value: 'location-3',
        title: 'Smeg Store - Manchester',
        description:
            'Our  Authentic Store at Piccadilly Gardens: 34 Piccadilly, Manchester ',
    }, 
    {
        location:{
            City: 'Edinburgh',
            Country: 'United Kingdom',
            PostalCode: 'EH2 2ER',
            State: 'Edinburgh',
            Street: '94 Princes Street',
        },
        value: 'location-4',
        title: 'Smeg Store - Edinburgh',
        description:
            'Our  Authentic Store at 94 Princes Street, Edinburgh',
    },
    {
        location:{
            City: 'Liverpool',
            Country: 'United Kingdom',
            PostalCode: 'L2 1TA',
            State: 'Liverpool',
            Street: '50-52 Lord Street',
        },
        value: 'location-5',
        title: 'Smeg Store - Liverpool',
        description:
            'Our  Authentic Store at  50-52 Lord Street, Liverpool ',
    },
    {
        location:{
            City: 'Glasgow',
            Country: 'United Kingdom',
            PostalCode: 'M1 1PW',
            State: 'Glasgow',
            Street: ' 170 Sauchiehall Street',
        },
        value: 'location-6',
        title: 'Smeg Store - Glasgow',
        description:
            'Our  Authentic Store at 170 Sauchiehall Street, Glasgow ',
    },
        
    
    
];


//Get Markers Based On Postal Code
getMapMarkers(){
this.isMapVisible=false;
let tempMarkers=[];
let postalCode = this.template.querySelector('[data-id="txtPostalCode"]');

for(let i=0;i<this.dummyMapMarkers.length;i++){
        if(this.dummyMapMarkers[i].location.PostalCode===postalCode.value){
            tempMarkers.push(this.dummyMapMarkers[i]);
            
        }
}

            this.newMapMarkers=tempMarkers;
}





}