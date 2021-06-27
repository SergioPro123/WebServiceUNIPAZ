const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

//API para obtener todos los hospitales
app.get('/API/barrancabermeja/hospitales', (req, res) => {
    MySQL.getDatos('CALL getHospitales();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todas los hospitales de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/hospitales', (req, res) => {
    MySQL.getDatos(`CALL getHospitalByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los hospitales de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/hospitales', (req, res) => {
    MySQL.getDatos(`CALL getHospitalByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
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
