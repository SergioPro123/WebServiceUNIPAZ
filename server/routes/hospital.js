const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearHospital = [
    body('nombre_barrio').isString(),
    body('nombre_hospital').isString(),
    body('direccion').isString(),
    body('telefono').isString(),
    body('sitio_web').isString(),
];

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

//API para obtener todas los hospitales de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/hospitales', (req, res) => {
    MySQL.getDatos(`CALL getHospitalByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API que agrega un nuevo Hospital
app.post('/API/barrancabermeja/hospitales', validacionCrearHospital, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddHospital('${req.body.nombre_barrio}','${req.body.nombre_hospital}','${req.body.direccion}','${req.body.telefono}','${req.body.sitio_web}');`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar un hospital.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: 'Hospital agregado con exito!.',
        });
    });
});
module.exports = {
    app,
};
