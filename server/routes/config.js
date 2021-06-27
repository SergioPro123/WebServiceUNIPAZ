const express = require('express');
const app = express();

app.use(require('./comuna').app);
app.use(require('./barrio').app);

module.exports = {
    app,
};
