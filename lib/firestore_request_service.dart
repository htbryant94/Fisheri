import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_detailed.dart';

class FirestoreRequestService {
  static const venuesDetail = 'venues_detail';

  FirestoreRequestService({
    this.firestore,
  });

  final Firestore firestore;

  static FirestoreRequestService defaultService() {
    return FirestoreRequestService(firestore: Firestore.instance);
  }

  Future<VenueDetailed> getVenueDetailed(String id) async {
    return await firestore
        .collection(venuesDetail)
        .document(id)
        .get()
        .then((DocumentSnapshot document) {
      return VenueDetailedJSONSerializer().fromMap(document.data);
    }).catchError((error) {
      print('getVenueDetailed request error: $error');
    });
  }
}

class FireStorageRequestService {
  FireStorageRequestService({
    this.firebaseStorage,
});

  final FirebaseStorage firebaseStorage;

  static FireStorageRequestService defaultService() {
    return FireStorageRequestService(firebaseStorage: FirebaseStorage.instance);
  }

  Future<String> getVenueHeroImageURL(String assetPath) async {
    String imageURL = await firebaseStorage.ref().child('venues').child(assetPath).child('images').child('hero.jpg').getDownloadURL();
    print('IMAGE URL: $imageURL');
    return await imageURL;
  }

}

