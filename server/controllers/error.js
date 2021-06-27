const responseError = (res, err) => {
    res.status(500).json({
        ok: false,
        err,
    });
};

module.exports = {
    responseError,
};
