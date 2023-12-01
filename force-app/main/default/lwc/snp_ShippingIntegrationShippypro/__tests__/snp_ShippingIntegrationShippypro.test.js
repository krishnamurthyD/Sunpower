import { createElement } from 'lwc';
import Snp_ShippingIntegrationShippypro from 'c/snp_ShippingIntegrationShippypro';

describe('c-snp-shipping-integration-shippypro', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-snp-shipping-integration-shippypro', {
            is: Snp_ShippingIntegrationShippypro
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});