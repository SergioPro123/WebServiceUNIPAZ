const { Sequelize } = require('sequelize');

// Option 1: Passing a connection URI
//const sequelize = new Sequelize('mysql://user@localhost:3306'); // Example for postgres

// Option 2: Passing parameters separately (other dialects)
const sequelize = new Sequelize('apiwebserviceunipaz', 'root', '', {
    host: 'localhost',
    port: '3306',
    dialect: 'mysql',
});

module.exports = {
    sequelize,
};
