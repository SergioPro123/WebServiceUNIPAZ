const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todas las mensajerias
app.get('/API/barrancabermeja/mensajerias', (req, res) => {
    MySQL.getDatos('CALL getMensajerias();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas las mensajerias de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/mensajerias', (req, res) => {
    MySQL.getDatos(`CALL getMensajeriaByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas las mensajerias de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/mensajerias', (req, res) => {
    MySQL.getDatos(`CALL getMensajeriaByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
