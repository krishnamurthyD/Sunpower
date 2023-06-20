import { LightningElement, wire, track, api } from 'lwc';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import userId from '@salesforce/user/Id';
import communityPath from '@salesforce/community/basePath';


import fetchLocations from '@salesforce/apex/B2B2C_StoreLocator.fetchLocations';
import updateDefaultStore from '@salesforce/apex/B2B2C_StoreLocator.updateDefaultStore';
import fetchPreferredStore from '@salesforce/apex/B2B2C_StoreLocator.fetchPreferredStore';
import updateLocations from '@salesforce/apex/B2B2C_StoreLocator.updateLocations';
import LOCATION_OBJECT from '@salesforce/schema/Location';
import TYPE_FIELD from '@salesforce/schema/Location.LocationType';
import { loadStyle } from 'lightning/platformResourceLoader';
import StoreLocatorCSS from '@salesforce/resourceUrl/storelocator';

     
    export default class B2b2c_StoreLocator extends NavigationMixin(LightningElement)  {

        @track error;
        @track mapMarkers = [];
        @track markersTitle = 'Accounts';
        @track zoomLevel = 7;
        @track record;
        @track selectedStoreId;
        @track selectedStoreName;
        @track selectedStoreStreet;
        @track selectedStoreCity;
        @track selectedStoreState;
        @track selectedStoreZipCode;
        @track selectedStorePhone;
        @track selectedStoreTimings;
        @track selectedStoreFacilities;
        @track selectedStoreServices;
        @track searchInput = '';


        @api serviceClassName;
        @api distance;
        @api unit;
        @api isLoaded = false;
        @api searchIconUrl = '';


        maxRadius;

        timingsMap = {};
        mapData = [];
        value = [];
        splitArray = [];
        finalArray = [];
        days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
        
        loggedinUser = false;
        showStoreDetails = false;
        isSelected = false;
        foundStore = false;

        openTime;
        storeTimings;
        type;
        address;
        selectedMarkerValue = 'SF1';
        userLatitude;
        userLongitude;
        filterCount = 0;
        date;
        day;
        weekday;
        iconName = '';
        displayClass = 'slds-hide';



        get selectedValues() {
            return this.value.join(',');
        }

        handleChange(e) {
            this.value = e.detail.value;
        }

        @wire(getObjectInfo, { objectApiName: LOCATION_OBJECT })
        objectInfo;
      
        @wire(getPicklistValues, {
          recordTypeId: "$objectInfo.data.defaultRecordTypeId",
          fieldApiName: TYPE_FIELD
        })
        typePicklistValues;


        renderedCallback() {
        
            Promise.all([
                loadStyle( this, StoreLocatorCSS + '/storelocator/b2bStoreLocator.css' )
                ]).then(() => {
                    console.log('Files loaded');
                })
                .catch(error => {
                    //console.log(error);
            });
        }

        connectedCallback(){

            this.searchIconUrl = communityPath + '/assets/icons/utility-sprite/svg/symbols.svg#search';

            if(userId){
                console.log('user id ' + userId);
                this.loggedinUser = true;
            }

            this.maxRadius = this.distance;

            navigator.geolocation.getCurrentPosition(
              function (position) {
                this.userLatitude = position.coords.latitude;
                this.userLongitude = position.coords.longitude;

                console.log(this.userLatitude + ' ' + this.userLongitude);

                if(this.userLatitude && this.userLongitude){
                    this.getPreferredStore();
                }
              }.bind(this),
              function (e) {
                console.log(e.message);
              }.bind(this),
              {
                enableHighAccuracy: true,
              }
            );

            var today = new Date();
            this.date=today.toISOString();
            this.day = today.getDay();

            updateLocations({ serviceClassName: this.serviceClassName })
            .then((data) => {
                //console.log(data);
            })
            .catch((error) => {
                this.error = error;
                this.isLoaded = true;
            });
        }  

        getUserLocation(){
            navigator.geolocation.getCurrentPosition(
                function (position) {
                  this.userLatitude = position.coords.latitude;
                  this.userLongitude = position.coords.longitude;
                }.bind(this),
                function (e) {
                  console.log(e.message);
                }.bind(this),
                {
                  enableHighAccuracy: true,
                }
              );
              this.searchInput = 'My Location';

              console.log(this.userLatitude + ' ' + this.userLongitude);

              this.mapMarkers = [];

              this.foundStore = false;

              fetchLocations({ distance: this.distance, unit: this.unit, userLatitude: this.userLatitude, userLongitude: this.userLongitude, serviceClassName: this.serviceClassName })
              .then((data) => {
  
                if(data.length > 0){

                  this.isLoaded = false;
                  this.foundStore = false;
                  //console.log(JSON.stringify(data));
                  console.log(data);
  
                  this.mapData = data;
                  this.mapMarkers = [];
  
                  data.forEach(result => {
                      console.log(result);
  
                      if(result.Distance <= this.distance){
  
                          this.foundStore = true;
  
                          var storeTime = result.Timings;
                          this.splitArray = [];
                          var timeArray = storeTime.split('<p>');
  
                           for (let i = 1; i < timeArray.length; i++) {
                              const element = timeArray[i].replace(/<[^>]+>/g, '');
                              this.splitArray.push(element.split('-'));
                           }
                             
                           var startDay;
                           var endDay;
                           var closeTime;
  
                          for (let i = 0; i < this.splitArray.length; i++) {
  
                              if(this.splitArray[i].length == 3){
                                  startDay = this.splitArray[i][0];
                                  endDay = this.splitArray[i][1].substring(0,3);
                                  closeTime = this.splitArray[i][2].substr(1);
                              }
                              else if(this.splitArray[i].length == 2){
                                  startDay = this.splitArray[i][0].substring(0,3);
                                  endDay = startDay;
                                  closeTime = this.splitArray[i][1].substr(1);
                              }
                              else if(this.splitArray[i].length == 1){
                                  startDay = this.splitArray[i][0].substring(0,3);
                                  endDay = startDay;
                                  closeTime = this.splitArray[i][0].substr(4);
                              }
                              if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                  break;
                          }
  
                          if(closeTime == 'Closed')    
                              this.storeTimings = closeTime;
                          else
                              this.storeTimings = 'Open until ' + closeTime;
  
  
                          this.mapMarkers = [...this.mapMarkers,
                              {
                                  location: {
                                      City: result.Addresses[0].City,
                                      Country: result.Addresses[0].Country,
                                      PostalCode: result.Addresses[0].PostalCode,
                                      State: result.Addresses[0].State,
                                      Street: result.Addresses[0].Street,
                                  },
                                  icon: 'custom:custom26',
                                  title: result.Name,
                                  description: result.Addresses[0].Street + ', ' + result.Addresses[0].City + ', ' + result.Addresses[0].PostalCode,
                                  Id: result.Id,
                                  distance: result.Distance,
                                  timings: result.Timings,
                                  storetime: this.storeTimings,
                                  phone: result.Phone,
                                  facilities: result.Facilities,
                                  services: result.Services,
                                  isDefault: result.isDefault,
                                  value: result.Id
                              }
                              ];
                      }
                      else{
                          this.displayClass = 'slds-p-around--small';
                      }                      
                  });
  
                  this.error = undefined;
                }
                else{
                    //this.isLoaded = true;
                    console.log('in else');
                }
                  
              })
              .catch((error) => {
                  this.error = error;
                  this.isLoaded = true;
                  console.log(JSON.parse(JSON.stringify(error)));
              });

        }

        getPreferredStore(){
            this.isLoaded = true;

            fetchPreferredStore({ distance: this.distance, unit: this.unit, userLatitude: this.userLatitude, userLongitude: this.userLongitude, serviceClassName: this.serviceClassName })
            .then((data) => {

                this.isLoaded = false;
                this.foundStore = false;
                //console.log(JSON.stringify(data));
                console.log(data);

                this.mapData = data;
                this.mapMarkers = [];

                data.forEach(result => {
                    //console.log(result);

                    this.foundStore = true;

                    var storeTime = result.Timings;
                        this.splitArray = [];
                        var timeArray = storeTime.split('<p>');

                         for (let i = 1; i < timeArray.length; i++) {
                            const element = timeArray[i].replace(/<[^>]+>/g, '');
                            this.splitArray.push(element.split('-'));
                         }
                        
                         var startDay;
                         var endDay;
                         var closeTime;

                        for (let i = 0; i < this.splitArray.length; i++) {

                            if(this.splitArray[i].length == 3){
                                startDay = this.splitArray[i][0];
                                endDay = this.splitArray[i][1].substring(0,3);
                                closeTime = this.splitArray[i][2].substr(1);
                            }
                            else if(this.splitArray[i].length == 2){
                                startDay = this.splitArray[i][0].substring(0,3);
                                endDay = startDay;
                                closeTime = this.splitArray[i][1].substr(1);
                            }
                            else if(this.splitArray[i].length == 1){
                                startDay = this.splitArray[i][0].substring(0,3);
                                endDay = startDay;
                                closeTime = this.splitArray[i][0].substr(4);
                            }
                            if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                break;
                        }

                        if(closeTime == 'Closed')    
                            this.storeTimings = closeTime;
                        else
                            this.storeTimings = 'Open until ' + closeTime;

                    this.mapMarkers = [...this.mapMarkers,
                        {
                            location: {
                                City: result.Addresses[0].City,
                                Country: result.Addresses[0].Country,
                                PostalCode: result.Addresses[0].PostalCode,
                                State: result.Addresses[0].State,
                                Street: result.Addresses[0].Street,
                            },
                            icon: 'custom:custom26',
                            title: result.Name,
                            description: result.Addresses[0].Street + ', ' + result.Addresses[0].City + ', ' + result.Addresses[0].PostalCode,
                            Id: result.Id,
                            distance: result.Distance,
                            timings: result.Timings,
                            storetime: this.storeTimings,
                            phone: result.Phone,
                            facilities: result.Facilities,
                            services: result.Services,
                            isDefault: result.isDefault,
                            value: result.Id
                        }
                        ];                    
                });

                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.isLoaded = true;
                console.log(JSON.parse(JSON.stringify(error)));
            });
        }

        handleSearch() {
            
            this.isLoaded = true;

            if(this.searchInput != undefined){
                fetchLocations({ distance: this.distance, unit: this.unit, userLatitude: this.userLatitude, userLongitude: this.userLongitude, serviceClassName: this.serviceClassName })
                .then((data) => {
    
                    this.isLoaded = false;
                    this.foundStore = false;
                    //console.log(JSON.stringify(data));
                    console.log(data);
    
                    this.mapData = data;
                    this.mapMarkers = [];
    
                    data.forEach(result => {
                        //console.log(result);
    
                        if(result.Addresses[0].City.toUpperCase() == this.searchInput.toUpperCase() || result.Addresses[0].PostalCode == this.searchInput){
    
                            this.foundStore = true;
    
                            var storeTime = result.Timings;
                            this.splitArray = [];
                            var timeArray = storeTime.split('<p>');
    
                             for (let i = 1; i < timeArray.length; i++) {
                                const element = timeArray[i].replace(/<[^>]+>/g, '');
                                this.splitArray.push(element.split('-'));
                             }
                             
                             //console.log(this.splitArray); 
    
                             var startDay;
                             var endDay;
                             var closeTime;
    
                            for (let i = 0; i < this.splitArray.length; i++) {
    
                                if(this.splitArray[i].length == 3){
                                    startDay = this.splitArray[i][0];
                                    endDay = this.splitArray[i][1].substring(0,3);
                                    closeTime = this.splitArray[i][2].substr(1);
                                }
                                else if(this.splitArray[i].length == 2){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][1].substr(1);
                                }
                                else if(this.splitArray[i].length == 1){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][0].substr(4);
                                }
                                if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                    break;
                            }
                            //console.log(startDay + ' ' + endDay + ' ' + closeTime);
    
                            if(closeTime == 'Closed')    
                                this.storeTimings = closeTime;
                            else
                                this.storeTimings = 'Open until ' + closeTime;
    
    
                            this.mapMarkers = [...this.mapMarkers,
                                {
                                    location: {
                                        City: result.Addresses[0].City,
                                        Country: result.Addresses[0].Country,
                                        PostalCode: result.Addresses[0].PostalCode,
                                        State: result.Addresses[0].State,
                                        Street: result.Addresses[0].Street,
                                    },
                                    icon: 'custom:custom26',
                                    title: result.Name,
                                    description: result.Addresses[0].Street + ', ' + result.Addresses[0].City + ', ' + result.Addresses[0].PostalCode,
                                    Id: result.Id,
                                    distance: result.Distance,
                                    timings: result.Timings,
                                    storetime: this.storeTimings,
                                    phone: result.Phone,
                                    facilities: result.Facilities,
                                    services: result.Services,
                                    isDefault: result.isDefault,
                                    value: result.Id
                                }
                                ];
                        }
                        else{
                            this.displayClass = 'slds-p-around--small';
                        }                      
                    });
                    //console.log(JSON.parse(JSON.stringify(this.mapMarkers)));
    
                    this.error = undefined;
                })
                .catch((error) => {
                    this.error = error;
                    this.isLoaded = true;
                    console.log(JSON.parse(JSON.stringify(error)));
                });
            }
            
        }

        handlePicklistChange(event){
            
            this.type = event.target.value;
            this.value = event.detail.value;
            //console.log('val->' + this.value);

            this.filterCount = this.value.length;

            this.mapMarkers = [];

            this.foundStore = false;

            if(this.searchInput == 'My Location'){
                if(this.value.length >= 1){
                    this.mapData.forEach(element => {
    
                        for (let i = 0; i < this.value.length; i++) {
        
                            if(this.value[i] && element.LocationType == this.value[i] && element.Distance <= this.distance){
    
                            this.foundStore = true;

                            var storeTime = element.Timings;
                            this.splitArray = [];
                            var timeArray = storeTime.split('<p>');
    
                             for (let i = 1; i < timeArray.length; i++) {
                                const element = timeArray[i].replace(/<[^>]+>/g, '');
                                this.splitArray.push(element.split('-'));
                             }
                             
                             var startDay;
                             var endDay;
                             var closeTime;
    
                            for (let i = 0; i < this.splitArray.length; i++) {
    
                                if(this.splitArray[i].length == 3){
                                    startDay = this.splitArray[i][0];
                                    endDay = this.splitArray[i][1].substring(0,3);
                                    closeTime = this.splitArray[i][2].substr(1);
                                }
                                else if(this.splitArray[i].length == 2){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][1].substr(1);
                                }
                                else if(this.splitArray[i].length == 1){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][0].substr(4);
                                }
                                if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                    break;
                            }
                            console.log(startDay + ' ' + endDay + ' ' + closeTime);
    
                            if(closeTime == 'Closed')    
                                this.storeTimings = closeTime;
                            else
                                this.storeTimings = 'Open until ' + closeTime;
    
                                this.mapMarkers = [...this.mapMarkers,
                                    {
                                        location: {
                                            City: element.Addresses[0].City,
                                            Country: element.Addresses[0].Country,
                                            PostalCode: element.Addresses[0].PostalCode,
                                            State: element.Addresses[0].State,
                                            Street: element.Addresses[0].Street,
                                        },
                                        icon: 'custom:custom26',
                                        title: element.Name,
                                        description: element.Addresses[0].Street + ', ' + element.Addresses[0].City + ', ' + element.Addresses[0].PostalCode,
                                        Id: element.Id,
                                        distance: element.Distance,
                                        timings: element.Timings,
                                        storetime: this.storeTimings,
                                        phone: element.Phone,
                                        facilities: element.Facilities,
                                        services: element.Services,
                                        isDefault: element.isDefault,
                                        value: element.Id
                                    }
                                    ];
                            }
                        }
                        
                    });
                }
                else if(this.value.length == 0){
    
                    this.mapData.forEach(element => {
    
                        if(element.Distance <= this.distance){
    
                            this.foundStore = true;

                            var storeTime = element.Timings;
                            this.splitArray = [];
                            var timeArray = storeTime.split('<p>');
    
                             for (let i = 1; i < timeArray.length; i++) {
                                const element = timeArray[i].replace(/<[^>]+>/g, '');
                                this.splitArray.push(element.split('-'));
                             }
                             
                             var startDay;
                             var endDay;
                             var closeTime;
    
                            for (let i = 0; i < this.splitArray.length; i++) {
    
                                if(this.splitArray[i].length == 3){
                                    startDay = this.splitArray[i][0];
                                    endDay = this.splitArray[i][1].substring(0,3);
                                    closeTime = this.splitArray[i][2].substr(1);
                                }
                                else if(this.splitArray[i].length == 2){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][1].substr(1);
                                }
                                else if(this.splitArray[i].length == 1){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][0].substr(4);
                                }
                                if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                    break;
                            }
    
                            if(closeTime == 'Closed')    
                                this.storeTimings = closeTime;
                            else
                                this.storeTimings = 'Open until ' + closeTime;
    
                            this.mapMarkers = [...this.mapMarkers,
                                {
                                    location: {
                                        City: element.Addresses[0].City,
                                        Country: element.Addresses[0].Country,
                                        PostalCode: element.Addresses[0].PostalCode,
                                        State: element.Addresses[0].State,
                                        Street: element.Addresses[0].Street,
                                    },
                                    icon: 'custom:custom26',
                                    title: element.Name,
                                    description: element.Addresses[0].Street + ', ' + element.Addresses[0].City + ', ' + element.Addresses[0].PostalCode,
                                    Id: element.Id,
                                    distance: element.Distance,
                                    timings: element.Timings,
                                    storetime: this.storeTimings,
                                    phone: element.Phone,
                                    facilities: element.Facilities,
                                    services: element.Services,
                                    isDefault: element.isDefault,
                                    value: element.Id
                                }
                                ];
                        }
                        
                    });
                }
            }
            else{
                if(this.value.length >= 1){
                    this.mapData.forEach(element => {
    
                        for (let i = 0; i < this.value.length; i++) {
        
                            if(this.value[i] && element.LocationType == this.value[i] && (element.Addresses[0].City.toUpperCase() == this.searchInput.toUpperCase() || element.Addresses[0].PostalCode == this.searchInput)){
    
                            this.foundStore = true;

                            var storeTime = element.Timings;
                            this.splitArray = [];
                            var timeArray = storeTime.split('<p>');
    
                             for (let i = 1; i < timeArray.length; i++) {
                                const element = timeArray[i].replace(/<[^>]+>/g, '');
                                this.splitArray.push(element.split('-'));
                             }
                             
                             var startDay;
                             var endDay;
                             var closeTime;
    
                            for (let i = 0; i < this.splitArray.length; i++) {
    
                                if(this.splitArray[i].length == 3){
                                    startDay = this.splitArray[i][0];
                                    endDay = this.splitArray[i][1].substring(0,3);
                                    closeTime = this.splitArray[i][2].substr(1);
                                }
                                else if(this.splitArray[i].length == 2){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][1].substr(1);
                                }
                                else if(this.splitArray[i].length == 1){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][0].substr(4);
                                }
                                if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                    break;
                            }
                            console.log(startDay + ' ' + endDay + ' ' + closeTime);
    
                            if(closeTime == 'Closed')    
                                this.storeTimings = closeTime;
                            else
                                this.storeTimings = 'Open until ' + closeTime;
    
                                this.mapMarkers = [...this.mapMarkers,
                                    {
                                        location: {
                                            City: element.Addresses[0].City,
                                            Country: element.Addresses[0].Country,
                                            PostalCode: element.Addresses[0].PostalCode,
                                            State: element.Addresses[0].State,
                                            Street: element.Addresses[0].Street,
                                        },
                                        icon: 'custom:custom26',
                                        title: element.Name,
                                        description: element.Addresses[0].Street + ', ' + element.Addresses[0].City + ', ' + element.Addresses[0].PostalCode,
                                        Id: element.Id,
                                        distance: element.Distance,
                                        timings: element.Timings,
                                        storetime: this.storeTimings,
                                        phone: element.Phone,
                                        facilities: element.Facilities,
                                        services: element.Services,
                                        isDefault: element.isDefault,
                                        value: element.Id
                                    }
                                    ];
                            }
                        }
                        
                    });
                }
                else if(this.value.length == 0){
    
                    this.mapData.forEach(element => {
    
                        if(element.Addresses[0].City.toUpperCase() == this.searchInput.toUpperCase() || element.Addresses[0].PostalCode == this.searchInput){
    
                            this.foundStore = true;

                            var storeTime = element.Timings;
                            this.splitArray = [];
                            var timeArray = storeTime.split('<p>');
    
                             for (let i = 1; i < timeArray.length; i++) {
                                const element = timeArray[i].replace(/<[^>]+>/g, '');
                                this.splitArray.push(element.split('-'));
                             }
                             
                             var startDay;
                             var endDay;
                             var closeTime;
    
                            for (let i = 0; i < this.splitArray.length; i++) {
    
                                if(this.splitArray[i].length == 3){
                                    startDay = this.splitArray[i][0];
                                    endDay = this.splitArray[i][1].substring(0,3);
                                    closeTime = this.splitArray[i][2].substr(1);
                                }
                                else if(this.splitArray[i].length == 2){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][1].substr(1);
                                }
                                else if(this.splitArray[i].length == 1){
                                    startDay = this.splitArray[i][0].substring(0,3);
                                    endDay = startDay;
                                    closeTime = this.splitArray[i][0].substr(4);
                                }
                                if(this.day >= this.days.indexOf(startDay) && this.day <= this.days.indexOf(endDay))
                                    break;
                            }
    
                            if(closeTime == 'Closed')    
                                this.storeTimings = closeTime;
                            else
                                this.storeTimings = 'Open until ' + closeTime;
    
                            this.mapMarkers = [...this.mapMarkers,
                                {
                                    location: {
                                        City: element.Addresses[0].City,
                                        Country: element.Addresses[0].Country,
                                        PostalCode: element.Addresses[0].PostalCode,
                                        State: element.Addresses[0].State,
                                        Street: element.Addresses[0].Street,
                                    },
                                    icon: 'custom:custom26',
                                    title: element.Name,
                                    description: element.Addresses[0].Street + ', ' + element.Addresses[0].City + ', ' + element.Addresses[0].PostalCode,
                                    Id: element.Id,
                                    distance: element.Distance,
                                    timings: element.Timings,
                                    storetime: this.storeTimings,
                                    phone: element.Phone,
                                    facilities: element.Facilities,
                                    services: element.Services,
                                    isDefault: element.isDefault,
                                    value: element.Id
                                }
                                ];
                        }
                        
                    });
                }
            }
            
        }

        handleSliderChange(event){
            this.distance = event.target.value;
        }

        handleApplybtn(){
            //this.mapMarkers = [];
            if(this.searchInput == 'My Location'){
                this.getUserLocation();
            }
            else{
                this.handleSearch();
            }
        }

        handleOnChange(event){
            this.searchInput = event.target.value;
            //console.log('searchinput' + this.searchInput);
        }

        handleKeyPress(event){
            if(event.keyCode == 13){
                this.handleSearch();
            }
        }

        handleMarkerSelect(event) {
            this.selectedMarkerValue = event.detail.selectedMarkerValue;
            console.log(event);
            console.log('marker value->' + this.selectedMarkerValue);
        }    

        handleStoreSelect(event){

            this.selectedStoreId = event.target.dataset.store;
            this.selectedStoreStreet = event.target.dataset.street;
            this.selectedStoreCity = event.target.dataset.city;
            this.selectedStoreState = event.target.dataset.state;
            this.selectedStoreZipCode = event.target.dataset.zipcode;
            this.selectedStoreName = event.target.dataset.name;
            this.selectedStorePhone = event.target.dataset.phone;
            this.selectedStoreTimings = event.target.dataset.timings;
            this.selectedStoreFacilities = event.target.dataset.facilities;
            this.selectedStoreServices = event.target.dataset.services;

            this.showStoreDetails = true;

            //console.log('clicked button id->' + event.target.dataset.store);

            updateDefaultStore({ storeId: this.selectedStoreId, serviceClassName: this.serviceClassName })
            .then(result => {
                console.log('success');
                this.showToastMsg();
            })
            .catch(error => {
                this.error = error;
                console.log(error);
            });

            this.iconName = '';

            var btnid = event.currentTarget?.dataset.store;
            console.log(btnid);

            this.mapMarkers.forEach(element => {
                
                var temp = this.template.querySelector("[data-store='" + element.Id + "']");
                temp.label = 'Make Default'
                temp.variant = 'brand';
                temp.iconName = '';
                temp.class = '';

                if(element.Id === btnid){
                    temp.label = 'Default Store';
                    temp.variant = 'neutral';
                    temp.iconName = 'utility:check';
                    temp.class = 'btn-inverse';
                }

            });

        }

        handleGuestClick(){
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'Login'
                }
            });
        }

        handleTileClick(e){
            var btnid = e.currentTarget?.dataset.id;


            this.mapMarkers.forEach(element => {
                
                var temp = this.template.querySelector("[data-id='" + element.Id + "']");
                temp.classList.remove('product-option_line-item-selected');

                if(element.Id === btnid){
                    temp.classList.add('product-option_line-item-selected');
                }

            });
        }

        showToastMsg(){
            console.log('in toast');
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Default store has been updated.',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
    }