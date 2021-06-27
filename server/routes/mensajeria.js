const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearMensajeria = [
    body('nombre_barrio').isString(),
    body('nombre_mensajeria').isString(),
    body('direccion').isString(),
    body('telefono').isString(),
    body('sitio_web').isString(),
];

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

//API que agrega una nueva mensajeria
app.post('/API/barrancabermeja/mensajerias', validacionCrearMensajeria, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddMensajeria('${req.body.nombre_barrio}','${req.body.nombre_mensajeria}','${req.body.direccion}','${req.body.telefono}','${req.body.sitio_web}');`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar una mensajeria.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: 'Mensajeria agregado con exito!.',
        });
    });
});
module.exports = {
    app,
};
