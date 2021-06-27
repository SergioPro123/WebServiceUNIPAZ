const sendDataJson = (res, data) => {
    res.status(200).json({
        ok: true,
        data,
    });
};

module.exports = {
    sendDataJson,
};
