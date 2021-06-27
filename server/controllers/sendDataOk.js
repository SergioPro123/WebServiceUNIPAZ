const sendDataJson = (res, data) => {
    res.json({
        status: 200,
        data,
    });
};

module.exports = {
    sendDataJson,
};
