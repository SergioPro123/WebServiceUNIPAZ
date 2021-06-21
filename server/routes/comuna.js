const express = require('express');
const app = express();

const { MySQL } = require('../database/conexion');

app.get('/API/barrancabermeja/comunas', (req, res) => {
    MySQL.ejecutarQuery('SELECT 1+1', (err, data) => {
        res.send(data);
    });
});

module.exports = {
    app,
};
