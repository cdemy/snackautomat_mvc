import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat/controller/_register_controller.dart';

// ignore_for_file: prefer_expression_function_bodies
/// Main screen of the app
class AutomatScreen extends StatelessWidget {
  final IRegisterController _con = IRegisterController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automat'),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 3,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(flex: 3, child: _buildProducts(context)),
                  Expanded(child: _buildAusgabe(context)),
                ],
              ),
            ),
            Flexible(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  _buildAdminButton(context),
                  _buildLED(context, 'Preis', _con.displayPrice),
                  _buildLED(context, 'Einwurf', _con.displayDebit),
                  _buildCoin(context, Colors.grey[200], 200, '2'),
                  _buildCoin(context, Colors.grey[200], 100, '1'),
                  _buildCoin(context, Colors.orange[200], 50, '50'),
                  _buildCoin(context, Colors.orange[200], 20, '20'),
                  _buildCoin(context, Colors.orange[200], 10, '10'),
                  _buildCoin(context, Colors.deepOrange[300]!, 5, '5'),
                  _buildCoin(context, Colors.deepOrange[300]!, 2, '2'),
                  _buildCoin(context, Colors.deepOrange[300]!, 1, '1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context) {
    return Flexible(
      child: Container(
          child: Center(
        child: Switch(
          value: _con.isAdminMode,
          onChanged: (value) {
            _con.adminMode(value);
          },
        ),
      )),
    );
  }

  Widget _buildAusgabe(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.9;
        final height = constraints.maxHeight * 0.9;
        return InkWell(
          onTap: () {
            _con.statusReport();
          },
          child: Ink(
            width: width,
            height: height,
            color: Colors.red,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                _con.selectedSlot > 0 ? _con.selectedSlot.toString() : '',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoin(BuildContext context, Color? color, int value, String denom) {
    return Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var max = constraints.maxHeight;
          if (constraints.maxWidth < max) max = constraints.maxWidth;
          return InkWell(
            child: Container(
              width: max,
              height: max,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(max)),
              ),
              child: Center(
                child: Text(denom),
              ),
            ),
            onTap: () {
              _con.insertCoin(value);
            },
          );
        },
      ),
    );
  }

  Widget _buildLED(BuildContext context, String title, int value) {
    return Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * 0.8;
          final height = constraints.maxHeight * 0.5;
          return Center(
            child: Flex(
              direction: Axis.vertical,
              children: [
                FittedBox(
                  child: Text(title),
                ),
                Container(
                  height: height,
                  width: width,
                  color: Colors.green[300],
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProduct(int slot, int price) {
    return Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight * 0.9;
          final width = constraints.maxWidth * 0.9;
          log('errechnet: $width * $height');
          return Center(
            child: InkWell(
              splashColor: Colors.yellow,
              onTap: () {
                _con.selectProduct(slot, price);
              },
              child: Ink(
                height: height,
                width: width,
                color: _con.selectedSlot == slot ? Colors.yellow : Colors.grey[300],
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: Text(slot.toString()),
                      ),
                    ),
                    Text(price.toString()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProducts(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              _buildProduct(1, 70),
              _buildProduct(2, 90),
              _buildProduct(3, 110),
            ],
          ),
        ),
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              _buildProduct(4, 50),
              _buildProduct(5, 30),
              _buildProduct(6, 150),
            ],
          ),
        ),
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              _buildProduct(7, 200),
              _buildProduct(8, 160),
              _buildProduct(9, 90),
            ],
          ),
        ),
      ],
    );
  }
}
