// ignore_for_file: hash_and_equals

import 'dart:math';
import 'package:tetra_stats/data_objects/leaderboard_position.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';

class TetrioPlayersLeaderboard {
  late String type;
  late DateTime timestamp;
  late List<TetrioPlayerFromLeaderboard> leaderboard;

  TetrioPlayersLeaderboard(this.type, this.leaderboard);

  @override
  String toString(){
    return "$type leaderboard: ${leaderboard.length} players";
  }

  List<TetrioPlayerFromLeaderboard> getStatRanking(List<TetrioPlayerFromLeaderboard> leaderboard, Stats stat, {bool reversed = false, String country = ""}){
    List<TetrioPlayerFromLeaderboard> lb = List.from(leaderboard);
    if (country.isNotEmpty){
      lb.removeWhere((element) => element.country != country);
    }
    lb.sort(((a, b) {
      if (a.getStatByEnum(stat).isNaN) return 1;
      if (b.getStatByEnum(stat).isNaN) return -1;
      if (a.getStatByEnum(stat) > b.getStatByEnum(stat)){
        return reversed ? 1 : -1;
      }else if (a.getStatByEnum(stat) == b.getStatByEnum(stat)){
        return 0;
      }else{
        return reversed ? -1 : 1;
      }
    }));
    return lb;
  }

