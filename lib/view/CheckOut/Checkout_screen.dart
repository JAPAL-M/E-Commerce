import 'dart:developer';
import 'dart:math';

import 'package:ecommerce_app/core/viewmodel/cart_view_model.dart';
import 'package:ecommerce_app/view/shared/components/components.dart';
import 'package:ecommerce_app/view/shared/components/constant.dart';
import 'package:ecommerce_app/view/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:timelines/timelines.dart';

import '../../model/CartModel.dart';

const kTileHeight = 50.0;

const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _processIndex = 0;
  Dlivery dlivery = Dlivery.StandardDelivery;

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            )),
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            child: Timeline.tileBuilder(
              theme: TimelineThemeData(
                direction: Axis.horizontal,
                connectorTheme: ConnectorThemeData(
                  space: 30.0,
                  thickness: 5.0,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.before,
                itemExtentBuilder: (_, __) =>
                    MediaQuery.of(context).size.width / _processes.length,
                oppositeContentsBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                  );
                },
                contentsBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      _processes[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColor(index),
                      ),
                    ),
                  );
                },
                indicatorBuilder: (_, index) {
                  var color;
                  var child;
                  if (index == _processIndex) {
                    color = inProgressColor;
                    child = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  } else if (index < _processIndex) {
                    color = completeColor;
                    child = Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15.0,
                    );
                  } else {
                    color = todoColor;
                  }

                  if (index <= _processIndex) {
                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(30.0, 30.0),
                          painter: _BezierPainter(
                            color: color,
                            drawStart: index > 0,
                            drawEnd: index < _processIndex,
                          ),
                        ),
                        DotIndicator(
                          size: 30.0,
                          color: color,
                          child: child,
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(15.0, 15.0),
                          painter: _BezierPainter(
                            color: color,
                            drawEnd: index < _processes.length - 1,
                          ),
                        ),
                        OutlinedDotIndicator(
                          borderWidth: 4.0,
                          color: color,
                        ),
                      ],
                    );
                  }
                },
                connectorBuilder: (_, index, type) {
                  if (index > 0) {
                    if (index == _processIndex) {
                      final prevColor = getColor(index - 1);
                      final color = getColor(index);
                      List<Color> gradientColors;
                      if (type == ConnectorType.start) {
                        gradientColors = [
                          Color.lerp(prevColor, color, 0.5)!,
                          color
                        ];
                      } else {
                        gradientColors = [
                          prevColor,
                          Color.lerp(prevColor, color, 0.5)!
                        ];
                      }
                      return DecoratedLineConnector(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                          ),
                        ),
                      );
                    } else {
                      return SolidLineConnector(
                        color: getColor(index),
                      );
                    }
                  } else {
                    return null;
                  }
                },
                itemCount: _processes.length,
              ),
            ),
          ),
          Expanded(
            child: _processIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      RadioListTile<Dlivery>(
                        value: Dlivery.StandardDelivery,
                        groupValue: dlivery,
                        onChanged: (Dlivery? value) {
                          setState(() {
                            dlivery = value!;
                          });
                        },
                        title: Text(
                          'Standard Delivery',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        activeColor: PrimaryColor,
                        selectedTileColor: PrimaryColor,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                              'Order will be delivered between 3 - 5 business days'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RadioListTile<Dlivery>(
                        value: Dlivery.NextDayDelivery,
                        groupValue: dlivery,
                        onChanged: (Dlivery? value) {
                          setState(() {
                            dlivery = value!;
                          });
                        },
                        title: Text(
                          'Next Day Delivery',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        activeColor: PrimaryColor,
                        selectedTileColor: PrimaryColor,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                              'Place your order before 6pm and your items will be delivered the next day'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RadioListTile<Dlivery>(
                        value: Dlivery.NominatedDelivery,
                        groupValue: dlivery,
                        onChanged: (Dlivery? value) {
                          setState(() {
                            dlivery = value!;
                          });
                        },
                        title: Text(
                          'Nominated Delivery',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        activeColor: PrimaryColor,
                        selectedTileColor: PrimaryColor,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                              'Pick a particular date from the calendar and order will be delivered on selected date'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _processIndex =
                                      (_processIndex + 1) % _processes.length;
                                });
                              },
                              child: Text(
                                'NEXT',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: PrimaryColor,
                              height: 50,
                              minWidth: 146,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : _processIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  activeColor: PrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                Text(
                                    'Billing address is the same as delivery address')
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Street 1',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'Address 1'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Street 2',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'Address 2'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'City',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'City'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'State',
                                        style: TextStyle(
                                            color: Colors.grey.shade400),
                                      ),
                                      TextFormField(
                                        decoration:
                                            InputDecoration(hintText: 'State'),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {},
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Country',
                                        style: TextStyle(
                                            color: Colors.grey.shade400),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Country'),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _processIndex = (_processIndex + 1) %
                                            _processes.length;
                                      });
                                    },
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: PrimaryColor,
                                    height: 50,
                                    minWidth: 146,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GetBuilder<CartViewModel>(
                          builder: (controller) => Column(
                            children: [
                              Expanded(
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          buildCart(
                                              controller.cart[index], index),
                                      separatorBuilder: (context, index) => SizedBox(width: 30,),
                                      itemCount: controller.cart.length)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _processIndex = (_processIndex + 1) %
                                              _processes.length;
                                        });
                                      },
                                      child: Text(
                                        'NEXT',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: PrimaryColor,
                                      height: 50,
                                      minWidth: 146,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          init: CartViewModel(),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Delivery',
  'Address',
  'Summary',
];

Widget buildCart(CartModel? cart, int index) => Container(
    width: 120,
    height: 176,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Image.network(
        cart!.pic.toString(),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
      SizedBox(
        width: 30,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            cart.name.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                '\$${cart.price}',
                style: TextStyle(fontSize: 16, color: PrimaryColor),
              ),
              SizedBox(width: 30,),
              Text(
                '* ${cart.quantity}',
                style: TextStyle(fontSize: 16, color: PrimaryColor),
              ),
            ],
          ),
        ],
      )
    ]));
