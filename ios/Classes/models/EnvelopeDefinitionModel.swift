struct EnvelopeDefinitionModel: Decodable {
    let documents: Array<DocumentModel>;
    let emailSubject: String;
    let recipients: RecipientsModel;
    let status: String;
}
