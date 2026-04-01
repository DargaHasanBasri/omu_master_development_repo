import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_halving_method/core/models/iteration_step.dart';
import 'package:interval_halving_method/routes/app_route_names.dart';
import 'package:interval_halving_method/ui/screens/graphics/export.dart';
import 'package:interval_halving_method/ui/screens/graphics/components/function_graph_card.dart';
import 'package:interval_halving_method/ui/screens/graphics/components/playback_control_card.dart';
import 'package:interval_halving_method/ui/screens/graphics/components/interval_status_details_card.dart';
import 'package:interval_halving_method/ui/widgets/primary_action_button.dart';

class GraphicsScreen extends StatefulWidget {
  final int initialStepIndex;
  final List<IterationStep> steps;
  final String functionString;

  const GraphicsScreen({
    super.key,
    required this.initialStepIndex,
    required this.steps,
    required this.functionString,
  });

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  late int _currentIndex;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Ekran açıldığında iterasyon ekranından gelen indeksten başlatıyoruz
    _currentIndex = widget.initialStepIndex;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Bellek sızıntısını önlemek için timer'ı kapatıyoruz
    super.dispose();
  }

  void _nextStep() {
    if (_currentIndex < widget.steps.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _prevStep() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      // 1.5 saniyede bir sonraki adıma geçen otomatik oynatıcı
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (_currentIndex < widget.steps.length - 1) {
          setState(() => _currentIndex++);
        } else {
          // Son adıma gelince oynatmayı durdur
          _togglePlayPause();
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _onSliderChanged(double value) {
    // Slider 1'den başladığı için index'e çevirirken 1 çıkartıyoruz
    setState(() {
      _currentIndex = value.toInt() - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mevcut aktif adımı alıyoruz
    final currentStep = widget.steps[_currentIndex];
    final isLastStep = _currentIndex == widget.steps.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: ColorName.white,
        leading: IconButton(
          icon: Assets.icons.icArrowBack.image(
            package: AppConstants.packageGenName,
          ),
          onPressed: () => context.pop(), // go_router geri dönüş
        ),
        title: Text(
          'Graphics',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPaddings.largeAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. GRAFİK KARTI
              FunctionGraphCard(
                functionText: widget.functionString,
                currentStep: currentStep, // O anki adımın verileri
                initialStep: widget
                    .steps
                    .first, // X ve Y ekseninin limitlerini sabitlemek için ilk adım
              ),

              // 2. OYNATMA (PLAYBACK) KONTROLLERİ
              Padding(
                padding: AppPaddings.mediumVertical,
                child: PlaybackControlCard(
                  currentStep: currentStep.iteration,
                  // Slider 1'den başlar
                  totalSteps: widget.steps.length,
                  isPlaying: _isPlaying,
                  onPlayPausePressed: _togglePlayPause,
                  onPreviousPressed: _prevStep,
                  onNextPressed: _nextStep,
                  onSliderChanged: _onSliderChanged,
                ),
              ),

              // 3. O ANKİ İTERASYONUN DURUM KARTI
              IntervalStatusDetailsCard(
                statusText: isLastStep
                    ? 'Converged (Optimal Found)'
                    : 'Shrinking',
                intervalText:
                    '[${currentStep.a.toStringAsFixed(4)}, ${currentStep.b.toStringAsFixed(4)}]',
                midpointText: currentStep.xm.toStringAsFixed(4),
                fxmText: currentStep.fxm.toStringAsFixed(4),
                lengthText: currentStep.l.toStringAsFixed(4),
              ),

              Padding(
                padding: AppPaddings.xLargeVertical,
                child: PrimaryActionButton(
                  onPressed: () {
                    context.pushNamed(AppRouteNames.reportName);
                  },
                  text: 'Optimizasyon Rapor',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
