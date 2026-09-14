import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioFeedbackService {
  static bool isSoundEnabled = true;

  // Pre-synthesized PCM WAV buffers
  static Uint8List? _successWav;
  static Uint8List? _errorWav;
  static Uint8List? _fanfareWav;
  static Uint8List? _clickWav;

  static void initialize() {
    _successWav ??= _generateSuccessSound();
    _errorWav ??= _generateErrorSound();
    _fanfareWav ??= _generateFanfareSound();
    _clickWav ??= _generateClickSound();
  }

  static void playSuccess() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    if (!isSoundEnabled) return;

    initialize();
    _playSoundBytes(_successWav!);
  }

  static void playError() {
    HapticFeedback.heavyImpact();
    if (!isSoundEnabled) return;

    initialize();
    _playSoundBytes(_errorWav!);
  }

  static void playClick() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
    if (!isSoundEnabled) return;

    initialize();
    _playSoundBytes(_clickWav!);
  }

  static void playComplete() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    if (!isSoundEnabled) return;

    initialize();
    _playSoundBytes(_fanfareWav!);
  }

  static final Map<int, Uint8List> _comboWavs = {};

  static void playMatchCombo(int combo) {
    HapticFeedback.selectionClick();
    if (!isSoundEnabled) return;

    final clampedCombo = combo.clamp(1, 6);
    if (!_comboWavs.containsKey(clampedCombo)) {
      _comboWavs[clampedCombo] = _generateComboSound(clampedCombo);
    }
    _playSoundBytes(_comboWavs[clampedCombo]!);
  }

  static Uint8List _generateComboSound(int combo) {
    const sampleRate = 22050;
    final samples = <int>[];

    final pitches = [523.25, 587.33, 659.25, 783.99, 880.00, 1046.50];
    final baseFreq = pitches[(combo - 1).clamp(0, pitches.length - 1)];

    final nSamples = (sampleRate * 0.14).toInt();
    for (var i = 0; i < nSamples; i++) {
      final t = i / sampleRate;
      final envelope = math.exp(-4.0 * (i / nSamples));
      final s1 = math.sin(2 * math.pi * baseFreq * t);
      final s2 = 0.4 * math.sin(2 * math.pi * baseFreq * 2 * t);
      final value = ((s1 + s2) * 16000 * envelope).toInt();
      samples.add(value);
    }

    return _buildWav(samples, sampleRate);
  }

  static AudioPlayer? _player;

  static void _playSoundBytes(Uint8List bytes) {
    try {
      _player ??= AudioPlayer();
      _player!.stop().catchError((_) {});
      _player!.play(BytesSource(bytes)).catchError((_) {});
    } catch (_) {
      // Graceful fallback for headless or audio-disabled test environments
    }
  }

  // --- Procedural WAV Synthesizer ---

  static Uint8List _buildWav(List<int> samples, int sampleRate) {
    final dataSize = samples.length * 2;
    final fileSize = 36 + dataSize;
    final buffer = ByteData(44 + dataSize);

    // RIFF header
    buffer.setUint8(0, 0x52); // R
    buffer.setUint8(1, 0x49); // I
    buffer.setUint8(2, 0x46); // F
    buffer.setUint8(3, 0x46); // F
    buffer.setUint32(4, fileSize, Endian.little);
    // WAVE
    buffer.setUint8(8, 0x57);  // W
    buffer.setUint8(9, 0x41);  // A
    buffer.setUint8(10, 0x56); // V
    buffer.setUint8(11, 0x45); // E
    // fmt 
    buffer.setUint8(12, 0x66); // f
    buffer.setUint8(13, 0x6D); // m
    buffer.setUint8(14, 0x74); // t
    buffer.setUint8(15, 0x20); // space
    buffer.setUint32(16, 16, Endian.little); // Subchunk size (16 for PCM)
    buffer.setUint16(20, 1, Endian.little);  // AudioFormat 1 = PCM
    buffer.setUint16(22, 1, Endian.little);  // Mono
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
    buffer.setUint16(32, 2, Endian.little);  // Block align
    buffer.setUint16(34, 16, Endian.little); // Bits per sample
    // data
    buffer.setUint8(36, 0x64); // d
    buffer.setUint8(37, 0x61); // a
    buffer.setUint8(38, 0x74); // t
    buffer.setUint8(39, 0x61); // a
    buffer.setUint32(40, dataSize, Endian.little);

    var offset = 44;
    for (final sample in samples) {
      buffer.setInt16(offset, sample.clamp(-32768, 32767), Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }

  static Uint8List _generateSuccessSound() {
    const sampleRate = 22050;
    final samples = <int>[];

    // Note 1: D5 (587.33 Hz) for 80ms
    final n1Samples = (sampleRate * 0.08).toInt();
    for (var i = 0; i < n1Samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / n1Samples) * 0.5;
      final value = (math.sin(2 * math.pi * 587.33 * t) * 14000 * envelope).toInt();
      samples.add(value);
    }

    // Note 2: A5 (880.00 Hz) for 200ms
    final n2Samples = (sampleRate * 0.20).toInt();
    for (var i = 0; i < n2Samples; i++) {
      final t = i / sampleRate;
      final envelope = math.exp(-3.5 * (i / n2Samples));
      final value = (math.sin(2 * math.pi * 880.00 * t) * 18000 * envelope).toInt();
      samples.add(value);
    }

    return _buildWav(samples, sampleRate);
  }

  static Uint8List _generateErrorSound() {
    const sampleRate = 22050;
    final samples = <int>[];

    // Descending buzzer: A3 (220 Hz) -> E3 (164.81 Hz)
    final n1Samples = (sampleRate * 0.10).toInt();
    for (var i = 0; i < n1Samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / n1Samples) * 0.3;
      // Slight saw wave for buzzer tone
      final s = math.sin(2 * math.pi * 220.00 * t);
      final s2 = 0.3 * math.sin(2 * math.pi * 440.00 * t);
      final value = ((s + s2) * 12000 * envelope).toInt();
      samples.add(value);
    }

    final n2Samples = (sampleRate * 0.18).toInt();
    for (var i = 0; i < n2Samples; i++) {
      final t = i / sampleRate;
      final envelope = math.exp(-3.0 * (i / n2Samples));
      final s = math.sin(2 * math.pi * 164.81 * t);
      final s2 = 0.3 * math.sin(2 * math.pi * 329.62 * t);
      final value = ((s + s2) * 14000 * envelope).toInt();
      samples.add(value);
    }

    return _buildWav(samples, sampleRate);
  }

  static Uint8List _generateFanfareSound() {
    const sampleRate = 22050;
    final samples = <int>[];

    // C5 -> E5 -> G5 -> C6 Arpeggio
    final notes = [
      (523.25, 0.08), // C5
      (659.25, 0.08), // E5
      (783.99, 0.08), // G5
      (1046.50, 0.28), // C6
    ];

    for (final note in notes) {
      final noteSamples = (sampleRate * note.$2).toInt();
      for (var i = 0; i < noteSamples; i++) {
        final t = i / sampleRate;
        final envelope = note == notes.last
            ? math.exp(-2.5 * (i / noteSamples))
            : (1.0 - (i / noteSamples) * 0.3);
        final value = (math.sin(2 * math.pi * note.$1 * t) * 16000 * envelope).toInt();
        samples.add(value);
      }
    }

    return _buildWav(samples, sampleRate);
  }

  static Uint8List _generateClickSound() {
    const sampleRate = 22050;
    final samples = <int>[];

    final nSamples = (sampleRate * 0.02).toInt();
    for (var i = 0; i < nSamples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / nSamples);
      final value = (math.sin(2 * math.pi * 1400.0 * t) * 10000 * envelope).toInt();
      samples.add(value);
    }

    return _buildWav(samples, sampleRate);
  }
}
