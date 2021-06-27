const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todos los barrios.
app.get('/API/barrancabermeja/barrios', (req, res) => {
    MySQL.getDatos('CALL getBarrios();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los barrios de una comuna en especifica.
app.get('/API/barrancabermeja/barrios/:n_comuna', (req, res) => {
    MySQL.getDatos(`CALL getBarriosByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
