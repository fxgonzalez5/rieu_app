import 'package:rieu/domain/entities/entities.dart';

class OrganizationMapper {
  static OrganizationProfile organizationProfileJsonToEntity(Map<String, dynamic> json) => OrganizationProfile(
    name: json["name"],
    slogan: json["slogan"],
    imagePath: json["imagePath"],
    website: json["website"],
  );
}