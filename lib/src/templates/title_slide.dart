import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/src/flutter_deck.dart';
import 'package:flutter_deck/src/flutter_deck_layout.dart';
import 'package:flutter_deck/src/flutter_deck_speaker_info.dart';
import 'package:flutter_deck/src/templates/slide_base.dart';
import 'package:flutter_deck/src/widgets/widgets.dart';

/// The base class for a slide that contains a title.
///
/// This class is used to create the title slide in a slide deck. It is
/// responsible for rendering the default header and footer of the slide deck,
/// and placing the [title] and [subtitle] in the correct places. Also, if the
/// [FlutterDeckSpeakerInfo] is set, it will render the speaker info below the
/// title and subtitle.
///
/// To use a custom background, you can override the [background] method.
abstract class FlutterDeckTitleSlide extends FlutterDeckSlideBase {
  /// Creates a new title slide.
  ///
  /// The [configuration] argument must not be null. This configuration
  /// overrides the global configuration of the slide deck.
  const FlutterDeckTitleSlide({
    required super.configuration,
    super.key,
  });

  /// The title of the slide.
  String get title;

  /// The subtitle of the slide.
  ///
  /// If this is null, no subtitle will be displayed.
  String? get subtitle => null;

  @override
  Widget? content(BuildContext context) {
    final speakerInfo = context.flutterDeck.speakerInfo;

    return Padding(
      padding: FlutterDeckLayout.slidePadding * 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            AutoSizeText(
              subtitle!,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
          if (speakerInfo != null) ...[
            const SizedBox(height: 64),
            _SpeakerInfo(speakerInfo: speakerInfo),
          ],
        ],
      ),
    );
  }

  @override
  Widget? header(BuildContext context) {
    final headerConfiguration = context.flutterDeck.configuration.header;

    return headerConfiguration.showHeader
        ? FlutterDeckHeader.fromConfiguration(
            configuration: headerConfiguration,
          )
        : null;
  }

  @override
  Widget? footer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final footerConfiguration = context.flutterDeck.configuration.footer;

    return footerConfiguration.showFooter
        ? FlutterDeckFooter.fromConfiguration(
            configuration: footerConfiguration,
            slideNumberColor: colorScheme.onBackground,
            socialHandleColor: colorScheme.onBackground,
          )
        : null;
  }

  @override
  Widget? background(BuildContext context) => null;
}

class _SpeakerInfo extends StatelessWidget {
  const _SpeakerInfo({
    required this.speakerInfo,
  });

  final FlutterDeckSpeakerInfo speakerInfo;

  @override
  Widget build(BuildContext context) {
    const imageHeight = 160.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          speakerInfo.imagePath,
          height: imageHeight,
          width: imageHeight,
        ),
        const SizedBox(width: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              speakerInfo.name,
              style: Theme.of(context).textTheme.displaySmall,
              maxLines: 1,
            ),
            AutoSizeText(
              speakerInfo.description,
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 1,
            ),
            AutoSizeText(
              speakerInfo.socialHandle,
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}