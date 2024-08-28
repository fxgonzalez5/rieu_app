import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rieu/domain/datasources/organizations_profiles_datasource.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/mappers/organization_mapper.dart';

class LocalOrganizationsDatasource implements OrganizationsProfilesDatasource {
  final String jsonPath;

  LocalOrganizationsDatasource({required this.jsonPath});
  
  @override
  Future<List<OrganizationProfile>> getOrganizations() async {
    final jsonString = await rootBundle.loadString(jsonPath);
    final data = jsonDecode(jsonString);
    final List<OrganizationProfile> organizations = [];
    for (var organization in data ?? []) {
      organizations.add(OrganizationMapper.organizationProfileJsonToEntity(organization));
    }    
    return organizations;
  }

}