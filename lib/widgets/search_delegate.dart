import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models.dart';

class CustomeSearchDelegate extends SearchDelegate {
  CustomeSearchDelegate(this.changeLocation);
  final Function changeLocation;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Countries countries = Countries();
    Future<Countries?> makeGetRequest() async {
      var client = http.Client();
      var uri = Uri.parse(
          "https://geocoding-api.open-meteo.com/v1/search?name=$query");
      try {
        var response = await client.get(uri);
        if (response.statusCode == 200) {
          var json = response.body;
          countries = countriesFromJson(json);
          return countries;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }

    return FutureBuilder(
        future: makeGetRequest(),
        builder: (context, AsyncSnapshot<Countries?> snapshot) {
          var data = snapshot.data?.results ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return data.isEmpty
                ? const Center(
                    child: Text("no results", style: TextStyle(fontSize: 24)))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        close(context, null);
                        changeLocation(data[index]);
                      },
                      child: ListTile(
                        title: Text(data[index].name ?? ""),
                        subtitle: Text(data[index].country ?? ""),
                      ),
                    ),
                  );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/no-connection.jpg",
                    width: size.width * .5,
                  ),
                  const Text("Check your connection"),
                  SizedBox(height: size.height * .05),
                  MaterialButton(
                    onPressed: () {
                      query = query;
                    },
                    color: Colors.blueAccent,
                    child: const Text("Reload"),
                  )
                ],
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Countries countries = Countries();
    Future<Countries?> makeGetRequest() async {
      var client = http.Client();
      var uri = Uri.parse(
          "https://geocoding-api.open-meteo.com/v1/search?name=$query");

      try {
        var response = await client.get(uri);
        if (response.statusCode == 200) {
          var json = response.body;
          countries = countriesFromJson(json);
          return countries;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }

    return FutureBuilder(
        future: makeGetRequest(),
        builder: (context, AsyncSnapshot<Countries?> snapshot) {
          var data = snapshot.data?.results ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return data.isEmpty
                ? const Center(
                    child: Text("no results", style: TextStyle(fontSize: 24)))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        close(context, null);
                        changeLocation(data[index]);
                      },
                      child: ListTile(
                        title: Text(data[index].name ?? ""),
                        subtitle: Text(data[index].country ?? ""),
                      ),
                    ),
                  );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/no-connection.png",
                    width: size.width * .5,
                  ),
                  const Text("Check your connection"),
                  SizedBox(height: size.height * .05),
                  MaterialButton(
                    onPressed: () {
                      query = query;
                    },
                    color: Colors.blueAccent,
                    child: const Text("Reload"),
                  )
                ],
              ),
            );
          }
        });
  }
}
