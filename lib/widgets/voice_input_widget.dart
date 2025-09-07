import 'package:flutter/material.dart';
import '../services/speech_service.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceCommand;
  final String lastRecognizedText;

  const VoiceInputWidget({
    super.key,
    required this.onVoiceCommand,
    required this.lastRecognizedText,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with SingleTickerProviderStateMixin {                //  provides a single "ticker" to drive animations within a StatefulWidget. 
  bool _isListening = false;                            // A ticker is a refresh rate signal that fires a callback on every frame, which an AnimationController uses to generate new animation values.
  String _currentText = '';
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(            
      duration: const Duration(milliseconds: 1000),     // Initializes the animation controller with a duration of 1 second.
      vsync: this,                                    //It his ties the animation to the widget's lifecycle, ensuring that the ticker only fires when the widget's subtree is active and visible.
    );
    _pulseAnimation = Tween<double>(            
      begin: 1.0,                            // Creates a pulse animation that scales between 1.0 and 1.3 (a 30% increase in size).
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,           // Curves.easeInOut: Makes the animation smooth, easing in and out.
    ));
  }                                // This setup creates a visual effect that indicates the app is actively listening.

  @override
  void dispose() {
    _animationController.dispose();
    // Cancel any ongoing speech recognition
    SpeechService.cancelListening();
    super.dispose();
  }

  Future<void> _startListening() async {
    // Check permissions
    if (!await SpeechService.checkMicrophonePermission()) {
      final granted = await SpeechService.requestMicrophonePermission();
      if (!granted) {
        _showErrorMessage('Microphone permission is required');
        return;
      }
    }

    setState(() {
      _isListening = true;
      _currentText = '';
    });

    // Start pulse animation                   This line starts a continuous pulsing animation that visually indicates the app is listening for voice input.
    _animationController.repeat(reverse: true);   //  Play forward (from 1.0 to 1.3 scale) , Then play backward (from 1.3 to 1.0 scale) , And repeat this cycle continuously
                                                  // This creates a "breathing" effect on the UI element (like a microphone icon pulsing).
    await SpeechService.startListening(
      onResult: (text) {
        if (mounted) {
          setState(() {
            _currentText = text;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          _animationController.stop();
          _showErrorMessage('Voice recognition error: $error');
        }
      },
    );
  }

  Future<void> _stopListening() async {
    await SpeechService.stopListening();

    if (mounted) {
      setState(() {
        _isListening = false;
      });

      // Stop pulse animation
      _animationController.stop();
      _animationController.reset();

      // Process the recognized text
      if (_currentText.isNotEmpty) {
        widget.onVoiceCommand(_currentText);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(            // SnackBar - That Below Pop-up
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Voice Command Section Header
          Row(
            children: [
              Icon(
                Icons.mic,
                color: Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Voice Commands',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Microphone Button
          Center(
            child: GestureDetector(        // For detecting taps
              onTap: _isListening ? _stopListening : _startListening,      // To toggle state from start and stop listening based on current state
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isListening ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.red : Colors.blue)
                                .withOpacity(0.3),
                            spreadRadius: _isListening ? 8 : 4,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Status Text
          Text(
            _isListening
                ? 'Listening... Tap to stop'
                : 'Tap microphone to start voice command',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _isListening ? Colors.red : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),

          // Current Recognition Text
          if (_isListening && _currentText.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,      // It  makes a widget expand horizontally to fill all available width in its parent container.
              child: Text(
                _currentText,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Last Recognized Text
          if (widget.lastRecognizedText.isNotEmpty && !_isListening)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Command:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lastRecognizedText,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Usage Examples
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,      // controls the vertical spacing between lines (or "runs") of widgets , defines the vertical space between rows when widgets wrap to a new line.
            children: [
              _buildExampleChip('Example ==>'),
              _buildExampleChip('Add 2 milk to list'),
              _buildExampleChip('Remove bread'),
              _buildExampleChip('Show my list'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue[600],
        ),
      ),
    );
  }
}