  List<dynamic> getAverageOfRank(String rank){ // i tried to refactor it and that's was terrible
    if (rank.isNotEmpty && !rankCutoffs.keys.contains(rank)) throw Exception("Invalid rank");
    List<TetrioPlayerFromLeaderboard> filtredLeaderboard = List.from(leaderboard); 
    if (rank.isNotEmpty) {
      filtredLeaderboard.removeWhere((element) => element.rank != rank);
    }
    if (filtredLeaderboard.isNotEmpty){
      double avgAPM = 0,
        avgPPS = 0,
        avgVS = 0,
        avgTR = 0,
        avgGlixare = 0,
        avgGlicko = 0,
        avgRD = 0,
        avgAPP = 0,
        avgVSAPM = 0,
        avgDSS = 0,
        avgDSP = 0,
        avgAPPDSP = 0,
        avgCheese = 0,
        avgGBE = 0,
        avgNyaAPP = 0,
        avgArea = 0,
        avgEstTR = 0,
        avgEstAcc = 0,
        avgOpener = 0,
        avgPlonk = 0,
        avgStride = 0,
        avgInfDS = 0,
        lowestTR = 25000,
        lowestGlixare = double.infinity,
        lowestGlicko = double.infinity,
        lowestRD = double.infinity,
        lowestWinrate = double.infinity,
        lowestAPM = double.infinity,
        lowestPPS = double.infinity,
        lowestVS = double.infinity,
        lowestAPP = double.infinity,
        lowestVSAPM = double.infinity,
        lowestDSS = double.infinity,
        lowestDSP = double.infinity,
        lowestAPPDSP = double.infinity,
        lowestCheese = double.infinity,
        lowestGBE = double.infinity,
        lowestNyaAPP = double.infinity,
        lowestArea = double.infinity,
        lowestEstTR = double.infinity,
        lowestEstAcc = double.infinity,
        lowestOpener = double.infinity,
        lowestPlonk = double.infinity,
        lowestStride = double.infinity,
        lowestInfDS = double.infinity,
        highestTR = double.negativeInfinity,
        highestGlixare = double.negativeInfinity,
        highestGlicko = double.negativeInfinity,
        highestRD = double.negativeInfinity,
        highestWinrate = double.negativeInfinity,
        highestAPM = double.negativeInfinity,
        highestPPS = double.negativeInfinity,
        highestVS = double.negativeInfinity,
        highestAPP = double.negativeInfinity,
        highestVSAPM = double.negativeInfinity,
        highestDSS = double.negativeInfinity,
        highestDSP = double.negativeInfinity,
        highestAPPDSP = double.negativeInfinity,
        highestCheese = double.negativeInfinity,
        highestGBE = double.negativeInfinity,
        highestNyaAPP = double.negativeInfinity,
        highestArea = double.negativeInfinity,
        highestEstTR = double.negativeInfinity,
        highestEstAcc = double.negativeInfinity,
        highestOpener = double.negativeInfinity,
        highestPlonk = double.negativeInfinity,
        highestStride = double.negativeInfinity,
        highestInfDS = double.negativeInfinity;
      int avgGamesPlayed = 0,
        avgGamesWon = 0,
        totalGamesPlayed = 0,
        totalGamesWon = 0,
        lowestGamesPlayed = pow(2, 53) as int,
        lowestGamesWon = pow(2, 53) as int,
        highestGamesPlayed = 0,
        highestGamesWon = 0;
      String lowestTRid = "", lowestTRnick = "",
        lowestGlixareID = "", lowestGlixareNick = "",
        lowestGlickoID = "", lowestGlickoNick = "",
        lowestRdID = "", lowestRdNick = "",
        lowestGamesPlayedID = "", lowestGamesPlayedNick = "",
        lowestGamesWonID = "", lowestGamesWonNick = "",
        lowestWinrateID = "", lowestWinrateNick = "",
        lowestAPMid = "", lowestAPMnick = "",
        lowestPPSid = "", lowestPPSnick = "",
        lowestVSid = "", lowestVSnick = "",
        lowestAPPid = "", lowestAPPnick = "",
        lowestVSAPMid = "", lowestVSAPMnick = "",
        lowestDSSid = "", lowestDSSnick = "",
        lowestDSPid = "", lowestDSPnick = "",
        lowestAPPDSPid = "", lowestAPPDSPnick = "",
        lowestCheeseID = "", lowestCheeseNick = "",
        lowestGBEid = "", lowestGBEnick = "",
        lowestNyaAPPid = "", lowestNyaAPPnick = "",
        lowestAreaID = "", lowestAreaNick = "",
        lowestEstTRid = "", lowestEstTRnick = "",
        lowestEstAccID = "", lowestEstAccNick = "",
        lowestOpenerID = "", lowestOpenerNick = "",
        lowestPlonkID = "", lowestPlonkNick = "",
        lowestStrideID = "", lowestStrideNick = "",
        lowestInfDSid = "", lowestInfDSnick = "",
        highestTRid = "", highestTRnick = "",
        highestGlixareID = "", highestGlixareNick = "",
        highestGlickoID = "", highestGlickoNick = "",
        highestRdID = "", highestRdNick = "",
        highestGamesPlayedID = "", highestGamesPlayedNick = "",
        highestGamesWonID = "", highestGamesWonNick = "",
        highestWinrateID = "", highestWinrateNick = "",
        highestAPMid = "", highestAPMnick = "",
        highestPPSid = "", highestPPSnick = "",
        highestVSid = "", highestVSnick = "",
        highestAPPid = "", highestAPPnick = "",
        highestVSAPMid = "", highestVSAPMnick = "",
        highestDSSid = "", highestDSSnick = "",
        highestDSPid = "", highestDSPnick = "",
        highestAPPDSPid = "", highestAPPDSPnick = "",
        highestCheeseID = "", highestCheeseNick = "",
        highestGBEid = "", highestGBEnick = "",
        highestNyaAPPid = "", highestNyaAPPnick = "",
        highestAreaID = "", highestAreaNick = "",
        highestEstTRid = "", highestEstTRnick = "",
        highestEstAccID = "", highestEstAccNick = "",
        highestOpenerID = "", highestOpenerNick = "",
        highestPlonkID = "", highestPlonkNick = "",
        highestStrideID = "", highestStrideNick = "",
        highestInfDSid = "", highestInfDSnick = "";
      for (var entry in filtredLeaderboard){
        avgAPM += entry.apm;
        avgPPS += entry.pps;
        avgVS += entry.vs;
        avgTR += entry.tr;
        avgGlixare += entry.gxe;
        if (entry.glicko != null) avgGlicko += entry.glicko!;
        if (entry.rd != null) avgRD += entry.rd!;
        avgAPP += entry.nerdStats.app;
        avgVSAPM += entry.nerdStats.vsapm;
        avgDSS += entry.nerdStats.dss;
        avgDSP += entry.nerdStats.dsp;
        avgAPPDSP += entry.nerdStats.appdsp;
        avgCheese += entry.nerdStats.cheese;
        avgGBE += entry.nerdStats.gbe;
        avgNyaAPP += entry.nerdStats.nyaapp;
        avgArea += entry.nerdStats.area;
        avgEstTR += entry.estTr.esttr;
        avgEstAcc += entry.esttracc;
        avgOpener += entry.playstyle.opener;
        avgPlonk += entry.playstyle.plonk;
        avgStride += entry.playstyle.stride;
        avgInfDS += entry.playstyle.infds;
        totalGamesPlayed += entry.gamesPlayed;
        totalGamesWon += entry.gamesWon;
        if (entry.tr < lowestTR){
          lowestTR = entry.tr;
          lowestTRid = entry.userId;
          lowestTRnick = entry.username;
        }
        if (entry.gxe < lowestGlixare){
          lowestGlixare = entry.gxe;
          lowestGlixareID = entry.userId;
          lowestGlixareNick = entry.username;
        }
        if (entry.glicko != null && entry.glicko! < lowestGlicko){
          lowestGlicko = entry.glicko!;
          lowestGlickoID = entry.userId;
          lowestGlickoNick = entry.username;
        }
        if (entry.rd != null && entry.rd! < lowestRD){
          lowestRD = entry.rd!;
          lowestRdID = entry.userId;
          lowestRdNick = entry.username;
        }
        if (entry.gamesPlayed < lowestGamesPlayed){
          lowestGamesPlayed = entry.gamesPlayed;
          lowestGamesPlayedID = entry.userId;
          lowestGamesPlayedNick = entry.username;
        }
        if (entry.gamesWon < lowestGamesWon){
          lowestGamesWon = entry.gamesWon;
          lowestGamesWonID = entry.userId;
          lowestGamesWonNick = entry.username;
        }
        if (entry.winrate < lowestWinrate){
          lowestWinrate = entry.winrate;
          lowestWinrateID = entry.userId;
          lowestWinrateNick = entry.username;
        }
        if (entry.apm < lowestAPM){
          lowestAPM = entry.apm;
          lowestAPMid = entry.userId;
          lowestAPMnick = entry.username;
        }
        if (entry.pps < lowestPPS){
          lowestPPS = entry.pps;
          lowestPPSid = entry.userId;
          lowestPPSnick = entry.username;
        }
        if (entry.vs < lowestVS){
          lowestVS = entry.vs;
          lowestVSid = entry.userId;
          lowestVSnick = entry.username;
        }
        if (entry.nerdStats.app < lowestAPP){
          lowestAPP = entry.nerdStats.app;
          lowestAPPid = entry.userId;
          lowestAPPnick = entry.username;
        }
        if (entry.nerdStats.vsapm < lowestVSAPM){
          lowestVSAPM = entry.nerdStats.vsapm;
          lowestVSAPMid = entry.userId;
          lowestVSAPMnick = entry.username;
        }
        if (entry.nerdStats.dss < lowestDSS){
          lowestDSS = entry.nerdStats.dss;
          lowestDSSid = entry.userId;
          lowestDSSnick = entry.username;
        }
        if (entry.nerdStats.dsp < lowestDSP){
          lowestDSP = entry.nerdStats.dsp;
          lowestDSPid = entry.userId;
          lowestDSPnick = entry.username;
        }
        if (entry.nerdStats.appdsp < lowestAPPDSP){
          lowestAPPDSP = entry.nerdStats.appdsp;
          lowestAPPDSPid = entry.userId;
          lowestAPPDSPnick = entry.username;
        }
        if (entry.nerdStats.cheese < lowestCheese){
          lowestCheese = entry.nerdStats.cheese;
          lowestCheeseID = entry.userId;
          lowestCheeseNick = entry.username;
        }
        if (entry.nerdStats.gbe < lowestGBE){
          lowestGBE = entry.nerdStats.gbe;
          lowestGBEid = entry.userId;
          lowestGBEnick = entry.username;
        }
        if (entry.nerdStats.nyaapp < lowestNyaAPP){
          lowestNyaAPP = entry.nerdStats.nyaapp;
          lowestNyaAPPid = entry.userId;
          lowestNyaAPPnick = entry.username;
        }
        if (entry.nerdStats.area < lowestArea){
          lowestArea = entry.nerdStats.area;
          lowestAreaID = entry.userId;
          lowestAreaNick = entry.username;
        }
        if (entry.estTr.esttr < lowestEstTR){
          lowestEstTR = entry.estTr.esttr;
          lowestEstTRid = entry.userId;
          lowestEstTRnick = entry.username;
        }
        if (entry.esttracc < lowestEstAcc){
          lowestEstAcc = entry.esttracc;
          lowestEstAccID = entry.userId;
          lowestEstAccNick = entry.username;
        }
        if (entry.playstyle.opener < lowestOpener){
          lowestOpener = entry.playstyle.opener;
          lowestOpenerID = entry.userId;
          lowestOpenerNick = entry.username;
        }
        if (entry.playstyle.plonk < lowestPlonk){
          lowestPlonk = entry.playstyle.plonk;
          lowestPlonkID = entry.userId;
          lowestPlonkNick = entry.username;
        }
        if (entry.playstyle.stride < lowestStride){
          lowestStride = entry.playstyle.stride;
          lowestStrideID = entry.userId;
          lowestStrideNick = entry.username;
        }
        if (entry.playstyle.infds < lowestInfDS){
          lowestInfDS = entry.playstyle.infds;
          lowestInfDSid = entry.userId;
          lowestInfDSnick = entry.username;
        }
        if (entry.tr > highestTR){
          highestTR = entry.tr;
          highestTRid = entry.userId;
          highestTRnick = entry.username;
        }
        if (entry.gxe > highestGlixare){
          highestGlixare = entry.gxe;
          highestGlixareID = entry.userId;
          highestGlixareNick = entry.username;
        }
        if (entry.glicko != null && entry.glicko! > highestGlicko){
          highestGlicko = entry.glicko!;
          highestGlickoID = entry.userId;
          highestGlickoNick = entry.username;
        }
        if (entry.rd != null && entry.rd! > highestRD){
          highestRD = entry.rd!;
          highestRdID = entry.userId;
          highestRdNick = entry.username;
        }
        if (entry.gamesPlayed > highestGamesPlayed){
          highestGamesPlayed = entry.gamesPlayed;
          highestGamesPlayedID = entry.userId;
          highestGamesPlayedNick = entry.username;
        }
        if (entry.gamesWon > highestGamesWon){
          highestGamesWon = entry.gamesWon;
          highestGamesWonID = entry.userId;
          highestGamesWonNick = entry.username;
        }
        if (entry.winrate > highestWinrate){
          highestWinrate = entry.winrate;
          highestWinrateID = entry.userId;
          highestWinrateNick = entry.username;
        }
        if (entry.apm > highestAPM){
          highestAPM = entry.apm;
          highestAPMid = entry.userId;
          highestAPMnick = entry.username;
        }
        if (entry.pps > highestPPS){
          highestPPS = entry.pps;
          highestPPSid = entry.userId;
          highestPPSnick = entry.username;
        }
        if (entry.vs > highestVS){
          highestVS = entry.vs;
          highestVSid = entry.userId;
          highestVSnick = entry.username;
        }
        if (entry.nerdStats.app > highestAPP){
          highestAPP = entry.nerdStats.app;
          highestAPPid = entry.userId;
          highestAPPnick = entry.username;
        }
        if (entry.nerdStats.vsapm > highestVSAPM){
          highestVSAPM = entry.nerdStats.vsapm;
          highestVSAPMid = entry.userId;
          highestVSAPMnick = entry.username;
        }
        if (entry.nerdStats.dss > highestDSS){
          highestDSS = entry.nerdStats.dss;
          highestDSSid = entry.userId;
          highestDSSnick = entry.username;
        }
        if (entry.nerdStats.dsp > highestDSP){
          highestDSP = entry.nerdStats.dsp;
          highestDSPid = entry.userId;
          highestDSPnick = entry.username;
        }
        if (entry.nerdStats.appdsp > highestAPPDSP){
          highestAPPDSP = entry.nerdStats.appdsp;
          highestAPPDSPid = entry.userId;
          highestAPPDSPnick = entry.username;
        }
        if (entry.nerdStats.cheese > highestCheese){
          highestCheese = entry.nerdStats.cheese;
          highestCheeseID = entry.userId;
          highestCheeseNick = entry.username;
        }
        if (entry.nerdStats.gbe > highestGBE){
          highestGBE = entry.nerdStats.gbe;
          highestGBEid = entry.userId;
          highestGBEnick = entry.username;
        }
        if (entry.nerdStats.nyaapp > highestNyaAPP){
          highestNyaAPP = entry.nerdStats.nyaapp;
          highestNyaAPPid = entry.userId;
          highestNyaAPPnick = entry.username;
        }
        if (entry.nerdStats.area > highestArea){
          highestArea = entry.nerdStats.area;
          highestAreaID = entry.userId;
          highestAreaNick = entry.username;
        }
        if (entry.estTr.esttr > highestEstTR){
          highestEstTR = entry.estTr.esttr;
          highestEstTRid = entry.userId;
          highestEstTRnick = entry.username;
        }
        if (entry.esttracc > highestEstAcc){
          highestEstAcc = entry.esttracc;
          highestEstAccID = entry.userId;
          highestEstAccNick = entry.username;
        }
        if (entry.playstyle.opener > highestOpener){
          highestOpener = entry.playstyle.opener;
          highestOpenerID = entry.userId;
          highestOpenerNick = entry.username;
        }
        if (entry.playstyle.plonk > highestPlonk){
          highestPlonk = entry.playstyle.plonk;
          highestPlonkID = entry.userId;
          highestPlonkNick = entry.username;
        }
        if (entry.playstyle.stride > highestStride){
          highestStride = entry.playstyle.stride;
          highestStrideID = entry.userId;
          highestStrideNick = entry.username;
        }
        if (entry.playstyle.infds > highestInfDS){
          highestInfDS = entry.playstyle.infds;
          highestInfDSid = entry.userId;
          highestInfDSnick = entry.username;
        }
      }
      avgAPM /= filtredLeaderboard.length;
      avgPPS /= filtredLeaderboard.length;
      avgVS /= filtredLeaderboard.length;
      avgTR /= filtredLeaderboard.length;
      avgGlixare /= filtredLeaderboard.length;
      avgGlicko /= filtredLeaderboard.length;
      avgRD /= filtredLeaderboard.length;
      avgAPP /= filtredLeaderboard.length;
      avgVSAPM /= filtredLeaderboard.length;
      avgDSS /= filtredLeaderboard.length;
      avgDSP /= filtredLeaderboard.length;
      avgAPPDSP /= leaderboard.length;
      avgCheese /= filtredLeaderboard.length;
      avgGBE /= filtredLeaderboard.length;
      avgNyaAPP /= filtredLeaderboard.length;
      avgArea /= filtredLeaderboard.length;
      avgEstTR /= filtredLeaderboard.length;
      avgEstAcc /= filtredLeaderboard.length;
      avgOpener /= filtredLeaderboard.length;
      avgPlonk /= filtredLeaderboard.length;
      avgStride /= filtredLeaderboard.length;
      avgInfDS /= filtredLeaderboard.length;
      avgGamesPlayed = (totalGamesPlayed / filtredLeaderboard.length).floor();
      avgGamesWon = (totalGamesWon / filtredLeaderboard.length).floor();
      return [TetraLeague(id: "", timestamp: DateTime.now(), apm: avgAPM, pps: avgPPS, vs: avgVS, gxe: avgGlixare, glicko: avgGlicko, rd: avgRD, gamesPlayed: avgGamesPlayed, gamesWon: avgGamesWon, bestRank: rank, decaying: false, tr: avgTR, rank: rank == "" ? "z" : rank, percentileRank: rank, percentile: rankCutoffs[rank]!, standing: -1, standingLocal: -1, nextAt: -1, prevAt: -1, season: currentSeason),
      {
        "everyone": rank == "",
        "totalGamesPlayed": totalGamesPlayed,
        "totalGamesWon": totalGamesWon,
        "players": filtredLeaderboard.length,
        "lowestTR": lowestTR,
        "lowestTRid": lowestTRid,
        "lowestTRnick": lowestTRnick,
        "lowestGlixare": lowestGlixare,
        "lowestGlixareID": lowestGlixareID,
        "lowestGlixareNick": lowestGlixareNick,
        "lowestS1tr": lowestGlixare * 250,
        "lowestS1trID": lowestGlixareID,
        "lowestS1trNick": lowestGlixareNick,
        "lowestGlicko": lowestGlicko,
        "lowestGlickoID": lowestGlickoID,
        "lowestGlickoNick": lowestGlickoNick,
        "lowestRD": lowestRD,
        "lowestRdID": lowestRdID,
        "lowestRdNick": lowestRdNick,
        "lowestGamesPlayed": lowestGamesPlayed,
        "lowestGamesPlayedID": lowestGamesPlayedID,
        "lowestGamesPlayedNick": lowestGamesPlayedNick,
        "lowestGamesWon": lowestGamesWon,
        "lowestGamesWonID": lowestGamesWonID,
        "lowestGamesWonNick": lowestGamesWonNick,
        "lowestWinrate": lowestWinrate,
        "lowestWinrateID": lowestWinrateID,
        "lowestWinrateNick": lowestWinrateNick,
        "lowestAPM": lowestAPM,
        "lowestAPMid": lowestAPMid,
        "lowestAPMnick": lowestAPMnick,
        "lowestPPS": lowestPPS,
        "lowestPPSid": lowestPPSid,
        "lowestPPSnick": lowestPPSnick,
        "lowestVS": lowestVS,
        "lowestVSid": lowestVSid,
        "lowestVSnick": lowestVSnick,
        "lowestAPP": lowestAPP,
        "lowestAPPid": lowestAPPid,
        "lowestAPPnick": lowestAPPnick,
        "lowestVSAPM": lowestVSAPM,
        "lowestVSAPMid": lowestVSAPMid,
        "lowestVSAPMnick": lowestVSAPMnick,
        "lowestDSS": lowestDSS,
        "lowestDSSid": lowestDSSid,
        "lowestDSSnick": lowestDSSnick,
        "lowestDSP": lowestDSP,
        "lowestDSPid": lowestDSPid,
        "lowestDSPnick": lowestDSPnick,
        "lowestAPPDSP": lowestAPPDSP,
        "lowestAPPDSPid": lowestAPPDSPid,
        "lowestAPPDSPnick": lowestAPPDSPnick,
        "lowestCheese": lowestCheese,
        "lowestCheeseID": lowestCheeseID,
        "lowestCheeseNick": lowestCheeseNick,
        "lowestGBE": lowestGBE,
        "lowestGBEid": lowestGBEid,
        "lowestGBEnick": lowestGBEnick,
        "lowestNyaAPP": lowestNyaAPP,
        "lowestNyaAPPid": lowestNyaAPPid,
        "lowestNyaAPPnick": lowestNyaAPPnick,
        "lowestArea": lowestArea,
        "lowestAreaID": lowestAreaID,
        "lowestAreaNick": lowestAreaNick,
        "lowestEstTR": lowestEstTR,
        "lowestEstTRid": lowestEstTRid,
        "lowestEstTRnick": lowestEstTRnick,
        "lowestEstAcc": lowestEstAcc,
        "lowestEstAccID": lowestEstAccID,
        "lowestEstAccNick": lowestEstAccNick,
        "lowestOpener": lowestOpener,
        "lowestOpenerID": lowestOpenerID,
        "lowestOpenerNick": lowestOpenerNick,
        "lowestPlonk": lowestPlonk,
        "lowestPlonkID": lowestPlonkID,
        "lowestPlonkNick": lowestPlonkNick,
        "lowestStride": lowestStride,
        "lowestStrideID": lowestStrideID,
        "lowestStrideNick": lowestStrideNick,
        "lowestInfDS": lowestInfDS,
        "lowestInfDSid": lowestInfDSid,
        "lowestInfDSnick": lowestInfDSnick,
        "highestTR": highestTR,
        "highestTRid": highestTRid,
        "highestTRnick": highestTRnick,
        "highestGlixare": highestGlixare,
        "highestGlixareID": highestGlixareID,
        "highestGlixareNick": highestGlixareNick,
        "highestS1tr": highestGlixare * 250,
        "highestS1trID": highestGlixareID,
        "highestS1trNick": highestGlixareNick,
        "highestGlicko": highestGlicko,
        "highestGlickoID": highestGlickoID,
        "highestGlickoNick": highestGlickoNick,
        "highestRD": highestRD,
        "highestRdID": highestRdID,
        "highestRdNick": highestRdNick,
        "highestGamesPlayed": highestGamesPlayed,
        "highestGamesPlayedID": highestGamesPlayedID,
        "highestGamesPlayedNick": highestGamesPlayedNick,
        "highestGamesWon": highestGamesWon,
        "highestGamesWonID": highestGamesWonID,
        "highestGamesWonNick": highestGamesWonNick,
        "highestWinrate": highestWinrate,
        "highestWinrateID": highestWinrateID,
        "highestWinrateNick": highestWinrateNick,
        "highestAPM": highestAPM,
        "highestAPMid": highestAPMid,
        "highestAPMnick": highestAPMnick,
        "highestPPS": highestPPS,
        "highestPPSid": highestPPSid,
        "highestPPSnick": highestPPSnick,
        "highestVS": highestVS,
        "highestVSid": highestVSid,
        "highestVSnick": highestVSnick,
        "highestAPP": highestAPP,
        "highestAPPid": highestAPPid,
        "highestAPPnick": highestAPPnick,
        "highestVSAPM": highestVSAPM,
        "highestVSAPMid": highestVSAPMid,
        "highestVSAPMnick": highestVSAPMnick,
        "highestDSS": highestDSS,
        "highestDSSid": highestDSSid,
        "highestDSSnick": highestDSSnick,
        "highestDSP": highestDSP,
        "highestDSPid": highestDSPid,
        "highestDSPnick": highestDSPnick,
        "highestAPPDSP": highestAPPDSP,
        "highestAPPDSPid": highestAPPDSPid,
        "highestAPPDSPnick": highestAPPDSPnick,
        "highestCheese": highestCheese,
        "highestCheeseID": highestCheeseID,
        "highestCheeseNick": highestCheeseNick,
        "highestGBE": highestGBE,
        "highestGBEid": highestGBEid,
        "highestGBEnick": highestGBEnick,
        "highestNyaAPP": highestNyaAPP,
        "highestNyaAPPid": highestNyaAPPid,
        "highestNyaAPPnick": highestNyaAPPnick,
        "highestArea": highestArea,
        "highestAreaID": highestAreaID,
        "highestAreaNick": highestAreaNick,
        "highestEstTR": highestEstTR,
        "highestEstTRid": highestEstTRid,
        "highestEstTRnick": highestEstTRnick,
        "highestEstAcc": highestEstAcc,
        "highestEstAccID": highestEstAccID,
        "highestEstAccNick": highestEstAccNick,
        "highestOpener": highestOpener,
        "highestOpenerID": highestOpenerID,
        "highestOpenerNick": highestOpenerNick,
        "highestPlonk": highestPlonk,
        "highestPlonkID": highestPlonkID,
        "highestPlonkNick": highestPlonkNick,
        "highestStride": highestStride,
        "highestStrideID": highestStrideID,
        "highestStrideNick": highestStrideNick,
        "highestInfDS": highestInfDS,
        "highestInfDSid": highestInfDSid,
        "highestInfDSnick": highestInfDSnick,
        "avgAPP": avgAPP,
        "avgVSAPM": avgVSAPM,
        "avgDSS": avgDSS,
        "avgDSP": avgDSP,
        "avgAPPDSP": avgAPPDSP,
        "avgCheese": avgCheese,
        "avgGBE": avgGBE,
        "avgNyaAPP": avgNyaAPP,
        "avgArea": avgArea,
        "avgEstTR": avgEstTR,
        "avgEstAcc": avgEstAcc,
        "avgOpener": avgOpener,
        "avgPlonk": avgPlonk,
        "avgStride": avgStride,
        "avgInfDS": avgInfDS,
        "toEnterTR": rank.toLowerCase() != "z" ? leaderboard[(leaderboard.length * rankCutoffs[rank]!).floor()-1].tr : lowestTR,
        "toEnterGlicko": rank.toLowerCase() != "z" ? leaderboard[(leaderboard.length * rankCutoffs[rank]!).floor()-1].glicko : 0,
        "entries": filtredLeaderboard
      }];
    }else{
      return [TetraLeague(id: "", timestamp: DateTime.now(), apm: 0, pps: 0, vs: 0, glicko: 0, rd: noTrRd, gamesPlayed: 0, gamesWon: 0, bestRank: rank, decaying: false, tr: 0, rank: rank, percentileRank: rank, gxe: -1, percentile: rankCutoffs[rank]!, standing: -1, standingLocal: -1, nextAt: -1, prevAt: -1, season: currentSeason),
      {"players": filtredLeaderboard.length, "lowestTR": 0, "toEnterTR": 0, "toEnterGlicko": 0}];
    }
  }

