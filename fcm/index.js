// Import required modules
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const bodyParser = require('body-parser');

// Initialize Firebase Admin SDK
admin.initializeApp();

// Initialize Express app
const app = express();
app.use(bodyParser.json());

// Endpoint to send push notifications
app.post('/send', async (req, res) => {
  const { fcmToken, title, body } = req.body;

  if (!fcmToken || !title || !body) {
    return res.status(400).send({ success: false, error: 'Missing parameters' });
  }

  const message = {
    notification: { title, body },
    token: fcmToken,
  };

  try {
    const response = await admin.messaging().send(message);
    res.status(200).send({ success: true, response });
  } catch (error) {
    res.status(500).send({ success: false, error: error.message });
  }
});

// Export Firebase function for deployment
exports.api = functions.https.onRequest(app);
