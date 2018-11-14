/*
 * HackTeamFive - FriendsGiving
 * Nov 13, 2018
 * shawn chen - rob bridgeman - jay peters
 */

const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const path = require('path');
const app = express();
const version = '1.0';

app.use(bodyParser.json());
//app.use(express.static(__dirname + '/quote/dist/quote'));

app.listen(8000, function () {
    console.log(`FriendsGiving v.${version} - listening on port 8000`);
})

mongoose.connect('mongodb://localhost/friendsGiving', { useNewUrlParser: true });

// user require a name and email to register
const UserSchema = new mongoose.Schema({
    name: { type: String }, // required: [true, 'Author name cannot be empty'], minlength: [2, 'Name must be 2 characters or longer'] },
    email: { type: String, required: true },
    password: { type: String, require: true }
}, { timestamps: true })

// dishes are submitted with a lable, e.g., name of the dish along with the submitted user id
const DishSchema = new mongoose.Schema({
    label: { type: String, required: true },
    category: { type: String },
    submittedBy: { type: String }
}, { timestamps: true })

const EventSchema = new mongoose.Schema({
    title: { type: String, required: [true, 'Event name cannot be empty'], minlength: [3, 'Event name must be 3 characters or longer'] },
    hostName: { type: String },
    hostId: { type: String },
    location: { type: String },
    dishes: [DishSchema],
    schedule: { type: Date }
}, { timestamps: true })

const User = mongoose.model('users', UserSchema);
const Event = mongoose.model('events', EventSchema);

// routes here

// get all events to display
app.get('/events', (req, res) => {
    Event.find({}, (err, data) => {
        if (err) {
            console.log('error encountered fetching all events');
            res.json(err);
        }
        else {
            console.log(`fetched events ${data}`);
            res.json(data);
        }
    })
})

// get one event by id
app.get('/event/:id', (req, res) => {
    Event.findOne({_id: req.params.id}, (err, data) => {
        if (err) {
            console.log('Encountered error fetching event');
            res.json(err);
        }
        else {
            console.log('Successfully fetched event -> ', data);
            res.json(data);
        }
    })
})

// add an event
app.post('/addEvent', (req, res) => {
    Event.create(req.body, (err, data) => {
        if (err) {
            console.log('Encountered error adding event');
            res.json(err);
        }
        else {
            console.log('Successfully added event -> ', data);
            res.json(data);
        }
    })
})

// add a dish by event ID
app.post('/addDishByEvent/:id', (req, res) => {
    console.log(`pushing ${req.body} into dishes`);
    console.log(`-> ${req.body.label} ${req.body.category} on ${req.params.id}`);
    Event.updateOne({ _id: req.params.id }, {$push: {dishes: req.body}}, (err, data) => {
        if (err) {
            console.log('Encountered error adding a dish');
            res.json(err);
        }
        else {
            console.log('Successfully added the new dish -> ', data);
            res.json(data);
        }
    })
})


app.post('/addUser', (req, res) => {
    User.create(req.body, (err, data) => {
        if (err) {
            console.log('Encountered error adding user');
            res.json(err);
        }
        else {
            console.log('Successfully added user -> ', data);
            res.json(data);
        }
    })
})

// find, get user by ID
app.get('/user/:id', (req, res) => {
    User.findOne({ _id: req.params.id}, (err, data) => {
        if (err) {
            console.log('Encountered error locating user');
            res.json(err);
        }
        else {
            console.log('Successfully located user ', data);
            res.json(data);
        }
    })
})

// update a dish by the dish's id (not event)
// ** iOS front-end will fetch and retain event id for purpose of query and update **
app.put('/updateDish/:id', (req, res) => {
    console.log('dish update--> ',req.body);
    Event.updateOne({ quotes: {$elemMatch: { _id : req.params.id}}}, {$set: { 'dishes.$.label': req.body.votes, 
        'dishes.$.category': req.body.category, 'dishes.$.submittedBy': req.body.submittedBy }}, (err, data) => {
        if (err) {
            console.log('Encountered error updating dishes info on event');
            res.json(err);
        }
        else {
            console.log('Successfully updated dish by event', data);
            res.json(data);
        }
    })
})

// delete a event 
app.delete('/deleteEvent/:id', (req, res) => {
    console.log('deleting an Event', req.params.id);
    Event.remove({ _id : req.params.id }, (err, data) => {
        if (err) {
            console.log('Encountered error deleting the event');
            res.json(err);
        }
        else {
            console.log('Successfully deleted the event', data);
            res.json(data);
        }
    })
})

// delete a dish
app.delete('/deleteDish/:id', (req, res) => {
    console.log('deleting a quote ', req.params.id);
    Event.update({ dishes: {$elemMatch: { _id : req.params.id }}}, {$pull: { dishes: { _id: req.params.id}}}, (err, data) => {
        if (err) {
            console.log('Encountered error deleting the dish');
            res.json(err);
        }
        else {
            console.log('Successfully deleted the dish', data);
            res.json(data);
        }
    })
})
