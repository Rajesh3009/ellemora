import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkUtils {
  static Future<bool> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static void showNetworkError(BuildContext context, VoidCallback onRetry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('No internet connection'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: onRetry,
        ),
      ),
    );
  }
} 