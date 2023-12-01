import { LightningElement, track, api } from 'lwc';
import getProducts from '@salesforce/apex/Product2Controller.getProducts';

export default class SearchBar extends LightningElement {
  @track showFlyout = false;
  searchText = '';
  searchResults = [];

  handleFocus() {
    this.searchText = '';
  }

  handleBlur() {
    if (this.searchText === '') {
      this.searchText = 'Search over (number) products here';
    }
  }

  handleInput(event) {
    this.searchText = event.target.value.trim();

    if (this.searchText.length >= 3) {
      getProducts({ EsearchText: this.searchText })
        .then((result) => {
          this.searchResults = result;
          this.showFlyout = true;
          this.renderFlyout();
        })
        .catch((error) => {
          // Handle any error occurred during the Apex call
          console.error('Error fetching search suggestions:', error);
        });
    } else {
      this.showFlyout = false;
      this.searchResults = [];
    }
  }

  @api
  productDetailUrl(productId) {
    // Replace this logic with your actual URL generation based on the product ID
    return '/product-detail/' + productId;
  }

  renderFlyout() {
    const flyoutContainer =  document.querySelector('[data-component-id="section-d4c0"]').querySelector(".search-flyout");
    flyoutContainer.innerHTML = '';

    const ulElement = document.createElement('ul');
    this.searchResults.forEach((product) => {
      const liElement = document.createElement('li');
      const aElement = document.createElement('a');
      aElement.href = this.productDetailUrl(product.Id);
      aElement.textContent = product.Name;
      liElement.appendChild(aElement);
      ulElement.appendChild(liElement);
    });

    flyoutContainer.appendChild(ulElement);
  }
}
