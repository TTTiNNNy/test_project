import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_pr/login_page_fashion.dart';
import 'package:test_pr/network_api.dart';

import 'global_fashion.dart';
import 'language_api.dart';
import 'login_page.dart';
import 'main_page_fashion.dart';

List<ServerRequestCards> selectCardsByOwnLanguage(
    List<ServerRequestCards> cards, LanguageSupport language) {
  List<ServerRequestCards> cleanList = [];

  for (var card in cards) {
    if (LanguageStuff.languageDetect(card.text) == language) {
      cleanList.add(card);
    }
  }
  return cleanList;
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  List<List<ServerRequestCards>> sortedCardsByColumn = [[], [], [], []];

  @override
  Widget build(BuildContext context) {
    for (var el in ServerRequest.cards) {
      var card = ServerRequestCards(
          el["id"], int.parse(el["row"]), el["seq_num"], el["text"]);
      sortedCardsByColumn[card.row].add(card);
    }

    for (int i = 0; i < sortedCardsByColumn.length; i++) {
      sortedCardsByColumn[i] = selectCardsByOwnLanguage(
          sortedCardsByColumn[i], LanguageStuff.getOwnLanguage());
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            RawMaterialButton(
              fillColor: GlobalFashion.activeColor,
              shape: const CircleBorder(),
              child: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: GlobalFashion.activeColor,
            tabs: [
              Tab(
                  child: Text("On hold",
                      style: TextStyle(color: MainPageFashion.textColor)
                  )
              ),
              Tab(
                  child: Text("In progress",
                      style: TextStyle(color: MainPageFashion.textColor)
                  )
              ),
              Tab(
                  child: Text("Needs review",
                      style: TextStyle(color: MainPageFashion.textColor)
                  )
              ),
              Tab(
                  child: Text("Approved",
                      style: TextStyle(color: MainPageFashion.textColor)
                  )
              ),
            ],
          ),
          title: const Text(""),
        ),
        body: TabBarView(
          children: [
            CardsListScreen(sortedCardsByColumn[0]),
            CardsListScreen(sortedCardsByColumn[1]),
            CardsListScreen(sortedCardsByColumn[2]),
            CardsListScreen(sortedCardsByColumn[3]),
          ],
        ),
      ),
    );
  }
}

class CardsListScreen extends StatelessWidget {
  late List<ServerRequestCards> sortedItems;

  CardsListScreen(List<ServerRequestCards> items, {Key? key})
      : super(key: key) {
    sortedItems = items;
    sortedItems.sort((a, b) {
      return a.id < b.id ? -1 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Future<String>.delayed(
        const Duration(seconds: 1),
        () => 'ok',
      ), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return snapshot.hasData
            ? ColoredBox(
                color: GlobalFashion.bodyColor,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: sortedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          decoration: MainPageFashion.tileDecoration(),
                          margin: const EdgeInsets.symmetric(
                              vertical: GlobalFashion.betweenCardsMargin,
                              horizontal: GlobalFashion.horizontalMargin),
                          child: ListTile(
                              title: Text(
                                "ID: ${sortedItems[index].id}",
                                style: const TextStyle(
                                    color: MainPageFashion.textColor,
                                    fontSize: 12),
                              ),
                              subtitle: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical:
                                          GlobalFashion.betweenCardsMargin),
                                  child: Text(sortedItems[index].text,
                                      style: const TextStyle(
                                          color: MainPageFashion.textColor,
                                          fontSize: 18)
                                  )
                              )
                          )
                      );
                    },
                  ),
                )
        )
            : const ColoredBox(
                color: GlobalFashion.bodyColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: GlobalFashion.activeColor,
                  ),
                )
        );
      },
    );
  }
}
