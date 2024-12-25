import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/rough/button.dart';

class StoreScreen extends StatefulWidget {

  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  static const _gap = SizedBox(height: 60);
  static const _itemGap = SizedBox(height: 12);

  Future<List<ProductDetails>>? _purchasesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inAppPurchaseController = context.read<InAppPurchaseController>();
      setState(() {
        _purchasesFuture = inAppPurchaseController.getPurchases();
      });
    });
  }

  Future<List<ProductDetails>> fetchPurchases(InAppPurchaseController inAppPurchaseController) {
    return inAppPurchaseController.getPurchases();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.trueWhite,
      body: ResponsiveScreen(
        squarishMainArea: ListView(
          children: [
            _gap,
            const Text(
              'Store',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
            _itemGap,
            Consumer<InAppPurchaseController?>(
                builder: (context, inAppPurchase, child) {
                  if (inAppPurchase == null) {
                    // In-app purchases are not supported yet.
                    return const SizedBox.shrink();
                  }
                var coinsAvailable = inAppPurchase.purchaseCount.value.toString();
                return _CoinsLine(
                    'Tic Coins',
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(coinsAvailable,
                            style: const TextStyle(
                              fontFamily: 'Permanent Marker',
                              fontSize: 40,
                            )
                        ),
                        const Icon(Icons.monetization_on, color: Color(0x99D4AF37), size: 50,)
                      ],
                    )
                );
             }) ,
            _gap,
            const Text(
              'Purchase',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 25,
                height: 1,
              ),
            ),
            _itemGap,
            Consumer<InAppPurchaseController?>(
                builder: (context, inAppPurchase, child) {
              if (inAppPurchase == null) {
                // In-app purchases are not supported yet.
                return const SizedBox.shrink();
              }
              return FutureBuilder<List<ProductDetails>>(
                future: _purchasesFuture, // Fetch data asynchronously
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No purchases found'));
                  } else {
                    // Data is available
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    snapshot.data![index].title.split('(')[0],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Permanent Marker',
                                      fontSize: 25,
                                      height: 1,
                                    )
                                ),
                                const Icon(Icons.monetization_on, color: Color(0x99D4AF37), size: 30,)
                              ],
                            ),
                            onTap: () {
                              // Handle item tap
                              inAppPurchase.buy(snapshot.data![index]);
                            },
                          );
                        },
                    );
                  }
                },
              );
            }),
            _gap,
          ],
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          textColor: palette.ink,
          child: const Text('Back'),
        ),
      ),
    );
  }
}

class _CoinsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  const _CoinsLine(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 24,
                )),
            const SizedBox(width: 16,),
            icon,
          ],
        ),
      ),
    );
  }

}
