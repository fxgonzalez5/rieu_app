import 'package:rieu/domain/datasources/organizations_profiles_datasource.dart';
import 'package:rieu/domain/entities/organization_profile.dart';
import 'package:rieu/domain/repositories/organizations_profiles_repository.dart';

class OrganizationsProfilesRepositoryImpl implements OrganizationsProfilesRepository {
  final OrganizationsProfilesDatasource organizationsDatasource;

  OrganizationsProfilesRepositoryImpl(this.organizationsDatasource);

  @override
  Future<List<OrganizationProfile>> getOrganizations() {
    return organizationsDatasource.getOrganizations();
  }
}