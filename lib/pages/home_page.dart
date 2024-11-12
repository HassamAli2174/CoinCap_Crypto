import 'dart:convert';
import 'dart:io';

import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _selectedCoinDropdown(),
            _DataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> coins = ['Bitcoin'];
    List<DropdownMenuItem<String>> items = coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: coins.first,
      items: items,
      onChanged: (value) {},
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _DataWidgets() {
    return FutureBuilder(
        future: _http!.get('/coins/bitcoin'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map _data = jsonDecode(snapshot.data.toString());
            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _change24 = _data["market_data"]["price_change_percentage_24h"];
            String _image_url = _data["image"]["large"];
            String _desc = _data["description"]["en"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _coinImageWidget(_image_url),
                _currentPriceWidget(_usdPrice),
                _percentageChangeWidget(_change24),
                _descriptionCardWidget(_desc),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      '${_rate.toStringAsFixed(2)}USD',
      style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      '${_change.toString()}%',
      style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w300),
    );
  }

  Widget _coinImageWidget(String _imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * .02,
      ),
      width: _deviceWidth! * .15,
      height: _deviceHeight! * .15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            _imageUrl,
          ),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * .45,
      width: _deviceWidth! * .90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * .05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * .01,
        horizontal: _deviceHeight! * .01,
      ),
      color: Color.fromRGBO(83, 88, 206, .5),
      child: Text(
        _description,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
