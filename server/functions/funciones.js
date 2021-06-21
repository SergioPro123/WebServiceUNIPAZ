const capitalizar = (myString) => {
    if (!myString || typeof myString != 'string') {
        if (myString == null || myString == undefined) {
            return '';
        }
        return myString;
    }
    let palabras = myString.split(' ');
    palabras.forEach((palabra, index) => {
        palabras[index] = palabra.charAt(0).toUpperCase() + palabra.slice(1).toLowerCase();
    });
    return palabras.join(' ');
};

const capitalizarObjeto = (objeto) => {
    for (const propiedad in objeto) {
        if (!objeto[propiedad] || typeof objeto[propiedad] != 'string' || propiedad == 'pathImage') {
            if (typeof objeto[propiedad] == 'object') {
                if (propiedad == 'fecha_creacion') {
                    console.log('object');
                }
                objeto[propiedad] = devolverFecha(objeto[propiedad]);
            }
            continue;
        }

        let palabras = objeto[propiedad].split(' ');
        palabras.forEach((palabra, index) => {
            palabras[index] = palabra.charAt(0).toUpperCase() + palabra.slice(1).toLowerCase();
        });
        objeto[propiedad] = palabras.join(' ');
    }

    return objeto;
};
const fechaActual = () => {
    let date = new Date();
    let fechaActual = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
    return fechaActual;
};

module.exports = {
    capitalizar,
    fechaActual,
    capitalizarObjeto,
};
