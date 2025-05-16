import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

final List<String> imageList = [
  'assets/eiffel.jpeg',
  'assets/eiffel2.jpg',
  'assets/eiffel3.jpg',
  'assets/eiffel4.jpg',
];

class EiffelTowerScreen extends StatefulWidget {
  const EiffelTowerScreen({super.key});

  @override
  State<EiffelTowerScreen> createState() => _EiffelTowerScreenState();
}

class _EiffelTowerScreenState extends State<EiffelTowerScreen>
    with TickerProviderStateMixin {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  bool _showMask = true;
  bool _isExpanded = false;
  bool _isFabVisible = true;
  bool _isHandlingSheetChange = false;
  double _previousSize = 0.0;
  bool _isDragging = false;
  Timer? _dragEndTimer;



  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync:
          this, // Make sure your class extends SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    // _previousSize = _sheetController.size;
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
    _sheetController.addListener(_onSheetChanged);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _controller.dispose();
    _sheetController.dispose();
    _scaleController.dispose();
    _dragEndTimer?.cancel();
    super.dispose();
  }

  void playScaleAnimation() async {
    await _scaleController.forward(from: 0.0);
  }

 void _onSheetChanged() {
    // Skip if we're already handling a programmatic change
    if (_isHandlingSheetChange) return;
    
    final currentSize = _sheetController.size;
     // Initialize previousSize on first call if needed
    if (_previousSize == 0.0) {
      _previousSize = currentSize;
      return;
    }
    // Handle state changes based on current size
    if (currentSize >= 0.8 && !_isExpanded) {
      setState(() {
        _isExpanded = true;
        _showMask = false;
        _isFabVisible = false;
      });
    } else if (currentSize < 0.8 && _isExpanded) {
      setState(() {
        _isExpanded = false;
        _showMask = true;
        
        // We'll handle FAB visibility separately to ensure proper animation
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !_isExpanded) {
            setState(() {
              _isFabVisible = true;
              _scaleController.value = 0.0; // Start from zero scale
            });
            
            // Wait for the setState to apply, then animate
            Future.delayed(const Duration(milliseconds: 20), () {
              if (mounted && !_isExpanded) {
                _scaleController.forward();
              }
            });
          }
        });
      });
    }
    
    // Detect if user is currently dragging
    if (_previousSize != currentSize) {
      _isDragging = true;
      
      // Cancel any existing timer
      _dragEndTimer?.cancel();
      
      // Set a timer to detect when dragging stops
      _dragEndTimer = Timer(const Duration(milliseconds: 50), () {
        if (mounted) {
          _handleDragEnd(currentSize);
        }
        _isDragging = false;
      });
    }
    
    _previousSize = currentSize;
  }

  void _handleDragEnd(double finalSize) {
    // Only auto-snap if in an intermediate position
    if (_isHandlingSheetChange) return;
    
    if (finalSize > 0.3 && finalSize < 0.75) {
      // Determine if we should expand or collapse based on current position
      final shouldExpand = finalSize >= 0.5;
      
      // Avoid conflicting with ongoing animations
      Future.microtask(() {
        if (mounted && !_isHandlingSheetChange) {
          toggleSheet(isExpanding: shouldExpand);
        }
      });
    }
  }

   
  void _updateFabVisibility(double sheetSize) {
    final bool shouldShowFab = sheetSize < 0.5;
    
    if (shouldShowFab != _isFabVisible) {
      if (shouldShowFab) {
        // Show FAB
        setState(() {
          _isFabVisible = true;
          _scaleController.value = 0.0;  // Start from zero scale
        });
        
        // Wait for setState to apply, then animate
        Future.delayed(const Duration(milliseconds: 20), () {
          _scaleController.forward();
        });
      } else {
        // Hide FAB
        _scaleController.reverse().then((_) {
          setState(() {
            _isFabVisible = false;
          });
        });
      }
    }
  }

    void toggleSheet({bool? isExpanding}) async {
    // Set flag to indicate we're handling a programmatic change
    _isHandlingSheetChange = true;
    
    final currentSize = _sheetController.size;
    
    // Use the provided direction or determine based on current size
    final shouldExpand = isExpanding ?? currentSize < 0.8;

    if (shouldExpand) {
      // FAB is about to disappear — scale it out first
      await _scaleController.reverse(); // scale: 1 → 0
      
      setState(() {
        _isFabVisible = false;
      });
    }

    // Animate the sheet
    await _sheetController.animateTo(
      shouldExpand ? 0.8 : 0.25,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    setState(() {
      _isExpanded = shouldExpand;
      _showMask = !shouldExpand;
    });

    if (!shouldExpand) {
      // Show FAB with zero scale before animating
      setState(() {
        _isFabVisible = true;
        _scaleController.value = 0.0;  // Start from zero scale
      });
      
      // Wait for the setState to apply, then animate
      await Future.delayed(const Duration(milliseconds: 20));
      // FAB is now visible but at zero scale - animate it in
      _scaleController.forward();
    }
    
    // Reset the handling flag
    _isHandlingSheetChange = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Eiffel Tower image
          SizedBox.expand(
            child: Image.asset('assets/eiffel9.jpeg', fit: BoxFit.cover),
          ),

          // Background blur when sheet is expanded
          if (_isExpanded)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),

          // Top icons
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: _isExpanded ? toggleSheet : null,
                ),

                // Center title and location
                if (_isExpanded)
                  FadeTransition(
                    opacity: _animation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Eiffel Tower',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Wrap content
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.white70,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Paris, France',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const Icon(Icons.favorite_border, color: Colors.white),
              ],
            ),
          ),

          // Eiffel Tower info text
          if (!_isExpanded)
            Positioned(
              bottom: 150,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ON SALE',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Eiffel Tower',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.location_pin, color: Colors.white70),
                      SizedBox(width: 8),
                      Text(
                        'Paris, France',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 38),
                ],
              ),
            ),

          // Draggable content
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Horizontal thumbnails
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageList.length,
                              itemBuilder:
                                  (_, i) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imageList[i],
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Paris\' monument-lined boulevards, museums, '
                            'classical bistros and boutiques are enhanced by a '
                            'new wave of multimedia galleries, creative wine bars, '
                            'design shops and tech start-ups.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(153, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              'READ MORE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 11, 14, 107),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Video preview
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset('assets/eiffel6.jpg'),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Top Sights',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(153, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Sight item
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/eiffel2.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Musée du Louvre',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(153, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    'Top choice museum in\nLouvre & Les Halles',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(153, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 52, 59, 90),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.flight, color: Colors.white),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'SEARCH FLIGHTS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'ON SALE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Gradient white mask at the bottom
          if (_showMask)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white70,
                        Colors.white10,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Center airplane floating button
          if (!_isExpanded)
            Positioned(
              bottom: 40,
              left: MediaQuery.of(context).size.width / 2 - 28,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 52, 59, 90),
                  shape: const CircleBorder(),
                  onPressed: toggleSheet,
                  child: const Icon(
                    Icons.flight,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
