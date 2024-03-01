importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAIRO50KmNRLxF_nV9Uoro3ovXG7vzZFKI",
    authDomain: "kirihare-web.firebaseapp.com",
    projectId: "kirihare-web",
    storageBucket: "kirihare-web.appspot.com",
    messagingSenderId: "363672539637",
    appId: "1:363672539637:web:4c134516a1b50bbfdb90bc",
    measurementId: "G-DH9YHPZBPG"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});