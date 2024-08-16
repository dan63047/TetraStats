// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:test/test.dart';
// import 'package:tetra_stats/data_objects/tetrio.dart';
// import 'package:tetra_stats/services/crud_exceptions.dart';
// import 'package:tetra_stats/services/tetrio_crud.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   late TetrioService teto;
//   setUp(() {
//     if (kIsWeb) {
//       sqfliteFfiInit();
//       databaseFactory = databaseFactoryFfiWeb;
//     } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       sqfliteFfiInit();
//       databaseFactory = databaseFactoryFfi;
//     }
//     teto = TetrioService();
//   });
  
//   test("Initialize TetrioServise", () async {
//     teto.open();
//   }); // a fucking MissingPluginException how does that even happening?
//   // i guess i will be unable to test iteractions with DB

//   group("Test fetchPlayer with different players", () {
//     // those tests exist in order to detect a tiny little change in Tetra Channel API in case of some update. 
//     test("dan63047 (user who have activity in tetra league)", () async {
//       TetrioPlayer dan63047 = await teto.fetchPlayer("6098518e3d5155e6ec429cdc");
//       expect(dan63047.userId, "6098518e3d5155e6ec429cdc");
//       expect(dan63047.registrationTime != null, true);
//       expect(dan63047.avatarRevision != null, true);
//       expect(dan63047.connections != null, true);
//       expect(dan63047.role, "user");
//       expect(dan63047.distinguishment, null); // imagine if that one fails one day lol
//       expect(dan63047.tlSeason1.glicko != null, true);
//       //expect(dan63047.tlSeason1.rank != "z", true); lol
//       expect(dan63047.tlSeason1.percentileRank != "z", true);
//       expect(dan63047.tlSeason1.tr > -1, true);
//       expect(dan63047.tlSeason1.gamesPlayed > 9, true);
//       expect(dan63047.tlSeason1.gamesWon > 0, true);
//       //expect(dan63047.tlSeason1.standing, -1);
//       //expect(dan63047.tlSeason1.standingLocal, -1);
//       expect(dan63047.tlSeason1.apm != null, true);
//       expect(dan63047.tlSeason1.pps != null, true);
//       expect(dan63047.tlSeason1.vs != null, true);
//       expect(dan63047.tlSeason1.nerdStats != null, true);
//       expect(dan63047.tlSeason1.estTr != null, true);
//       expect(dan63047.tlSeason1.esttracc != null, true);
//       expect(dan63047.tlSeason1.playstyle != null, true);
//     });
//     test("osk (sysop who have activity in tetra league)", () async {
//       TetrioPlayer osk = await teto.fetchPlayer("5e32fc85ab319c2ab1beb07c");
//       expect(osk.userId, "5e32fc85ab319c2ab1beb07c");
//       expect(osk.registrationTime, null);
//       expect(osk.country, "XM");
//       expect(osk.avatarRevision != null, true);
//       expect(osk.bannerRevision != null, true);
//       expect(osk.connections != null, true);
//       expect(osk.verified, true);
//       expect(osk.role, "sysop");
//       expect(osk.distinguishment != null, true);
//       expect(osk.tlSeason1.glicko != null, true);
//       expect(osk.tlSeason1.glicko != null, true);
//       expect(osk.tlSeason1.rank == "z", true);
//       expect(osk.tlSeason1.percentileRank != "z", true);
//       expect(osk.tlSeason1.tr > -1, true);
//       expect(osk.tlSeason1.gamesPlayed > 9, true);
//       expect(osk.tlSeason1.gamesWon > 0, true);
//       expect(osk.tlSeason1.standing, -1);
//       expect(osk.tlSeason1.standingLocal, -1);
//       expect(osk.tlSeason1.apm != null, true);
//       expect(osk.tlSeason1.pps != null, true);
//       expect(osk.tlSeason1.vs != null, true);
//       expect(osk.tlSeason1.nerdStats != null, true);
//       expect(osk.tlSeason1.estTr != null, true);
//       expect(osk.tlSeason1.esttracc != null, true);
//       expect(osk.tlSeason1.playstyle != null, true);
//     });
//     test("kagari (sysop who have zero activity)", () async {
//       TetrioPlayer kagari = await teto.fetchPlayer("5e331c3ce24a5a3e258f7a1b");
//       expect(kagari.userId, "5e331c3ce24a5a3e258f7a1b");
//       expect(kagari.registrationTime, null);
//       expect(kagari.country, "XM");
//       expect(kagari.xp, 0);
//       expect(kagari.gamesPlayed, -1);
//       expect(kagari.gamesWon, -1);
//       expect(kagari.gameTime, const Duration(seconds: -1));
//       expect(kagari.avatarRevision != null, true);
//       expect(kagari.bannerRevision != null, true);
//       expect(kagari.connections, null);
//       expect(kagari.verified, true);
//       expect(kagari.distinguishment != null, true);
//       expect(kagari.distinguishment!.detail, "kagarin");
//       expect(kagari.friendCount, 1);
//       expect(kagari.tlSeason1.glicko, null);
//       expect(kagari.tlSeason1.rank, "z");
//       expect(kagari.tlSeason1.percentileRank, "z");
//       expect(kagari.tlSeason1.tr, -1);
//       expect(kagari.tlSeason1.decaying, false);
//       expect(kagari.tlSeason1.gamesPlayed, 0);
//       expect(kagari.tlSeason1.gamesWon, 0);
//       expect(kagari.tlSeason1.standing, -1);
//       expect(kagari.tlSeason1.standingLocal, -1);
//       expect(kagari.tlSeason1.apm, null);
//       expect(kagari.tlSeason1.pps, null);
//       expect(kagari.tlSeason1.vs,  null);
//       expect(kagari.tlSeason1.nerdStats, null);
//       expect(kagari.tlSeason1.estTr, null);
//       expect(kagari.tlSeason1.esttracc, null);
//       expect(kagari.tlSeason1.playstyle, null);
//     });
//     test("furry (banned account)", () async {
//       TetrioPlayer furry = await teto.fetchPlayer("5eea0ff69a1ba76c20347086");
//       expect(furry.userId, "5eea0ff69a1ba76c20347086");
//       expect(furry.registrationTime, DateTime.parse("2020-06-17T12:43:34.790Z"));
//       expect(furry.role, "banned");
//       expect(furry.badges.isEmpty, true);
//       expect(furry.badstanding, false);
//       expect(furry.xp, 0);
//       expect(furry.supporterTier, 0);
//       expect(furry.verified, false);
//       expect(furry.connections, null);
//       expect(furry.gamesPlayed, 0);
//       expect(furry.gamesWon, 0);
//       expect(furry.gameTime, Duration.zero);
//       expect(furry.tlSeason1.glicko, null);
//       expect(furry.tlSeason1.rank, "z");
//       expect(furry.tlSeason1.percentileRank, "z");
//       expect(furry.tlSeason1.tr, -1);
//       expect(furry.tlSeason1.decaying, false);
//       expect(furry.tlSeason1.gamesPlayed, 0);
//       expect(furry.tlSeason1.gamesWon, 0);
//       expect(furry.tlSeason1.standing, -1);
//       expect(furry.tlSeason1.standingLocal, -1);
//       expect(furry.tlSeason1.apm, null);
//       expect(furry.tlSeason1.pps, null);
//       expect(furry.tlSeason1.vs,  null);
//       expect(furry.tlSeason1.nerdStats, null);
//       expect(furry.tlSeason1.estTr, null);
//       expect(furry.tlSeason1.esttracc, null);
//       expect(furry.tlSeason1.playstyle, null);
//     });
//     test("oskwarefan (anon account)", () async {
//       TetrioPlayer oskwarefan = await teto.fetchPlayer("646cb8273e887a054d64febe");
//       expect(oskwarefan.userId, "646cb8273e887a054d64febe");
//       expect(oskwarefan.registrationTime, DateTime.parse("2023-05-23T12:57:11.481Z"));
//       expect(oskwarefan.role, "anon");
//       expect(oskwarefan.xp > 0, true);
//       expect(oskwarefan.gamesPlayed > -1, true);
//       expect(oskwarefan.gamesWon > -1, true);
//       expect(oskwarefan.gameTime.isNegative, false);
//       expect(oskwarefan.country, null);
//       expect(oskwarefan.verified, false);
//       expect(oskwarefan.connections, null);
//       expect(oskwarefan.friendCount, 0);
//       expect(oskwarefan.tlSeason1.glicko, null);
//       expect(oskwarefan.tlSeason1.rank, "z");
//       expect(oskwarefan.tlSeason1.percentileRank, "z");
//       expect(oskwarefan.tlSeason1.tr, -1);
//       expect(oskwarefan.tlSeason1.decaying, true); // ??? why true?
//       expect(oskwarefan.tlSeason1.gamesPlayed, 0);
//       expect(oskwarefan.tlSeason1.gamesWon, 0);
//       expect(oskwarefan.tlSeason1.standing, -1);
//       expect(oskwarefan.tlSeason1.standingLocal, -1);
//       expect(oskwarefan.tlSeason1.apm, null);
//       expect(oskwarefan.tlSeason1.pps, null);
//       expect(oskwarefan.tlSeason1.vs,  null);
//       expect(oskwarefan.tlSeason1.nerdStats, null);
//       expect(oskwarefan.tlSeason1.estTr, null);
//       expect(oskwarefan.tlSeason1.esttracc, null);
//       expect(oskwarefan.tlSeason1.playstyle, null);
//     });

//     test("not existing account", () async {
//       var future = teto.fetchPlayer("hasdbashdbs");
//       await expectLater(future, throwsA(isA<TetrioPlayerNotExist>()));
//     });
//   });
// }