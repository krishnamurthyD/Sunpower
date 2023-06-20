import { LightningElement, api, track } from 'lwc';

export default class B2b2c_InputNumber extends LightningElement {
    _value = 1;
    _max = 1000000;
    @api 
    get value(){
        return this._value;
    }
    set value(value){
        console.log('in value');
        this._value = parseInt(value);
        this.validateIncrement();
        this.validateDecrement();
    }
    @api 
    get max(){
        return this._max;
    }
    set max(value){
        console.log('in max');
        this._max = parseInt(value);
        this.validateIncrement();
        this.validateDecrement();
    }
    
    @api required = false;
    @api disabled = false;
    @api name = '';

    @track disableDecrement = true; 
    @track disableIncreament = false;

    handleChange(event){
        this.value = event.target.value;
        console.log('handleInput ',event.target.value);
        this.dispatchEvent(new CustomEvent('change', { detail: {value: this.value} }));

        this.validateIncrement();
        this.validateDecrement();
    }

    handleBlur(event){
        this.value = event.target.value;
        console.log('handleInput ',event.target.value);
        this.dispatchEvent(new CustomEvent('blur', { detail: {value: this.value} }));

        this.validateIncrement();
        this.validateDecrement();
    }
    
    validateDecrement(){
        console.log('validateDecrement value', this.value);
        console.log('validateDecrement max', this.max);
        if((this.value-1) < 1 ){
            this.disableDecrement = true;
            console.log('disableDecrement ', this.disableDecrement);
            return false;
        }else{
            this.disableDecrement = false;
            console.log('disableDecrement ', this.disableDecrement);
            return true;
        }
    }

    validateIncrement(){
        console.log('validateIncrement value', this.value);
        console.log('validateIncrement max', this.max);
        if((this.value+1) > this.max ){
            this.disableIncreament = true;
            console.log('disableIncreament ', this.disableIncreament);
            return false;
        }else{
            this.disableIncreament = false;
            console.log('disableIncreament ', this.disableIncreament);
            return true;
        }
    }

    onDecrement(){
        if(this.validateDecrement()){
            this.value--;
        }
        this.validateIncrement();
        this.dispatchEvent(new CustomEvent('change', { detail: {value: this.value} }));
        this.dispatchEvent(new CustomEvent('blur', { detail: {value: this.value} }));
    }

    onIncrement(){
        if(this.validateIncrement()){
            this.value++;
        }
        this.validateDecrement();
        this.dispatchEvent(new CustomEvent('change', { detail: {value: this.value} }));
        this.dispatchEvent(new CustomEvent('blur', { detail: {value: this.value} }));
    }
}