const sendDataJson = (res, data) => {
    res.json({
        ok: true,
        status: 200,
        data,
    });
};

module.exports = {
    sendDataJson,
};
