const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const User = mongoose.model('User');

module.exports = (req, res, next) => {
    const { authorization } = req.headers;



    if (!authorization) {
        return res.status(401).send({error : 'must be logged in1'})
    }

    const token = authorization.replace('Bearer ', '')

    jwt.verify(token, 'MY_SECRET_KEY', async (err, payload) => {
        console.log(err)
        if (err) {
            return res.status(401).send({error: 'must be logged in2'})
        }

        const { userId } = payload;
        const user = await User.findById(userId);

        req.user = user;
        next();
    })
};