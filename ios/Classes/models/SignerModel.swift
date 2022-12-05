struct SignerModel: Decodable {
    let clientUserId: String;
    let email: String;
    let firstName: String;
    let lastName: String;
    let name: String;
    let recipientId: String;
    let routingOrder: String;
    let smsAuthentication: RecipientSmsAuthenticationModel;
    let status: String;
    let tabs: TabsModel;
    let requireIdLookup: Bool;
    let idCheckConfigurationName: String;
}
