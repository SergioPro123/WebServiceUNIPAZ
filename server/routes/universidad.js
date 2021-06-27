const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearUniversidad = [
    body('nombre_barrio').isString(),
    body('nombre_universidad').isString(),
    body('direccion').isString(),
    body('telefono').isString(),
    body('sitio_web').isString(),
    body('sector').isString(),
];

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

//API que agrega una nueva universidad
app.post('/API/barrancabermeja/universidades', validacionCrearUniversidad, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddUniversidad('${req.body.nombre_barrio}','${req.body.nombre_universidad}','${req.body.direccion}','${req.body.telefono}','${req.body.sitio_web}','${req.body.sector}');`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar una universidad.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: 'Universidad agregado con exito!.',
        });
    });
});

module.exports = {
    app,
};
