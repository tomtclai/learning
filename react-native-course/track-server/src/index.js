require('./models/User');
require('./models/Track');
const express = require('express')
const mongoose = require('mongoose')
const app = express()
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authRoutes');
const trackRoutes = require('./routes/trackRoutes');
const requireAuth = require('./middlewares/requireAuth')

app.use(bodyParser.json());
app.use(authRoutes);
app.use(trackRoutes)

const mongouri = 'mongodb+srv://database:tigris9alloy3foretell4BITING6pibroch3mezzo@cluster0.i7hyh.mongodb.net/myFirstDatabase?retryWrites=true&w=majority'
mongoose.connect(mongouri);

mongoose.connection.on('connected', () => {
	console.log('Connected to mongo instance');
});

mongoose.connection.on('error', (err) => {
	console.log('error ', err);
});

app.get('/', requireAuth, (req, res) => {
	res.send(`your email ${req.user.email}`);
});

app.listen(3000, () => {
	console.log('listening 3000');
});