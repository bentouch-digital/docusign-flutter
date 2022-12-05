struct AuthModel: Decodable {
    let accessToken: String;
    let accountId: String;
    let userId: String;
    let userName: String;
    let email: String;
    let host: String;
    let integratorKey: String;
}
