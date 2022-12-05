struct DocumentModel: Decodable {
    let documentBase64: String;
    let documentId: String;
    let fileExtension: String;
    let includeInDownload: Bool;
    let name: String;
}
