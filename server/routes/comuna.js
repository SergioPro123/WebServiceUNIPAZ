const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearComuna = [
    body('numero_comuna').isInt().isLength({ max: 3 }),
    body('numero_habitantes').isInt(),
    body('estrato').isInt().isLength({ max: 1 }),
];

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

//API que agrega una nueva comuna
app.post('/API/barrancabermeja/comunas', validacionCrearComuna, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddComuna(${req.body.numero_comuna},${req.body.estrato},${req.body.numero_habitantes});`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar una comuna.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: '¡Comuna agregado con exito!.',
        });
    });
});

module.exports = {
    app,
};
