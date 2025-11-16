import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/translations.dart';
import 'package:intl/intl.dart';

class EventCountdownPage extends StatefulWidget {
  final String currentLanguage;
  const EventCountdownPage({super.key, required this.currentLanguage});

  @override
  _EventCountdownPageState createState() => _EventCountdownPageState();
}

class _EventCountdownPageState extends State<EventCountdownPage> {
  final TextEditingController _eventNameController = TextEditingController();
  DateTime? _eventDate;
  TimeOfDay? _selectedTime;
  String _countdown = '';
  Timer? _timer;
  bool _hasCalculated = false;

  @override
  void dispose() {
    _timer?.cancel();
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _selectEventDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
        _calculateCountdown();
        _startTimer();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _calculateCountdown();
        _startTimer();
      });
    }
  }

  void _resetCalculator() {
    setState(() {
      _eventNameController.clear();
      _eventDate = null;
      _selectedTime = null;
      _countdown = '';
      _hasCalculated = false;
      _timer?.cancel();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateCountdown();
    });
  }

  void _calculateCountdown() {
    if (_eventDate == null) return;

    final now = DateTime.now();
    DateTime eventDateTime = DateTime(
      _eventDate!.year,
      _eventDate!.month,
      _eventDate!.day,
      _selectedTime?.hour ?? 0,
      _selectedTime?.minute ?? 0,
    );

    if (eventDateTime.isBefore(now)) {
      setState(() {
        _countdown = Translations.getTranslation(
            widget.currentLanguage, 'Event has already passed');
        _hasCalculated = true;
        _timer?.cancel();
      });
      return;
    }

    final difference = eventDateTime.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    setState(() {
      _countdown = '${days}d ${hours}h ${minutes}m ${seconds}s';
      _hasCalculated = true;
    });
  }

  Widget _buildEventDetailsCard() {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Event Details'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Event Name'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.edit,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                Translations.getTranslation(widget.currentLanguage, 'Select Date'),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _eventDate != null
                    ? DateFormat('MMMM d, yyyy').format(_eventDate!)
                    : Translations.getTranslation(
                        widget.currentLanguage, 'No date selected'),
                style: TextStyle(
                  color: _eventDate != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onTap: () => _selectEventDate(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                Translations.getTranslation(widget.currentLanguage, 'Select Time'),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : Translations.getTranslation(
                        widget.currentLanguage, 'No time selected'),
                style: TextStyle(
                  color: _selectedTime != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onTap: () => _selectTime(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard() {
    if (!_hasCalculated) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Time Until Event'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (_eventNameController.text.isNotEmpty)
                    Text(
                      _eventNameController.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _countdown,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (_eventDate != null) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Event Date')}: ${DateFormat('MMMM d, yyyy').format(_eventDate!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              if (_selectedTime != null)
                Text(
                  '${Translations.getTranslation(widget.currentLanguage, 'Event Time')}: ${_selectedTime!.format(context)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Event Countdown'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip: Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEventDetailsCard(),
              const SizedBox(height: 24),
              _buildCountdownCard(),
            ],
          ),
        ),
      ),
    );
  }
}
