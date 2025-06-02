import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:tetra_stats/views/destination_home.dart';

class ErrorThingy extends StatelessWidget{
  final FetchResults? data;
  final String? eText;

  const ErrorThingy({this.data, this.eText});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.error_outline;
    String errText = eText??"";
    String? subText;
    if (data?.exception != null) switch (data!.exception!.runtimeType){
      case TetrioPlayerNotExist:
      icon = Icons.search_off;
      errText = t.errors.noSuchUser;
      subText = t.errors.noSuchUserSub;
      break;
      case TetrioSearchFailed:
      icon = Icons.search_off;
      errText = (data!.exception as TetrioSearchFailed).message;
      subText = t.errors.discordNotAssignedSub;
      case TetrioNoReplays:
      icon = Icons.videogame_asset_off;
      errText = "No replays avaliable for analysis";
      subText = "mb ask that player to play TL?";
      case ConnectionIssue:
      var err = data!.exception as ConnectionIssue;
      errText = t.errors.connection(code: err.code, message: err.message);
      break;
      case TetrioForbidden:
      icon = Icons.remove_circle;
      errText = t.errors.forbidden;
      subText = t.errors.forbiddenSub(nickname: 'osk');
      break;
      case TetrioTooManyRequests:
      errText = t.errors.tooManyRequests;
      subText = t.errors.tooManyRequestsSub;
      break;
      case TetrioOskwareBridgeProblem:
      errText = t.errors.oskwareBridge;
      subText = t.errors.oskwareBridgeSub;
      break;
      case TetrioInternalProblem:
      errText = kIsWeb ? t.errors.internalWebVersion : t.errors.internal;
      subText = kIsWeb ? t.errors.internalWebVersionSub : t.errors.internalSub;
      break;
      case ClientException:
      errText = t.errors.clientException;
      break;
      default:
      errText = data!.exception.toString();
    }
    return TweenAnimationBuilder(
      duration: Durations.medium3,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Easing.standard,
      builder: (context, value, child) {
        return Container(
          transform: Matrix4.translationValues(0, 50-value*50, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Icon(icon, size: 128.0, color: Colors.red, shadows: [
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 30.0, color: Colors.red),
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 80.0, color: Colors.red),
          ]),
          Text(errText, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          if (subText != null) Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MarkdownBody(data: subText, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center), onTapLink: (String text, String? href, String title){launchInBrowser(Uri.parse(href!));},),
          ),
          Spacer()
        ],
      ),
    );
  }
}