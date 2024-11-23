// Import necessary libraries
import React from 'react';
import { render, screen } from '@testing-library/react';

// A sample component for the test
function App() {
  return <h1>Hello, MERN Stack!</h1>;
}

// Unit test for the component
test('renders the main heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/Hello, MERN Stack!/i);
  // expect(headingElement).toBeInTheDocument();
});
