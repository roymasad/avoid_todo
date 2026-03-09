import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  static const LatLng _fallbackLocation = LatLng(20, 0);

  late LatLng _selectedLocation;
  final MapController _mapController = MapController();
  String _address = 'Fetching address...';
  bool _isFetching = false;
  int _reverseGeocodeRequestId = 0;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLat != null && widget.initialLng != null
        ? LatLng(widget.initialLat!, widget.initialLng!)
        : _fallbackLocation;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialLat != null && widget.initialLng != null) {
        _reverseGeocode(_selectedLocation);
      } else {
        _loadCurrentLocation(initialLoad: true);
      }
    });
  }

  Future<void> _reverseGeocode(LatLng location) async {
    final requestId = ++_reverseGeocodeRequestId;
    setState(() => _isFetching = true);

    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (!mounted || requestId != _reverseGeocodeRequestId) return;

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      setState(() {
        _address = placemark != null
            ? _formatPlacemark(placemark, location)
            : _formatCoordinates(location);
      });
    } catch (_) {
      if (!mounted || requestId != _reverseGeocodeRequestId) return;
      setState(() => _address = _formatCoordinates(location));
    } finally {
      if (mounted && requestId == _reverseGeocodeRequestId) {
        setState(() => _isFetching = false);
      }
    }
  }

  String _formatPlacemark(Placemark placemark, LatLng location) {
    final parts = [
      placemark.name,
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return _formatCoordinates(location);
    }
    return parts.toSet().join(', ');
  }

  String _formatCoordinates(LatLng location) {
    return '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}';
  }

  Future<void> _loadCurrentLocation({required bool initialLoad}) async {
    setState(() {
      _isFetching = true;
      if (initialLoad) {
        _address = 'Finding your current location...';
      }
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _isFetching = false;
          _address = initialLoad
              ? 'Turn on location services to start from where you are.'
              : _formatCoordinates(_selectedLocation);
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isFetching = false;
          _address = initialLoad
              ? 'Allow location access to start from where you are.'
              : _formatCoordinates(_selectedLocation);
        });
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        if (!mounted) return;
        setState(() {
          _isFetching = false;
          _address = initialLoad
              ? 'Could not detect your current location.'
              : _formatCoordinates(_selectedLocation);
        });
        return;
      }

      final location = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() {
        _selectedLocation = location;
        _address = 'Fetching address...';
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(location, 15);
        }
      });
      await _reverseGeocode(location);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isFetching = false;
        _address = initialLoad
            ? 'Could not detect your current location.'
            : _formatCoordinates(_selectedLocation);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: widget.initialLat != null ? 15 : 3,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _selectedLocation = position.center;
                    _address = 'Fetching address...';
                  });
                }
              },
              onMapEvent: (event) {
                if (event is MapEventMoveEnd) {
                  _reverseGeocode(_selectedLocation);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.roymassaad.avoid_todo',
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red.shade700,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: topInset + kToolbarHeight + 12,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'map_locate_me',
              onPressed: _isFetching
                  ? null
                  : () => _loadCurrentLocation(initialLoad: false),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.blue.shade700,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.map_outlined, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              _isFetching ? 'Locating...' : _address,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isFetching
                          ? null
                          : () {
                              Navigator.pop(context, {
                                'lat': _selectedLocation.latitude,
                                'lng': _selectedLocation.longitude,
                                'address': _address,
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
