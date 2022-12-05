struct CreateEnvelopeModel: Decodable {
    let documentBase64: String;
    let envelopeName: String;
    let envelopeSubject: String;
    let envelopeMessage: String;
    let hostName: String;
    let hostEmail: String;
    let inPersonSignerName: String;
    let inPersonSignerEmail: String;
    let signerName: String;
    let signerEmail: String;
    // let signers: Array<String>;
}
