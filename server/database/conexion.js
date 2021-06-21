const mysql = require('mysql');
const { capitalizarObjeto } = require('../functions/funciones');

class MySQL {
    constructor() {
        this.conectado = false;
        console.log('clase inicializada');
        this.conexion = mysql.createConnection({
            host: process.env.HOSTMYSQL,
            user: process.env.USERMYSQL,
            password: process.env.PASSWORDMYSQL,
            database: process.env.DATABASEMYSQL,
        });

        this.conectarDB();
    }
    static get instance() {
        return this._instance || (this._instance = new this());
    }
    static ejecutarQuery(query, callback) {
        this.instance.conexion.query(query, (err, result, fields) => {
            if (err) {
                console.log('Error : ' + err);
                return callback(err);
            }
            if (result.length == 0) {
                callback('El registro solicitado no Existe');
            } else {
                callback(null, result);
            }
        });
    }

    static getDatos(query, callback) {
        this.instance.conexion.query(query, (err, result, fields) => {
            if (err) {
                console.log('Error : ' + err);
                return callback(err);
            }
            let resultados = [];

            if (result.length > 0) {
                //Obtengo los valores del resultado y los asigno a un objeto.
                result[0].map(function (obj, index) {
                    resultados[index] = { ...obj };
                    resultados[index] = capitalizarObjeto(resultados[index]);
                });
            }
            callback(null, resultados);
        });
    }
    conectarDB() {
        this.conexion.connect((err) => {
            if (err) {
                console.log(err.message);
                return;
            }
            this.conectado = true;
            console.log('Base de Datos Conectada con Exito');
        });
    }
}
module.exports = {
    MySQL,
};
