/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
admin.initializeApp();

const REGION = 'europe-west1';

//MARK: SEND PERSONOLIZED NOTIFICATIONS
exports.sendNotification = onDocumentCreated('/push-notifications/{uid}/notifications/{notificationId}', async (event) => {
    
    try {

        const userId = event.params.uid;
        logger.log(userId);

        const message = event.data.data();
        //logger.log(message);
        logger.log('Message:', JSON.stringify(message));

        const title = message.title;
        const username = message.fromUsername;
        const imageUrl = message.imageUrl;

        const userDoc = await admin.firestore().doc(`/users/${userId}`).get();
        const userData = userDoc.data();

        

        logger.log('User data', JSON.stringify(userData));
        
        //If there is an error
        if (!userData || !userData.fcmTokens || userData.fcmTokens.length === 0) {
            throw new Error(`No FCM tokens found for user ${userId}`);
        }

        const payload = {
            notification: {
                title: 'Flavor',
                body: `${username} ${title}`, //ADD ${targetUserData.userName}
            }
        };

        if (imageUrl && imageUrl !== "") {
            payload.notification.image = imageUrl;
        }

        logger.log('Payload:', JSON.stringify(payload));

        const response = await admin.messaging().sendToDevice(userData.fcmTokens, payload);

    } catch (error) {
        
    }
    
});
