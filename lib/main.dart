import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:googleads/screens/ad%20helper.dart';
import 'package:googleads/services/ads.dart';
import 'package:googleads/variables.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  Ads ad = Ads();
 late InterstitialAd interstitialAd;
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad${error.message}");
          isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();

    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this.interstitialAd = ad;
          isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("failed to Load Interstitial Ad ${error.message}");
        }));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Mobile Ads"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Simple Container
              Container(
                height: 70,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              //Simple Container
              Container(
                height: 70,
                color: Colors.indigo,
              ),
              SizedBox(height: 20),
              if (isBannerAdReady)
                Container(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              SizedBox(height: 20),
              Container(
                height: 70,
                color: Colors.deepOrange,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  height: 70,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: isInterstitialAdReady ? interstitialAd.show : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("interstitial Ad"),
                  )),
             
                
            ],
          ),
        ),
      ),
    );
  }
}
