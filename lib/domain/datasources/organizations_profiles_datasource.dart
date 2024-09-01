import 'package:rieu/domain/entities/organization_profile.dart';

abstract class OrganizationsProfilesDataSource {
  Future<List<OrganizationProfile>> getOrganizations();
}