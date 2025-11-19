import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../core/models/product_model.dart';
import '../../core/ui/themes/font.dart';
import '../../services/constants.dart';
import '../home_screen/shimmer/shimmer.dart';

class CartProductCard extends StatefulWidget {
  final Product product;

  const CartProductCard({super.key, required this.product});

  @override
  CartProductCardState createState() => CartProductCardState();
}

class CartProductCardState extends State<CartProductCard> {
  final Box<Product> cartBox = Hive.box<Product>(HiveConstant.cartProductBox);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl[0],
              placeholder: (context, url) =>
                  const ShimmerImage(hight: 110, width: 140),
              filterQuality: FilterQuality.low,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) {
                return Hero(
                  tag: 'product_${widget.product.id}',
                  transitionOnUserGestures: true,
                  child: Container(
                    height: 110,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imageProvider,
                        scale: 0.1,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 15,
            left: 155,
            right: 40,
            child: Text(
              widget.product.name,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: Font.semiBold,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: 75,
            left: 155,
            right: 10,
            child: Text(
              '\$${widget.product.price}',
              style: const TextStyle(
                fontFamily: Font.semiBold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  cartBox.delete(widget.product.id);
                });
              },
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 0,
            child: SizedBox(
              width: 110,
              height: 35,
              child: ElevatedButton(
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CartScreen()));
                onPressed: () {
                  setState(() {
                    if (!cartBox.containsKey(widget.product.id)) {
                      cartBox.put(widget.product.id, widget.product);
                    } else {
                      cartBox.delete(widget.product.id);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: Font.semiBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
