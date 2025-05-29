const admin = require("firebase-admin");
admin.initializeApp();

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const db = admin.firestore();

exports.sendStatusNotification = onDocumentCreated(
  "statuses/{statusId}",
  async (event) => {
    const statusDoc = event.data.data();
    const packageId = statusDoc.package_id;

    const statusString = [
      'Бүртгэгдсэн',
      'Монголд ирсэн',
      'Хүргэлтэнд гархад бэлэн болсон',
      'Хүлээн авсан'
    ];

    if (!packageId || typeof packageId !== 'string') {
      console.error("Invalid or missing package_id in status document.");
      return;
    }

    try {
      // 1. Get the package using package_id
      const packageSnap = await db.collection("packages").doc(packageId).get();
      if (!packageSnap.exists) {
        console.warn(`Package not found with ID: ${packageId}`);
        return;
      }

      const packageData = packageSnap.data();
      const phone = packageData.phone;
      const trackCode = packageData.track_code;

      if (!phone || typeof phone !== 'string') {
        console.error("Missing or invalid phone number in package document.");
        return;
      }

      // 2. Find user by phone number
      const usersRef = db.collection("users");
      const userQuery = await usersRef.where("phone", "==", phone).limit(1).get();

      if (userQuery.empty) {
        console.warn(`User not found with phone: ${phone}`);
        return;
      }

      const userDoc = userQuery.docs[0];
      const userData = userDoc.data();
      const fcmToken = userData.fcmToken;

      // 3. Send notification
      if (fcmToken) {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: `Ачааны төлөв шинэчлэгдлээ`,
            body: `Таны ${trackCode} дугаартай ачаа "${statusString[statusDoc.status]}" байна.`,
          },
          data: {
            screen: "status",
            statusId: event.params.statusId,
          },
        });

        console.log(`Notification sent to phone: ${phone} with token: ${fcmToken}`);
      } else {
        console.warn("No FCM token found for user with phone:", phone);
      }

    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }
);
