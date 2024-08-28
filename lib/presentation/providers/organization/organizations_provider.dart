import 'package:flutter/foundation.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/organizations_profiles_repository.dart';

class OrganizationsProvider extends ChangeNotifier {
  final OrganizationsProfilesRepository organizationsRepository;
  final List<OrganizationProfile> organizationsProfiles = [];

  OrganizationsProvider({required this.organizationsRepository}){
    loadOrganizationsProfiles();
  }

  Future<void> loadOrganizationsProfiles() async {
    final organizations = await organizationsRepository.getOrganizations();
    organizationsProfiles.addAll(organizations);
    notifyListeners();
  }

}