// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sol_connect/core/api/models/utils.dart';
import 'package:sol_connect/core/api/usersession.dart';
import 'package:sol_connect/core/excel/models/phasestatus.dart';
import 'package:sol_connect/core/excel/solc_api_manager.dart';
import 'package:sol_connect/core/excel/solcresponse.dart';
import 'package:sol_connect/core/exceptions.dart';
import 'package:sol_connect/core/service/services.dart';
import 'package:sol_connect/ui/screens/settings/widgets/custom_settings_card.dart';
import 'package:sol_connect/ui/screens/settings/widgets/developer_options.dart';
import 'package:sol_connect/ui/screens/settings/widgets/info_dialog.dart';
import 'package:sol_connect/ui/shared/created_by.text.dart';
import 'package:sol_connect/util/logger.util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({Key? key}) : super(key: key);
  static final routeName = (SettingsScreen).toString();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = getLogger();

    final theme = ref.watch(themeService).theme;
    final phaseLoaded = ref.watch(timeTableService).isPhaseVerified;
    final validator = ref.watch(timeTableService).validator;

    bool darkMode;
    bool working = false;

    SnackBar _createSnackbar(String message, Color backgroundColor, {Duration duration = const Duration(seconds: 4)}) {
      return SnackBar(
        duration: duration,
        elevation: 20,
        backgroundColor: backgroundColor,
        content: Text(message, style: TextStyle(fontSize: 17, color: theme.colors.text)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
      );
    }

    // The saved appearance is loaded on App start. This is only for the switch.
    if (theme.mode == ThemeMode.light) {
      darkMode = false;
    } else {
      darkMode = true;
    }

    if (ref.watch(settingsService).showDeveloperOptions) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Einstellungen', style: TextStyle(color: theme.colors.text)),
          backgroundColor: theme.colors.primary,
          leading: BackButton(color: theme.colors.icon),
        ),
        body: Container(
          color: theme.colors.background,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          "Erscheinungsbild",
                          style: TextStyle(fontSize: 25, color: theme.colors.textInverted),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: theme.colors.primary,
                        child: SwitchListTile(
                          value: darkMode,
                          onChanged: (bool value) {
                            ref.read(themeService).saveAppearence(value);
                          },
                          title: Text(
                            "Dark Mode",
                            maxLines: 1,
                            style: TextStyle(color: theme.colors.text),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          inactiveThumbColor: theme.colors.text,
                          activeTrackColor: theme.colors.background,
                          activeColor: theme.colors.text,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          "App Info",
                          style: TextStyle(fontSize: 25, color: theme.colors.textInverted),
                        ),
                      ),
                    ),
                    CustomSettingsCard(
                      leading: Icon(
                        FontAwesome.github_circled,
                        color: theme.colors.text,
                      ),
                      text: "Github Projekt",
                      onTap: () async {
                        String url = "https://github.com/floodoo/untis_phasierung";
                        if (!await launchUrlString(url)) {
                          throw "Could not launch $url";
                        }
                      },
                    ),
                    CustomSettingsCard(
                      leading: Icon(
                        FontAwesome.bug,
                        color: theme.colors.text,
                      ),
                      padTop: 10,
                      text: "Fehler Melden",
                      onTap: () async {
                        String url =
                            "https://github.com/floodoo/untis_phasierung/issues/new?assignees=&labels=bug&title=Untis%20Phasierung%20Fehlerbericht";
                        if (!await launchUrlString(url)) {
                          throw "Could not launch $url";
                        }
                      },
                    ),
                    CustomSettingsCard(
                      leading: Icon(
                        Icons.info,
                        color: theme.colors.text,
                      ),
                      padTop: 10,
                      padBottom: 15,
                      text: "Version 1.1.0+3",
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: CreatedByText(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
