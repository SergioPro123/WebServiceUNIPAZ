const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearBanco = [
    body('nombre_barrio').isString(),
    body('nombre_banco').isString(),
    body('direccion').isString(),
    body('telefono').isString(),
    body('sitio_web').isString(),
];

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

//API que agrega un nuevo banco
app.post('/API/barrancabermeja/bancos', validacionCrearBanco, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddBanco('${req.body.nombre_barrio}','${req.body.nombre_banco}','${req.body.direccion}','${req.body.telefono}','${req.body.sitio_web}');`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar un banco.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: 'Banco agregado con exito!.',
        });
    });
});
module.exports = {
    app,
};
