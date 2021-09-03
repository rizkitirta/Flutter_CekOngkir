import 'dart:convert';

import 'package:cek_ongkir/app/modules/home/province_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownSearch<Province>(
              label: "Province",
              showSearchBox: true,
              itemAsString: (item) => item.province!,
              searchBoxDecoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)), hintText: "cari provinsi"),
              onFind: (String filter) async {
                Uri url =
                    Uri.parse("https://api.rajaongkir.com/starter/province");

                try {
                  final response = await http.get(url,
                      headers: {"key": "0ae702200724a396a933fa0ca4171a7e"});

                  var data = jsonDecode(response.body) as Map<String, dynamic>;

                  if (data['rajaongkir']['status']['code'] != 200) {
                    throw data['rajaongkir']['status']['description'];
                  }

                  var list_province =
                      data['rajaongkir']['results'] as List<dynamic>;

                  var models = Province.fromJsonList(list_province);
                  return models;
                } catch (e) {
                  return List<Province>.empty();
                }
              },
              onChanged: (value) {
                print(value);
              },
              popupItemBuilder: (context, item, isSelected) {
                return Container(
                  child: Text(
                    "${item.province}",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                );
              },
            )
          ],
        ));
  }
}
