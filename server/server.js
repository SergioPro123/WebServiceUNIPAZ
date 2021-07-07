const express = require('express');
const app = express();
const hbs = require('hbs');
const path = require('path');
var favicon = require('serve-favicon');

const bodyParser = require('body-parser');

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());
app.use(favicon(path.join(path.resolve(__dirname, '../public'), '/img/logo_final_unipaz.ico')));
app.use(express.static(path.resolve(__dirname, '../public')));
//Express HBS engine
app.set('view engine', 'hbs');
hbs.registerPartials(path.resolve(__dirname, '../views'));

//Configuracion
require('./config/config');

//Importamos las rutas
app.use(require('./routes/config').app);

app.listen(process.env.PORT, () => {
    console.log('Escuchando en el puerto ' + process.env.PORT);
});
