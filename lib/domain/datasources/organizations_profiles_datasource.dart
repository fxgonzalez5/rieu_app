import 'package:rieu/domain/entities/organization_profile.dart';

abstract class OrganizationsProfilesDatasource {
  Future<List<OrganizationProfile>> getOrganizations();
}