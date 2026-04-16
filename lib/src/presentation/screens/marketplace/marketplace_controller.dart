import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marketplace_controller.g.dart';

/// Provider for connecting to the Firestore `lawyers` collection.
/// Watch this to get real-time marketplace updates.
@riverpod
Stream<List<LawyerProfile>> marketplaceLawyers(MarketplaceLawyersRef ref) async* {
  final firestore = FirebaseFirestore.instance;

  // ── Seeding Logic (fail-safe) ──
  try {
    final limitCheck = await firestore.collection('lawyers').limit(1).get();
    if (limitCheck.docs.isEmpty) {
      await seedLawyersToFirestore(firestore);
    }
  } catch (e) {
    // Seeding failed (no internet, permissions, etc.) — continue to stream.
    // The UI will show an empty state instead of hanging forever.
  }

  // ── Real-time Binding ──
  yield* firestore.collection('lawyers').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LawyerProfile(
        id: doc.id,
        name: data['name'] as String? ?? 'Неизвестный юрист',
        specialization: data['specialization'] as String? ?? 'Специализация не указана',
        rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
        reviewsCount: data['reviewsCount'] as int? ?? 0,
        hourlyRate: data['hourlyRate'] as int? ?? 0,
        imageUrl: data['imageUrl'] as String?,
      );
    }).toList();
  });
}

/// Automatically populates Firestore with 5 realistic profiles for LegalHelp KZ
Future<void> seedLawyersToFirestore(FirebaseFirestore firestore) async {
  final batch = firestore.batch();
  final collection = firestore.collection('lawyers');

  final mockLawyers = [
    {
      'name': 'Аслан Болатов',
      'specialization': 'Уголовное право',
      'rating': 4.9,
      'reviewsCount': 124,
      'hourlyRate': 25000,
      'imageUrl': 'https://i.pravatar.cc/150?u=aslan',
    },
    {
      'name': 'Динара Смагулова',
      'specialization': 'Семейное право',
      'rating': 4.8,
      'reviewsCount': 95,
      'hourlyRate': 15000,
      'imageUrl': 'https://i.pravatar.cc/150?u=dinara',
    },
    {
      'name': 'Тимур Ахметов',
      'specialization': 'Корпоративное право',
      'rating': 5.0,
      'reviewsCount': 150,
      'hourlyRate': 30000,
      'imageUrl': 'https://i.pravatar.cc/150?u=timur',
    },
    {
      'name': 'Мадина Касенова',
      'specialization': 'Гражданские споры',
      'rating': 4.6,
      'reviewsCount': 60,
      'hourlyRate': 12000,
      'imageUrl': 'https://i.pravatar.cc/150?u=madina',
    },
    {
      'name': 'Руслан Ибрагимов',
      'specialization': 'Трудовые споры',
      'rating': 4.7,
      'reviewsCount': 85,
      'hourlyRate': 18000,
      'imageUrl': 'https://i.pravatar.cc/150?u=ruslan',
    },
  ];

  for (final data in mockLawyers) {
    batch.set(collection.doc(), data);
  }

  await batch.commit();
}

/// Lawyer Entity (Data Model)
class LawyerProfile {
  const LawyerProfile({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviewsCount,
    required this.hourlyRate,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int reviewsCount;
  final int hourlyRate;
  final String? imageUrl;
}
