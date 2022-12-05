class EnvelopeModel {
  late final String documentBase64;
  late final String envelopeName;
  late final String envelopeSubject;
  late final String envelopeMessage;
  late final String hostName;
  late final String hostEmail;
  late final String inPersonSignerName;
  late final String inPersonSignerEmail;
  late final String signerName;
  late final String signerEmail;
  late final List<String> signers;

  EnvelopeModel({
    required this.documentBase64,
    required this.envelopeName,
    required this.envelopeSubject,
    required this.envelopeMessage,
    required this.hostName,
    required this.hostEmail,
    required this.signerName,
    required this.signerEmail,
    required this.signers,
  });

  EnvelopeModel.fromJson(Map<String, dynamic> json)
      : documentBase64 = json['documentBase64'],
        envelopeName = json['envelopeName'],
        envelopeSubject = json['envelopeSubject'],
        envelopeMessage = json['envelopeMessage'],
        hostName = json['hostName'],
        hostEmail = json['hostEmail'],
        inPersonSignerName = json['inPersonSignerName'],
        inPersonSignerEmail = json['inPersonSignerEmail'],
        signerName = json['signerName'],
        signerEmail = json['signerEmail'],
        signers = json['signers'];

  Map<String, dynamic> toJson() => {
        'documentBase64': documentBase64,
        'envelopeName': envelopeName,
        'envelopeSubject': envelopeSubject,
        'envelopeMessage': envelopeMessage,
        'hostName': hostName,
        'hostEmail': hostEmail,
        'inPersonSignerName': inPersonSignerName,
        'inPersonSignerEmail': inPersonSignerEmail,
        'signerName': signerName,
        'signerEmail': signerEmail,
        'signers': signers,
      };
}
