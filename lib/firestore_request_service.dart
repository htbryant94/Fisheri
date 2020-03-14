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
