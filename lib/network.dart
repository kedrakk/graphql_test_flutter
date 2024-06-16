import 'package:countries_graphql/const.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(backendURL);
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

const String nameQuery = "name";
const String capitalQuery = "capital";
const String currencyQuery = "currency";
const String continentQuery = """
continent{
  name
}
""";
const String emojiQuery = "emoji";

String getQueryName({
  required bool isNameIn,
  required bool isCapitalIn,
  required bool isCurrencyIn,
  required bool isContinentIn,
  required bool isEmojiIn,
}) {
  return """
{
  countries{
    ${isNameIn ? "$nameQuery," : ""}
    ${isCapitalIn ? "$capitalQuery," : ""}
    ${isCurrencyIn ? "$currencyQuery," : ""}
    ${isContinentIn ? "$continentQuery," : ""}
    ${isEmojiIn ? "$emojiQuery," : ""}
  }
}
""";
}
