import 'package:rieu/domain/entities/organization_profile.dart';

abstract class OrganizationsProfilesRepository {
  Future<List<OrganizationProfile>> getOrganizations();
}