import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_expression_function_bodies

class AutomatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automat'),
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
                  Flexible(flex: 1, child: _buildAusgabe(context)),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  _buildAdminButton(context),
                  _buildLED(context),
                  _buildLed(context),
                  _buildCoin(context, Colors.grey[200], 200, '2'),
                  _buildCoin(context, Colors.grey[200], 100, '1'),
                  _buildCoin(context, Colors.orange[200], 50, '50'),
                  _buildCoin(context, Colors.orange[200], 20, '20'),
                  _buildCoin(context, Colors.orange[200], 10, '10'),
                  _buildCoin(context, Colors.deepOrangeAccent[300], 5, '5'),
                  _buildCoin(context, Colors.deepOrangeAccent[300], 2, '2'),
                  _buildCoin(context, Colors.deepOrangeAccent[300], 1, '1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAusgabe(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }

  Widget _buildProducts(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
