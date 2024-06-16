import 'package:countries_graphql/network.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(
            getQueryName(
              isNameIn: true,
              isCapitalIn: true,
              isCurrencyIn: true,
              isContinentIn: true,
              isEmojiIn: true,
            ),
          ),
          variables: const <String, dynamic>{"variableName": "value"},
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const LoadingWidget();
          } else if (result.data == null) {
            return const NoDataWidget();
          } else {
            final countries = result.data!["countries"];
            return ListView.builder(
              itemBuilder: (context, index) {
                final country = countries[index];
                return CountryCardWidget(
                  name: country["name"] ?? "",
                  capital: country["capital"] ?? "",
                  currency: country["currency"] ?? "",
                  continent: country["continent"]["name"] ?? "",
                  emoji: country["emoji"] ?? "",
                );
              },
              itemCount: countries.length,
            );
          }
        },
      ),
    );
  }
}

class CountryCardWidget extends StatelessWidget {
  const CountryCardWidget({
    super.key,
    this.emoji = "",
    this.name = "",
    this.capital = "",
    this.continent = "",
    this.currency = "",
  });
  final String emoji;
  final String name;
  final String capital;
  final String continent;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(emoji),
        title: Text(name),
        subtitle: Text(capital),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(continent),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.attach_money_outlined,
                  size: 20,
                ),
                Text(currency),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No countries information available"),
    );
  }
}
