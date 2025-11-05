import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_qr/cubits/qr/qr_cubit.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final QrCubit _qrCubit = sl<QrCubit>();
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _qrCubit.initialiseCamera(shouldStreamCamera: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Scan a QR Code', onBack: () => Navigator.pop(context),
            subtitle: 'Quickly find a friend by scanning their profile QR code, no search needed.',
            backButtonColor: AppColors.pinkLavender,
            iconColor: AppColors.cerise,
          ),
          Expanded(
            child: BlocConsumer<QrCubit, QrState>(
              bloc: _qrCubit,
              listener: (context, state) async {
                if (state is BarcodeFound && !_handled) {
                  _handled = true;
                  final value = state.mainQrState.barcodeValue ?? '';
                  if (mounted) Navigator.of(context).pop(value);
                }

                if (state is QrError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mainQrState.errorMessage ?? state.mainQrState.message ?? 'Scan error')));
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      state.mainQrState.cameraPreview,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () => _qrCubit.toggleFlash(state.mainQrState.flashStatus),
                              icon: Icon(state.mainQrState.flashStatus ? Icons.flash_off : Icons.flash_on, color: Colors.white, size: 32),
                            ),
                            IconButton(
                              onPressed: () => _qrCubit.flipCamera(flipStatus: state.mainQrState.flipStatus),
                              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _qrCubit.dispose();
    super.dispose();
  }
}
