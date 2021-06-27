const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todos los colegio
app.get('/API/barrancabermeja/colegios', (req, res) => {
    MySQL.getDatos('CALL getColegios();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los colegios de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/colegios', (req, res) => {
    MySQL.getDatos(`CALL getColegioByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los colegios de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/colegios', (req, res) => {
    MySQL.getDatos(`CALL getColegioByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});
module.exports = {
    app,
};
