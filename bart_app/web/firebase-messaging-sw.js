// Please see this file for the latest firebase-js-sdk version:
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_core/firebase_core_web/lib/src/firebase_sdk_version.dart
importScripts("https://www.gstatic.com/firebasejs/11.0.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/11.0.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAITaQOphywULgF5qJcJI8s0Q-kwkvvnmg",
  appId: "1:525584307325:web:2c6c2b5f11e3a9731b0d14",
  messagingSenderId: "525584307325",
  authDomain: "bart-app-a79ac.firebaseapp.com",
  projectId: "bart-app-a79ac",
  storageBucket: "bart-app-a79ac.appspot.com",
  measurementId: "G-L8E2F403NW",
});

const messaging = firebase.messaging();

// // Optional:
// messaging.onBackgroundMessage((message) => {
//   console.log("onBackgroundMessage", message);
// });

// self.addEventListener('notificationclick', event => {
//   event.notification.close();      // close the native notification

//   // Decide what URL to open—here we read it from the data you included
//   const clickUrl = event.notification.data?.url
//     ?? '/';                        // fallback to your app’s home

//   // Focus an existing tab or open a new one:
//   event.waitUntil(
//     clients.matchAll({ type: 'window', includeUncontrolled: true }).then(windowClients => {
//       for (const client of windowClients) {
//         // If there’s already a tab open, just focus it.
//         if (client.url === clickUrl && 'focus' in client) {
//           return client.focus();
//         }
//       }
//       // Otherwise, open a new tab to the clickUrl
//       if (clients.openWindow) {
//         return clients.openWindow(clickUrl);
//       }
//     })
//   );
// });
