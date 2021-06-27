const express = require('express');
const app = express();

app.use(require('./comuna').app);
app.use(require('./barrio').app);
app.use(require('./mensajeria').app);
app.use(require('./hospital').app);
app.use(require('./banco').app);
app.use(require('./universidad').app);
app.use(require('./colegio').app);

module.exports = {
    app,
};
