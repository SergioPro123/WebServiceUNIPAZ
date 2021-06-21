const express = require('express');
const app = express();

app.use(require('./comuna').app);

module.exports = {
    app,
};
