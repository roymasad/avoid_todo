enum TrustedSupportChannel { sms, email }

class TrustedSupportContact {
  final int? id;
  final String contactId;
  final String contactName;
  final TrustedSupportChannel channel;
  final String destinationValue;
  final String destinationLabel;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrustedSupportContact({
    this.id,
    required this.contactId,
    required this.contactName,
    required this.channel,
    required this.destinationValue,
    required this.destinationLabel,
    this.isEnabled = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactId': contactId,
      'contactName': contactName,
      'channel': channel.name,
      'destinationValue': destinationValue,
      'destinationLabel': destinationLabel,
      'isEnabled': isEnabled ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TrustedSupportContact.fromMap(Map<String, dynamic> map) {
    return TrustedSupportContact(
      id: map['id'] as int?,
      contactId: map['contactId'] as String,
      contactName: map['contactName'] as String,
      channel: TrustedSupportChannel.values.firstWhere(
        (value) => value.name == map['channel'],
        orElse: () => TrustedSupportChannel.sms,
      ),
      destinationValue: map['destinationValue'] as String,
      destinationLabel: map['destinationLabel'] as String,
      isEnabled: (map['isEnabled'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  TrustedSupportContact copyWith({
    int? id,
    String? contactId,
    String? contactName,
    TrustedSupportChannel? channel,
    String? destinationValue,
    String? destinationLabel,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrustedSupportContact(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      channel: channel ?? this.channel,
      destinationValue: destinationValue ?? this.destinationValue,
      destinationLabel: destinationLabel ?? this.destinationLabel,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
