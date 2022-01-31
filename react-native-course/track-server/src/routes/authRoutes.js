const express = require('express');
const mongoose = require('mongoose');
const User = mongoose.model('User');
const jwt = require('jsonwebtoken')
const router = express.Router();

router.post('/signup', async (req, res) => {
	console.log(req.body);
	const { email, password } = req.body
	try {
		const user = new User({ email, password })
		await user.save();
		const token = jwt.sign({userId: user._id}, 'MY_SECRET_KEY')
		res.send(token);
	} catch (err) {
		return res.status(422).send(err.message)
	}
})

router.post('/signin', async (req, res) => {
	const { email, password } = req.body;
	if (!email || !password) {
		return res.status(422).send({ error: 'must provide email and password' })
	}

	const user = await User.findOne({ email });
	if (!user) {
		return res.status(422).send({ error: 'Invalid credentials' })
	}
	try {
		await user.comparePassword(password);
		const token = jwt.sign({ userId: user._id }, 'MY_SECRET_KEY')
		res.send({ token });
	} catch (err) {
		return res.status(422).send({ error: 'Invalid credentials' })
	}
})
module.exports = router;
