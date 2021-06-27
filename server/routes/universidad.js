const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todas las universidades
app.get('/API/barrancabermeja/universidades', (req, res) => {
    MySQL.getDatos('CALL getUniversidades();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas las universidades de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/universidades', (req, res) => {
    MySQL.getDatos(`CALL getUniversidadByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas las universidades de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/universidades', (req, res) => {
    MySQL.getDatos(`CALL getUniversidadByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
