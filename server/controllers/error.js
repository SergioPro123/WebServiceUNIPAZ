const responseError = (res, err) => {
    res.json({
        status: 500,
        err,
    });
};

module.exports = {
    responseError,
};