  PlayerLeaderboardPosition? getLeaderboardPosition(Map<String, TetraLeague>league) {
    if (league.values.first.gamesPlayed == 0) return null;
    bool fakePositions = false;
    late List<TetrioPlayerFromLeaderboard> copyOfLeaderboard;
    if (leaderboard.indexWhere((element) => element.userId == league.keys.first) == -1){
      fakePositions =true;
      copyOfLeaderboard = List.of(leaderboard);
      copyOfLeaderboard.add(league.values.first.convertToPlayerFromLeaderboard(league.keys.first));
    } 
    List<Stats> stats = [Stats.apm, Stats.pps, Stats.vs, Stats.gp, Stats.gw, Stats.wr,
    Stats.app, Stats.vsapm, Stats.dss, Stats.dsp, Stats.appdsp, Stats.cheese, Stats.gbe, Stats.nyaapp, Stats.area, Stats.eTR, Stats.acceTR];
    List<LeaderboardPosition?> results = [];
    for (Stats stat in stats) {
      List<TetrioPlayerFromLeaderboard> sortedLeaderboard = getStatRanking(fakePositions ? copyOfLeaderboard : leaderboard, stat, reversed: stat == Stats.cheese ? true : false);
      int position = sortedLeaderboard.indexWhere((element) => element.userId == league.keys.first) + 1;
      if (position == 0) {
        results.add(null);
      } else {
        results.add(LeaderboardPosition(fakePositions ? 1001 : position, position / sortedLeaderboard.length));
      }
    }
    return PlayerLeaderboardPosition.fromSearchResults(results);
  }

