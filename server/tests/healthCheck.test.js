// Import necessary libraries
const request = require('supertest');
const express = require('express');

// Create a simple Express app
const app = express();
app.get('/health', (req, res) => res.status(200).send('Server is healthy'));

// Unit test for the health check endpoint
describe('Health Check Endpoint', () => {
  it('should return status 200 and a healthy message', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.text).toBe('Server is healthy');
  });
});
