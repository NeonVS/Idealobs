import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';

class OrderItemCard extends StatefulWidget {
  OrderItem item;
  OrderItemCard(this.item);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 10,
            ),
            width: MediaQuery.of(context).size.width - 20.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Center(
                        child: Container(
                          height: 12.0,
                          width: 12.0,
                          decoration: BoxDecoration(
                            color:
                                value ? Colors.deepPurple[400] : Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  height: 150,
                  width: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1593642634524-b40b5baae6bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1189&q=80',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.item.product.productName,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        SizedBox(width: 7.0),
                        Text(
                          'x${widget.item.quantity}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      'Company :' + '${widget.item.product.companyName}',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      '\$' + '${widget.item.product.price}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xFFFDD34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
