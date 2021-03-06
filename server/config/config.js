//---------------------------------------
//                 PUERTO
//---------------------------------------
process.env.PORT = process.env.PORT || 3000;

//=================================
//      Vencimiento del Token
//=================================
// 60 segundos * 60 minutos * 24 horas * 30 dias

process.env.CADUCIDAD_TOKEN = '48h';

//=================================
//        SEED de autenticación
//=================================

process.env.SEED = process.env.SEED || 'SEED-DESARROLLO';

//---------------------------------------
//       CONFIGURACIONES DE MYSQL
//---------------------------------------
process.env.HOSTMYSQL = process.env.HOSTMYSQL || 'localhost';
process.env.USERMYSQL = process.env.USERMYSQL || 'root';
process.env.PASSWORDMYSQL = process.env.PASSWORDMYSQL || '';
process.env.DATABASEMYSQL = process.env.DATABASEMYSQL || 'apiwebserviceunipaz';
