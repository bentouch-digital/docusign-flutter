struct RecipientsModel: Decodable {
    let carbonCopies: Array<CarbonCopyModel>;
    let signers: Array<SignerModel>;
}
