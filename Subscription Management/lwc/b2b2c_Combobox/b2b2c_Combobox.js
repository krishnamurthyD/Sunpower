import { LightningElement, api } from 'lwc';

export default class B2b2c_Combobox extends LightningElement {
    _value = '';

    @api get value(){
        return this._value;
    } 

    set value(value){
        this._value = value;
        if(Array.isArray(this.options)){
            this.options.forEach(option => {
                option.checked = option.value == this._value ? true : false
            });
        }

        console.log('value this.options ',this.options);
    }

    renderedCallback(){
        /*let select = this.template.querySelector('select');
        console.log('select ',select);
        if(select){
            select.onchange();
        }*/
    }

    _options = [];

    @api get options(){
        return this._options;
    }
    set options(value){
        if(Array.isArray(value)){
            this._options = JSON.parse(JSON.stringify(value)) ;
            this._options.forEach(option => {
                option.checked = option.value == this.value ? true : false
            });
        }
        console.log('this.options ',this._options);
    }

    handleChange(event){
        this._value = event.target.value;
        console.log('value ', event.target.value);
        this.dispatchEvent(new CustomEvent('change', { detail: {value: this.value} }));
    }
}