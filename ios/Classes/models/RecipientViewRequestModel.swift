struct RecipientViewRequestModel: Decodable {
    let authenticationMethod: String;
    let clientUserId: String;
    let email: String;
    let recipientId: String;
    let returnUrl: String;
    let userName: String;
}
