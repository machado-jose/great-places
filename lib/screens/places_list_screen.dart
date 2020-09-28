import 'package:flutter/material.dart';
import 'package:great_places/provider/great_place.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Lugares'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlace>(context, listen: false).loadItems(),
        builder: (ctx, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlace>(
                child: Center(child: Text("Nenhum item cadastrado!")),
                builder: (ctx, greatPlace, ch) {
                  return (greatPlace.itemsCount == 0)
                      ? ch
                      : ListView.builder(
                          itemCount: greatPlace.itemsCount,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlace.itemByIndex(i).image)),
                            title: Text(greatPlace.itemByIndex(i).title),
                            subtitle: Text(
                                greatPlace.itemByIndex(i).location.address),
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.PLACE_DETAIL,
                              arguments: greatPlace.itemByIndex(i),
                            ),
                          ),
                        );
                },
              ),
      ),
    );
  }
}
