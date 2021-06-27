const responseError = (res, err) => {
    res.json({
        ok: false,
        status: 500,
        err,
    });
};

module.exports = {
    responseError,
};
