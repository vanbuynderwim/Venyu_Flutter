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
  companyName,
  personalInfo,
  links,
  deleteAccount,
  exportData,
  logout,
  rateUs,
  followUs,
  testimonial,
  terms,
  privacy,
  support,
  featureRequest,
  bug,
  notifications,
  locationSettings,
  linkedIn,
  blockedUsers,
  autoIntroduction,
  inviteCodes,
  radius;

  @override
  String get id => toString();

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AccountSettingsType.companyName:
        return l10n.editCompanyInfoNameTitle;
      case AccountSettingsType.personalInfo:
        return l10n.accountSettingsPersonalInfoTitle;
      case AccountSettingsType.links:
        return l10n.accountSettingsLinksTitle;
      case AccountSettingsType.deleteAccount:
        return l10n.accountSettingsDeleteAccountTitle;
      case AccountSettingsType.exportData:
        return l10n.accountSettingsExportDataTitle;
      case AccountSettingsType.logout:
        return l10n.accountSettingsLogoutTitle;
      case AccountSettingsType.rateUs:
        return l10n.accountSettingsRateUsTitle;
      case AccountSettingsType.followUs:
        return l10n.accountSettingsFollowUsTitle;
      case AccountSettingsType.testimonial:
        return l10n.accountSettingsTestimonialTitle;
      case AccountSettingsType.terms:
        return l10n.accountSettingsTermsTitle;
      case AccountSettingsType.privacy:
        return l10n.accountSettingsPrivacyTitle;
      case AccountSettingsType.support:
        return l10n.accountSettingsSupportTitle;
      case AccountSettingsType.featureRequest:
        return l10n.accountSettingsFeatureRequestTitle;
      case AccountSettingsType.bug:
        return l10n.accountSettingsBugTitle;
      case AccountSettingsType.notifications:
        return l10n.accountSettingsNotificationsTitle;
      case AccountSettingsType.locationSettings:
        return l10n.accountSettingsLocationSettingsTitle;
      case AccountSettingsType.linkedIn:
        return l10n.accountSettingsLinkedInTitle;
      case AccountSettingsType.blockedUsers:
        return l10n.accountSettingsBlockedUsersTitle;
      case AccountSettingsType.autoIntroduction:
        return l10n.accountSettingsAutoIntroductionTitle;
      case AccountSettingsType.inviteCodes:
        return l10n.accountSettingsInviteCodesTitle;
      case AccountSettingsType.radius:
        return l10n.accountSettingsRadiusTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AccountSettingsType.companyName:
        return l10n.editCompanyInfoNameDescription;
      case AccountSettingsType.personalInfo:
        return l10n.accountSettingsPersonalInfoDescription;
      case AccountSettingsType.links:
        return l10n.accountSettingsLinksDescription;
      case AccountSettingsType.deleteAccount:
        return l10n.accountSettingsDeleteAccountDescription;
      case AccountSettingsType.exportData:
        return l10n.accountSettingsExportDataDescription;
      case AccountSettingsType.logout:
        return l10n.accountSettingsLogoutDescription;
      case AccountSettingsType.rateUs:
        return l10n.accountSettingsRateUsDescription;
      case AccountSettingsType.followUs:
        return l10n.accountSettingsFollowUsDescription;
      case AccountSettingsType.testimonial:
        return l10n.accountSettingsTestimonialDescription;
      case AccountSettingsType.terms:
        return l10n.accountSettingsTermsDescription;
      case AccountSettingsType.privacy:
        return l10n.accountSettingsPrivacyDescription;
      case AccountSettingsType.support:
        return l10n.accountSettingsSupportDescription;
      case AccountSettingsType.featureRequest:
        return l10n.accountSettingsFeatureRequestDescription;
      case AccountSettingsType.bug:
        return l10n.accountSettingsBugDescription;
      case AccountSettingsType.notifications:
        return l10n.accountSettingsNotificationsDescription;
      case AccountSettingsType.locationSettings:
        return l10n.accountSettingsLocationSettingsDescription;
      case AccountSettingsType.linkedIn:
        return l10n.accountSettingsLinkedInDescription;
      case AccountSettingsType.blockedUsers:
        return l10n.accountSettingsBlockedUsersDescription;
      case AccountSettingsType.autoIntroduction:
        return l10n.accountSettingsAutoIntroductionDescription;
      case AccountSettingsType.inviteCodes:
        return l10n.accountSettingsInviteCodesDescription;
      case AccountSettingsType.radius:
        return l10n.accountSettingsRadiusDescription;
    }
  }

  @override
  String? get icon {
    switch (this) {
      case AccountSettingsType.companyName:
        return 'company';
      case AccountSettingsType.personalInfo:
        return 'profile';
      case AccountSettingsType.links:
        return 'link';
      case AccountSettingsType.deleteAccount:
        return 'delete_account';
      case AccountSettingsType.exportData:
        return 'export';
      case AccountSettingsType.logout:
        return 'logout';
      case AccountSettingsType.rateUs:
        return 'star';
      case AccountSettingsType.followUs:
        return 'linkedin';
      case AccountSettingsType.testimonial:
        return 'heart';
      case AccountSettingsType.terms:
        return 'terms';
      case AccountSettingsType.privacy:
        return 'account';
      case AccountSettingsType.support:
        return 'email';
      case AccountSettingsType.featureRequest:
        return 'bulb';
      case AccountSettingsType.bug:
        return 'report';
      case AccountSettingsType.notifications:
        return 'notification';
      case AccountSettingsType.locationSettings:
        return 'location';
      case AccountSettingsType.linkedIn:
        return 'linkedin';
      case AccountSettingsType.blockedUsers:
        return 'blocked';
      case AccountSettingsType.autoIntroduction:
        return 'handshake';
      case AccountSettingsType.inviteCodes:
        return 'ticket';
      case AccountSettingsType.radius:
        return 'network';
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
