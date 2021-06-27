const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todos los bancos
app.get('/API/barrancabermeja/bancos', (req, res) => {
    MySQL.getDatos('CALL getBancos();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas los bancos de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/bancos', (req, res) => {
    MySQL.getDatos(`CALL getBancoByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los bancos de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/bancos', (req, res) => {
    MySQL.getDatos(`CALL getBancoByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
