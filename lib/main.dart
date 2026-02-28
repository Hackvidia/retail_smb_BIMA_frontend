import 'package:retail_smb/screens/login_screen.dart';
import 'package:retail_smb/screens/before_dashboard.dart';
import 'package:retail_smb/screens/signup_screen.dart';
import 'package:retail_smb/screens/splash_screen.dart';
import 'package:retail_smb/screens/starter_screen.dart';
import 'package:retail_smb/screens/submit_capture_screen.dart';
import 'package:retail_smb/screens/sumary_suplier_chat_screen.dart';
import 'package:retail_smb/screens/wa_phone_numbers_loader_screen.dart';
import 'package:retail_smb/screens/wa_qr_screen.dart';
import 'package:retail_smb/screens/scan_camera_screen.dart';
import 'package:retail_smb/screens/photo_detection_result.dart';
import 'package:retail_smb/screens/operational_documents_screen.dart';
import 'package:retail_smb/screens/operational_documents_summary_screen.dart';
import 'package:retail_smb/screens/camera_prep_screen.dart';
import 'package:retail_smb/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:retail_smb/screens/home_screen.dart';
import 'package:retail_smb/screens/insight_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bima App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/': (context) => StarterScreen(),
          '/home-screen': (context) => HomeScreen(),
          '/insight-screen': (context) => InsightScreen(),
          '/splash': (context) => SplashScreen(),
          '/signup': (context) => SignupScreen(),
          '/before-dashboard': (context) => BeforeDashboardScreen(),
          '/wa-qr': (context) => WaQrScreen(),
          '/starter-app': (context) => StarterScreen(),
          '/wa-phone-number': (context) => WaPhoneNumbersLoaderScreen(),
          '/login': (context) => LoginScreen(),
          '/submit-capture': (context) => SubmitCaptureScreen(),
          '/scan-camera': (context) => ScanCameraScreen(),
          '/photo-detection-result': (context) => PhotoDetectionResult(),
          '/operational-documents': (context) => OperationalDocumentsScreen(),
          '/operational-documents-summary': (context) =>
              OperationalDocumentsSummaryScreen(),
          '/camera-prep': (context) => CameraPrepScreen(),
          '/summary-supplier': (context) => SumarySuplierChatScreen(),
        });
  }
}
