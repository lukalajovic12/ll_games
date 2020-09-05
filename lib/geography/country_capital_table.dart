import 'package:flutter/material.dart';
import 'geo.dart';
class CountryCapitalList extends StatelessWidget{


  List<CountryCapital> geoList=new List();


  CountryCapitalList(List<CountryCapital> geoList){
    this.geoList=geoList;
  }

  List<CountryCapital> getGeoList(){
    if(geoList==null){
      geoList=new List();
    }
    return geoList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('countries and capitals'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('country'),
                  ),
                  DataColumn(
                    label: Text('capital'),
                  ),
                  DataColumn(
                    label: Text('continent'),
                  ),



                ],
                rows: getGeoList()
                    .map(
                      (cc) => DataRow(
                    cells: [
                      DataCell(
                        Text(cc.country),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(cc.capital),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                    ],
                  ),
                ).toList(),
              ),

            )
        )
    );
  }
}