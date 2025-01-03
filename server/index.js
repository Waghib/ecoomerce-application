require('dotenv').config();
const express = require('express');
const chalk = require('chalk');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');

const keys = require('./config/keys');
const routes = require('./routes');
const socket = require('./socket');
const setupDB = require('./utils/db');

const { port } = keys;
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(
  helmet({
    contentSecurityPolicy: false,
    frameguard: true
  })
);
app.use(cors());

// Serve static files from the React app
app.use(express.static(path.join(__dirname, '../client/public')));

setupDB();
require('./config/passport')(app);

// Debug middleware to log all requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

app.use(routes);

const server = app.listen(port, () => {
  console.log(
    `${chalk.green('✓')} ${chalk.blue(
      `Listening on port ${port}. Visit http://localhost:${port}/ in your browser.`
    )}`
  );
  console.log('API URL:', keys.app.apiURL);
});

socket(server);
