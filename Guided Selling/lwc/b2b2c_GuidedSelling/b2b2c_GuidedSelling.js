import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class B2b2c_GuidedSelling extends NavigationMixin(LightningElement) {
    totalSteps = [];
    currentStep = 0;
    selectedCategory = '';
    selectedAttributes = [];
    @api noOfSteps;
    categoriesObj = [];
    @api quizConfig;
    @api quizConfigStep2;
    @api quizConfigStep3;
    step2QuizOpts = [];
    step3QuizOpts = [];
    step4Obj;
    isCountinue = true;

    connectedCallback(){
        var theCat = this.quizConfig;
        this.categoriesObj = JSON.parse(theCat.replace(/'/g, '"'));
        //Steps
        for(let i=1; i<=this.noOfSteps; i++){
            this.totalSteps.push({label: 'Step '+i, value: i});
        }
        this.currentStep = 1;
    }

    goToNextStep(){
        if(!this.selectedCategory){
            this.showNotification('Error', 'Please select an option from below', 'error');
            this.isCountinue = true;
            return;
        }
        this.currentStep += 1;
        if(this.currentStep == this.noOfSteps){
            this.getFilterResults();
        }
    }

    getFilterResults(){
        let filters = this.removeDuplicates(this.selectedAttributes);
        let finalFilers = '';
        filters.forEach(attr => {
            finalFilers += ' '+attr.trim();
        });
        let newUrl = '/global-search/' +finalFilers;
        this.navigateToWebPage(newUrl);
    }

    removeDuplicates(arr){
        let outputArray = arr.filter(function(v, i, self){
            // It returns the index of the first
            // instance of each value
            return i == self.indexOf(v);
        });
         
        return outputArray;
    }

     // Navigation to web page
     navigateToWebPage(url) {
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": url
            }
        });
    }

    getCategoryValue(event){
        let selectedValue = event.target.dataset.category;
        this.isCountinue = false;
        console.log('You have selected::: '+ selectedValue);
        if(this.selectedCategory){
            this.template.querySelector('[data-category="'+this.selectedCategory+'"]').parentElement.classList.remove('cat-quiz-select');
        }
        this.template.querySelector('[data-category="'+selectedValue+'"]').parentElement.classList.add('cat-quiz-select');
        this.selectedCategory = selectedValue;
    }

    getAttributeValue(event){
        let selectedValue = event.target.dataset.attribute;
        //this.selectedAttributes.push(selectedValue);
        console.log('You have selected::: '+selectedValue);
        let indexOfSelectedItem = this.selectedAttributes.indexOf(selectedValue);
        if(this.selectedAttributes && indexOfSelectedItem >= 0){
            this.template.querySelector('[data-attribute="'+selectedValue+'_tick'+'"]').classList.remove('display-select');
            this.template.querySelector('[data-attribute="'+selectedValue+'"]').classList.remove('attr-select');
        } 
        
        if(indexOfSelectedItem < 0 ){
            this.selectedAttributes.push(selectedValue);
            this.template.querySelector('[data-attribute="'+selectedValue+'_tick'+'"]').classList.add('display-select');
            this.template.querySelector('[data-attribute="'+selectedValue+'"]').classList.add('attr-select');
        } else {
            delete this.selectedAttributes[indexOfSelectedItem];
            this.template.querySelector('[data-attribute="'+selectedValue+'_tick'+'"]').classList.remove('display-select');
            this.template.querySelector('[data-attribute="'+selectedValue+'"]').classList.remove('attr-select');
        }
        console.log('Selected Attributes::: '+ this.selectedAttributes);
    }

    get firstStep(){
        console.log('Next>>'+ this.currentStep);
        if(this.currentStep == 1){
            return true;
        } else {
            return false;
        }
    }

    get secondStep(){
        console.log('Next>>'+ this.currentStep);
        if(this.selectedCategory && this.currentStep == 2){
            this.categoriesObj?.options?.forEach(val => {
                if(val.label == this.selectedCategory){
                    val?.nextoptions?.split(',')?.forEach(opt => {
                        this.step2QuizOpts.push({
                            label:opt,
                            iconAttr:opt+'_tick'
                        });
                    });
                }
            });
        }
        console.log('this.step2QuizOpts>>> '+ this.step2QuizOpts);
        if(this.currentStep == 2){
            if(this.step2QuizOpts.length<1){
                this.getFilterResults();
            }
            return true;
        } else {
            return false;
        }
    }

    get thirdStep(){
        let temparr = [];
        let step3Configs = this.quizConfigStep2;
        let step3Obj = JSON.parse(step3Configs?.replace(/'/g, '"'));
        step3Obj?.options?.forEach(s3obj => {
            this.selectedAttributes.forEach(opt2 => {
                if(opt2.trim() == s3obj.label.trim()){
                    s3obj.nextoptions?.split(',').forEach(opt => {
                        if(temparr.indexOf(opt.trim()) === -1){
                            this.step3QuizOpts.push({
                                label:opt.trim(),
                                iconAttr:opt.trim()+'_tick'
                            });
                            temparr.push(opt.trim());
                        }
                    }); 
                }
            });
        });
        if(this.currentStep == 3){
            if(this.step3QuizOpts.length<1){
                this.getFilterResults();
            }
            return true;
        } else {
            return false;
        }
    }

    get forthStep(){
        let step4Configs = this.quizConfigStep3;
        this.step4Obj = JSON.parse(step4Configs?.replace(/'/g, '"'));
        return this.step4Obj;
    }

    showNotification(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}