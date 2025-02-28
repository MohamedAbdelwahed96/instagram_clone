/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewMessageNotification = functions.database
    .ref("/chats/{chatId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      const messageData = snapshot.val();
      const chatId = context.params.chatId;

      // Retrieve the list of device tokens from your database
      const tokensSnapshot = await admin.database().ref(`/chats/${chatId}/tokens`).once("value");
      const tokens = tokensSnapshot.val();

      if (!tokens) {
        console.log("No tokens available for chat:", chatId);
        return null;
      }

      const payload = {
        notification: {
          title: "New Message",
          body: messageData.text,
        },
      };

      // Send notifications to all tokens.
      const response = await admin.messaging().sendToDevice(Object.values(tokens), payload);

      // Cleanup tokens that are no longer valid.
      const tokensToRemove = [];
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          console.error("Failure sending notification to", tokens[index], error);
          // Cleanup the tokens that are not registered anymore.
          if (error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered") {
            tokensToRemove.push(admin.database().ref(`/chats/${chatId}/tokens/${index}`).remove());
          }
        }
      });
      return Promise.all(tokensToRemove);
    });
