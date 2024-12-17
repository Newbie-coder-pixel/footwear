import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

FirebaseOptions firebaseOptions = Platform.isAndroid
    ? const FirebaseOptions(
    apiKey: 'AIzaSyDEtCITzhPeJx9AF9vN3A5g350To4s4wUw',
    appId: '1:865354838479:android:a3acc9e093fa028c4ce2ba',
    messagingSenderId: '865354838479',
    projectId: 'footwear-c0e86')

    : const FirebaseOptions(
    apiKey: 'AIzaSyAxm7OsSJ-nY6FqcTSj-oed9BtTIsVw3nw',
    appId: '1:865354838479:ios:9e4b12f84aa653444ce2ba',
    messagingSenderId: '865354838479',
    projectId: 'footwear-c0e86');


