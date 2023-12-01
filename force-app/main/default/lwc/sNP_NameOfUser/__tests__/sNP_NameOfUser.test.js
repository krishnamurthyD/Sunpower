import { createElement } from 'lwc';
import SNP_NameOfUser from 'c/sNP_NameOfUser';

describe('c-s-n-p-name-of-user', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-s-n-p-name-of-user', {
            is: SNP_NameOfUser
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});