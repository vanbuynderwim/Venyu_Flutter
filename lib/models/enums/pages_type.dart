import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

enum PagesType {
  profileEdit,
  location;

  // Helper methods
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PagesType.profileEdit:
        return l10n.pagesProfileEditTitle;
      case PagesType.location:
        return l10n.pagesLocationTitle;
    }
  }

  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PagesType.profileEdit:
        return l10n.pagesProfileEditDescription;
      case PagesType.location:
        return l10n.pagesLocationDescription;
    }
  }
}