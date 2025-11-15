import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../tag.dart';

/// AccountSettingsType enum - represents different account settings options
///
/// This enum is used in the edit account view to represent different
/// settings that can be modified by the user.
enum AccountSettingsType implements OptionType {
  name,
  bio,
  email,
  location,
  deleteAccount,
  exportData,
  logout,
  rateUs,
  terms,
  privacy,
  support,
  featureRequest,
  notifications,
  locationSettings,
  linkedIn,
  blockedUsers;

  @override
  String get id => toString();

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AccountSettingsType.name:
        return l10n.editPersonalInfoNameTitle;
      case AccountSettingsType.bio:
        return l10n.editPersonalInfoBioTitle;
      case AccountSettingsType.location:
        return l10n.editPersonalInfoLocationTitle;
      case AccountSettingsType.email:
        return l10n.editPersonalInfoEmailTitle;
      case AccountSettingsType.deleteAccount:
        return l10n.accountSettingsDeleteAccountTitle;
      case AccountSettingsType.exportData:
        return l10n.accountSettingsExportDataTitle;
      case AccountSettingsType.logout:
        return l10n.accountSettingsLogoutTitle;
      case AccountSettingsType.rateUs:
        return l10n.accountSettingsRateUsTitle;
      case AccountSettingsType.terms:
        return l10n.accountSettingsTermsTitle;
      case AccountSettingsType.privacy:
        return l10n.accountSettingsPrivacyTitle;
      case AccountSettingsType.support:
        return l10n.accountSettingsSupportTitle;
      case AccountSettingsType.featureRequest:
        return l10n.accountSettingsFeatureRequestTitle;
      case AccountSettingsType.notifications:
        return l10n.accountSettingsNotificationsTitle;
      case AccountSettingsType.locationSettings:
        return l10n.accountSettingsLocationSettingsTitle;
      case AccountSettingsType.linkedIn:
        return l10n.accountSettingsLinkedInTitle;
      case AccountSettingsType.blockedUsers:
        return l10n.accountSettingsBlockedUsersTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AccountSettingsType.name:
        return l10n.editPersonalInfoNameDescription;
      case AccountSettingsType.bio:
        return l10n.editPersonalInfoBioDescription;
      case AccountSettingsType.location:
        return l10n.editPersonalInfoLocationDescription;
      case AccountSettingsType.email:
        return l10n.editPersonalInfoEmailDescription;
      case AccountSettingsType.deleteAccount:
        return l10n.accountSettingsDeleteAccountDescription;
      case AccountSettingsType.exportData:
        return l10n.accountSettingsExportDataDescription;
      case AccountSettingsType.logout:
        return l10n.accountSettingsLogoutDescription;
      case AccountSettingsType.rateUs:
        return l10n.accountSettingsRateUsDescription;
      case AccountSettingsType.terms:
        return l10n.accountSettingsTermsDescription;
      case AccountSettingsType.privacy:
        return l10n.accountSettingsPrivacyDescription;
      case AccountSettingsType.support:
        return l10n.accountSettingsSupportDescription;
      case AccountSettingsType.featureRequest:
        return l10n.accountSettingsFeatureRequestDescription;
      case AccountSettingsType.notifications:
        return l10n.accountSettingsNotificationsDescription;
      case AccountSettingsType.locationSettings:
        return l10n.accountSettingsLocationSettingsDescription;
      case AccountSettingsType.linkedIn:
        return l10n.accountSettingsLinkedInDescription;
      case AccountSettingsType.blockedUsers:
        return l10n.accountSettingsBlockedUsersDescription;
    }
  }

  @override
  String? get icon {
    switch (this) {
      case AccountSettingsType.name:
        return 'profile';
      case AccountSettingsType.bio:
        return 'edit';
      case AccountSettingsType.location:
        return 'map';
      case AccountSettingsType.email:
        return 'email';
      case AccountSettingsType.deleteAccount:
        return 'delete_account';
      case AccountSettingsType.exportData:
        return 'export';
      case AccountSettingsType.logout:
        return 'logout';
      case AccountSettingsType.rateUs:
        return 'star';
      case AccountSettingsType.terms:
        return 'terms';
      case AccountSettingsType.privacy:
        return 'account';
      case AccountSettingsType.support:
        return 'email';
      case AccountSettingsType.featureRequest:
        return 'bulb';
      case AccountSettingsType.notifications:
        return 'notification';
      case AccountSettingsType.locationSettings:
        return 'location';
      case AccountSettingsType.linkedIn:
        return 'linkedin';
      case AccountSettingsType.blockedUsers:
        return 'blocked';
    }
  }

  @override
  String? get emoji => null;

  @override
  Color get color => AppColors.primair4Lilac;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => null;
}