  Map<String, List<dynamic>> get averages => {
    'x+': getAverageOfRank("x+"),
    'x': getAverageOfRank("x"),
    'u': getAverageOfRank("u"),
    'ss': getAverageOfRank("ss"),
    's+': getAverageOfRank("s+"),
    's': getAverageOfRank("s"),
    's-': getAverageOfRank("s-"),
    'a+': getAverageOfRank("a+"),
    'a': getAverageOfRank("a"),
    'a-': getAverageOfRank("a-"),
    'b+': getAverageOfRank("b+"),
    'b': getAverageOfRank("b"),
    'b-': getAverageOfRank("b-"),
    'c+': getAverageOfRank("c+"),
    'c': getAverageOfRank("c"),
    'c-': getAverageOfRank("c-"),
    'd+': getAverageOfRank("d+"),
    'd': getAverageOfRank("d"),
    'z': getAverageOfRank("z")
    };

  Map<String, double> get cutoffs => {
    'x': getAverageOfRank("x")[1]["toEnterTR"],
    'u': getAverageOfRank("u")[1]["toEnterTR"],
    'ss': getAverageOfRank("ss")[1]["toEnterTR"],
    's+': getAverageOfRank("s+")[1]["toEnterTR"],
    's': getAverageOfRank("s")[1]["toEnterTR"],
    's-': getAverageOfRank("s-")[1]["toEnterTR"],
    'a+': getAverageOfRank("a+")[1]["toEnterTR"],
    'a': getAverageOfRank("a")[1]["toEnterTR"],
    'a-': getAverageOfRank("a-")[1]["toEnterTR"],
    'b+': getAverageOfRank("b+")[1]["toEnterTR"],
    'b': getAverageOfRank("b")[1]["toEnterTR"],
    'b-': getAverageOfRank("b-")[1]["toEnterTR"],
    'c+': getAverageOfRank("c+")[1]["toEnterTR"],
    'c': getAverageOfRank("c")[1]["toEnterTR"],
    'c-': getAverageOfRank("c-")[1]["toEnterTR"],
    'd+': getAverageOfRank("d+")[1]["toEnterTR"],
    'd': getAverageOfRank("d")[1]["toEnterTR"]
    };

