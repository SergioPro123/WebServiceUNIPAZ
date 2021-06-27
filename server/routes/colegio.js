const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');
const { responseError } = require('../controllers/error');
const { sendDataJson } = require('../controllers/sendDataOk');

const { body, validationResult } = require('express-validator');

const validacionCrearUniversidad = [
    body('nombre_barrio').isString(),
    body('nombre_colegio').isString(),
    body('direccion').isString(),
    body('telefono').isString(),
    body('sitio_web').isString(),
    body('sector').isString(),
    body('modalidad').isString(),
];

//API para obtener todos los colegio
app.get('/API/barrancabermeja/colegios', (req, res) => {
    MySQL.getDatos('CALL getColegios();', (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los colegios de un barrio en especifico
app.get('/API/barrancabermeja/barrios/:nombre_barrio/colegios', (req, res) => {
    MySQL.getDatos(`CALL getColegioByBarrio('${req.params.nombre_barrio}');`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API para obtener todos los colegios de una comuna en especifico
app.get('/API/barrancabermeja/comunas/:n_comuna/colegios', (req, res) => {
    MySQL.getDatos(`CALL getColegioByNumeroComuna(${req.params.n_comuna});`, (err, data) => {
        if (err) {
            var { sql, ...err } = err;
            return responseError(res, err);
        }
        sendDataJson(res, data);
    });
});

//API que agrega un nuevo colegio
app.post('/API/barrancabermeja/colegios', validacionCrearUniversidad, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const query = `CALL AddColegio('${req.body.nombre_barrio}','${req.body.nombre_colegio}','${req.body.direccion}','${req.body.telefono}','${req.body.sitio_web}','${req.body.sector}','${req.body.modalidad}');`;

    MySQL.ejecutarQuery(query, (err, result) => {
        if (err) {
            var { sql, ...err } = err;
            return res.status(500).json({
                ok: false,
                msj: 'Error al agregar un colegio.',
                err,
            });
        }
        return res.json({
            ok: true,
            msj: 'Colegio agregado con exito!.',
        });
    });
});

module.exports = {
    app,
};
