// @dart=2.9

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/FirestoreCollections.dart';
import 'package:fisheri/models/venue_detailed.dart';

import 'models/catch.dart';
import 'models/fisheri_image.dart';

class FirestoreRequestService {
  static const venuesDetail = 'venues_detail';

  FirestoreRequestService({
    this.firestore,
  });

  final FirebaseFirestore firestore;

  static FirestoreRequestService defaultService() {
    return FirestoreRequestService(firestore: FirebaseFirestore.instance);
  }

  Future<VenueDetailed> getVenueDetailed(String id) async {
    return await firestore
        .collection(venuesDetail)
        .doc(id)
        .get()
        .then((DocumentSnapshot document) {
      return VenueDetailed.fromJson(document.data());
    }).catchError((error) {
      print('getVenueDetailed request error: $error');
    });
  }

  Future<List<Catch>> getCatches({String catchReportID}) async {
    print('----- FETCHING CATCHES -----');
    final snapshots = await firestore
        .collection(FirestoreCollections.catches)
        .where('catch_report_id', isEqualTo: catchReportID)
        .snapshots();

    return snapshots.first.then((snapshot) {
      return snapshot.docs.map((doc) {
        var catchModel = Catch.fromJson(doc.data());
        catchModel.id = doc.id;
        return catchModel;
      }).toList();
    });
  }

  Future deleteCatch(String catchID) async {
    await FirebaseFirestore
        .instance
        .collection(FirestoreCollections.catches)
        .doc(catchID)
        .delete()
        .catchError((error) => print(error));
  }
  
  Future deleteCatchReport(String catchReportID) async {
    await FirebaseFirestore
        .instance
        .collection(FirestoreCollections.catchReports)
        .doc(catchReportID)
        .delete()
        .catchError((error) => print(error));
  }

  Future deleteCatchesForCatchReport(String catchReportID) async {
    await firestore.collection(FirestoreCollections.catches).where('catch_report_id', isEqualTo: catchReportID).get()
        .then((querySnapshot) {
        // Once we get the results, begin a batch
        var batch = firestore.batch();
        querySnapshot.docs.forEach((document) {
        // For each doc, add a delete operation to the batch
        batch.delete(document.reference);
  });
    // Commit the batch
    return batch.commit();
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

  Future<String> getVenueImageURL(String assetPath, int index) async {
    final imageURL = await firebaseStorage.ref().child('venues').child(assetPath).child('images').child('lake_$index.jpg').getDownloadURL();
    print('IMAGE URL: $imageURL');
    return await imageURL;
  }

  Future<String> getImages(String assetPath) async {
    final imageURL = await firebaseStorage.ref().child('venues').child(assetPath).child('images').getDownloadURL();
    print('IMAGE URL: $imageURL');
    return await imageURL;
  }

  Future deleteImages(List<FisheriImage> imageURLs) async {
    imageURLs.forEach((imageURL) async
    {
      await FirebaseStorage
          .instance
          .refFromURL(imageURL.url)
          .delete();
    });
  }

}