  Map<String, double> get cutoffsGlicko => {
    'x': getAverageOfRank("x")[1]["toEnterGlicko"],
    'u': getAverageOfRank("u")[1]["toEnterGlicko"],
    'ss': getAverageOfRank("ss")[1]["toEnterGlicko"],
    's+': getAverageOfRank("s+")[1]["toEnterGlicko"],
    's': getAverageOfRank("s")[1]["toEnterGlicko"],
    's-': getAverageOfRank("s-")[1]["toEnterGlicko"],
    'a+': getAverageOfRank("a+")[1]["toEnterGlicko"],
    'a': getAverageOfRank("a")[1]["toEnterGlicko"],
    'a-': getAverageOfRank("a-")[1]["toEnterGlicko"],
    'b+': getAverageOfRank("b+")[1]["toEnterGlicko"],
    'b': getAverageOfRank("b")[1]["toEnterGlicko"],
    'b-': getAverageOfRank("b-")[1]["toEnterGlicko"],
    'c+': getAverageOfRank("c+")[1]["toEnterGlicko"],
    'c': getAverageOfRank("c")[1]["toEnterGlicko"],
    'c-': getAverageOfRank("c-")[1]["toEnterGlicko"],
    'd+': getAverageOfRank("d+")[1]["toEnterGlicko"],
    'd': getAverageOfRank("d")[1]["toEnterGlicko"]
    };

  TetrioPlayersLeaderboard.fromJson(List<dynamic> json, String t, DateTime ts) {
    type = t;
    timestamp = ts;
    leaderboard = [];
    for (Map<String, dynamic> entry in json) {
      leaderboard.add(TetrioPlayerFromLeaderboard.fromJson(entry, ts));
    }
  }

  addPlayers(List<TetrioPlayerFromLeaderboard> list){
    leaderboard.addAll(list);
  }
}
