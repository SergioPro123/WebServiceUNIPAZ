const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');
//API para obtener todas las comunas.
app.get('/API/barrancabermeja/comunas', (req, res) => {
    MySQL.getDatos('CALL getComunas();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener una comuna en especifica
app.get('/API/barrancabermeja/comunas/:n_comuna', (req, res) => {
    MySQL.getDatos(`CALL getComunasByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
