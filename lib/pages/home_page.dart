import 'dart:convert';
import 'dart:io';

import 'package:coincap/pages/details_page.dart';
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
  String? _selectedCoin = 'Bitcoin';
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
      body: Container(
        width: _deviceWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(123, 67, 151, 1),
              Color.fromRGBO(70, 40, 150, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _header(),
              _selectedCoinDropdown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Text(
      "Crypto Dashboard",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> coins = ['Bitcoin', 'Ethereum', 'Tether', 'Ripple', 'Solana'];
    List<DropdownMenuItem<String>> items = coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: Colors.white,
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.black,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
        future: _http!.get('/coins/${_selectedCoin!.toLowerCase()}'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map _data = jsonDecode(snapshot.data.toString());
            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _change24 = _data["market_data"]["price_change_percentage_24h"];
            String _image_url = _data["image"]["large"];
            String _desc = _data["description"]["en"];
            Map _exchangeRates = _data["market_data"]["current_price"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext _context) {
                          return DetailsPage(
                            rates: _exchangeRates,
                          );
                        }),
                      );
                    },
                    child: _coinImageWidget(_image_url)),
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
      '\$${_rate.toStringAsFixed(2)}',
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      '${_change.toStringAsFixed(2)}%',
      style: TextStyle(
        fontFamily: 'Poppins',
        color: _change >= 0 ? Colors.green : Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        // color: Color.fromRGBO(83, 88, 206, .5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _description,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
