const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');
const { body, validationResult } = require('express-validator');

const validacionCrearBarrio = [
    body('nombre_barrio').isString(),
    body('numero_habitantes').isInt(),
    body('numero_comuna').isInt(),
];

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

//API que agrega un nuevo barrio
app.post('/API/barrancabermeja/barrios', validacionCrearBarrio, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddBarrio('${req.body.nombre_barrio}',${req.body.numero_habitantes},${req.body.numero_comuna});`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar un barrio.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: '¡Barrio agregado con exito!.',
        });
    });
});

module.exports = {
    app,
};
