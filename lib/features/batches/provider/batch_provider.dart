import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/batch_model.dart';

final batchListProvider =
    StateNotifierProvider<BatchNotifier, AsyncValue<List<BatchModel>>>((ref) {
      return BatchNotifier();
    });

class BatchNotifier extends StateNotifier<AsyncValue<List<BatchModel>>> {
  BatchNotifier() : super(const AsyncLoading()) {
    getBatches();
  }

  final _firestore = FirebaseFirestore.instance;

  Future<void> getBatches() async {
    try {
      final snapshot = await _firestore.collection('batches').get();
      final batches = snapshot.docs
          .map((doc) => BatchModel.fromMap(doc.data()))
          .toList();
      state = AsyncValue.data(batches);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBatch(BatchModel batch) async {
    try {
      await _firestore.collection('batches').doc(batch.id).set(batch.toMap());
      await getBatches(); // refresh
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
