import { createElement } from 'lwc';
import SerchSuggetionOnClickOf3Letters from 'c/serchSuggetionOnClickOf3Letters';

describe('c-serch-suggetion-on-click-of3-letters', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-serch-suggetion-on-click-of3-letters', {
            is: SerchSuggetionOnClickOf3Letters
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});