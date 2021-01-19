import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHub {
  /// baseurl of the GitHub REST API for this repository
  String baseUrl = 'https://api.github.com/repos/flowhorn/schulplaner';

  /// Returns a list of contributors at GitHub || null
  Future<List<Contributor>> getContributors() async {
    String url = baseUrl + '/contributors';

    try {
      final response = await http.get(url);

      final responseData = json.decode(response.body);

      /// List to store the contributors in.
      final List<Contributor> contributors = [];
      for (final singleContr in responseData) {
        final Contributor contributor = Contributor(
          name: singleContr['login'],
          url: singleContr['html_url'],
          contributions: singleContr['contributions'],
        );
        contributors.add(contributor);
      }
      return contributors;
    } catch (err) {
      print('Error while loading contributors: $err');
      return null;
    }
  }
}

class Contributor {
  final String name, url;
  final int contributions;

  const Contributor({
    this.name,
    this.url,
    this.contributions,
  });
}
