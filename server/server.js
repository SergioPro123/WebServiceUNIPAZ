const express = require('express');
const app = express();

const bodyParser = require('body-parser');

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

//Configuracion
require('./config/config');

//Importamos las rutas
app.use(require('./routes/config').app);

app.listen(process.env.PORT, () => {
    console.log('Escuchando en el puerto ' + process.env.PORT);
});
