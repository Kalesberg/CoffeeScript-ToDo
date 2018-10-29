import React from 'react';
import renderer from 'react-test-renderer';
import Todo from './Todo';

describe('Todo', () => {
    let component = null;

    it('renders correctly', () => {
        component = renderer.create(<Todo/>);
    });

    it('matches snapshot', () => {
        const tree = component.toJSON();
        expect(tree).toMatchSnapshot();
    })

});