const express = require('express');
const app = express();

app.use(require('./comuna').app);
app.use(require('./barrio').app);
app.use(require('./mensajeria').app);
app.use(require('./hospital').app);

module.exports = {
    app,
};
