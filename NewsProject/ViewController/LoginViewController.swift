//
//  LoginViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 4/27/22.
//

import UIKit
import AuthenticationServices


enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unexpectedItemData
    case unhandledError
}


class LoginViewController: CommonViewController {
    
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    @IBOutlet weak var enterWithoutLoginButton: UIButton!
    
    @IBOutlet weak var userIdTextfield: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var service: String = {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return "test.keychain"}
        
        return bundleIdentifier
    }()
    
    @IBAction func enterWithoutLogin(_ sender: Any) {
        transitionToMainVC()
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        signIn()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    
    func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let requests = appleIDProvider.createRequest()
        requests.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [requests])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    private func signIn() {
        guard let userId = userIdTextfield.text, userId.count > 0 else { return }
        guard let passowrd = passwordTextField.text, passowrd.count > 0 else { return }
        
        showMainVC()
        
        // let name = UIDevice.current.name
    }
    
    
    // MARK: Keychain Service
    
    /// load userId from Keychain
    /// - Returns: Core Foundation Object(Any Object)
    private func loadKeychain() throws -> String {
        guard let userIdValue = userIdTextfield.text else { return "" }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: userIdValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        do {
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
            guard status == errSecSuccess else { throw KeychainError.unhandledError }
            
            return ""
            
        } catch let error {
            print(error.localizedDescription, "\(#function)에서 에러 발생!")
        }
        
        return ""
    }
    
    
    /// add user account to Keychain
    /// - Parameters:
    ///   - userIdValue: user account's ID
    ///   - passwordValue: user account's password
    /// - Returns: Bool value depends on success or fail to add
    private func addKeychain(userIdValue: String, passwordValue: String) -> Bool {
        let account = userIdValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordValue.data(using: .utf8) as Any
        
        let query : [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: password
        ]
        
        let status = SecItemAdd(query as CFDictionary , nil)
        
        do {
            guard status == errSecSuccess else { throw KeychainError.unhandledError }
            
            return true
        } catch let error {
            print(error.localizedDescription, "\(#function)에서 에러 발생!")
        }
        return false
    }
    
    
    /// update user account's value from Keychain
    /// - Parameters:
    ///   - userIdValue: update userId value
    ///   - passwordValue: update user's password value
    /// - Returns: Bool value depends on success or fail to update
    private func updateKeychain(userIdValue: String, passwordValue: String) -> Bool {
        let account = userIdValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordValue.data(using: .utf8) as Any
        
        // query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        let attributes: [String: Any] = [
            kSecAttrAccount as String: account,
            kSecValueData as String: password
        ]
        
        // update item
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        do {
            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
            guard status == errSecSuccess else { throw KeychainError.unhandledError }
            
            return true
        } catch let error {
            print(error.localizedDescription, "\(#function)에서 에러 발생!")
        }
        
        return false
    }
    
    
    /// delete userr account from Keychain
    /// - Parameter userIdValue: user Id Value
    /// - Returns: Bool value depends on success or fail to delete
    private func deletKeychain(userIdValue: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userIdValue,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        do {
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.unhandledError
            }
            
            return true
        } catch let error {
            print(error.localizedDescription, "\(#function)에서 에러 발생!")
        }
        return false
    }
}




extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // create account
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            self.saveUserInKeychain(userIdentifier)
            
            transitionToMainVC()
            print("User ID: \(userIdentifier)")
            print("User Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("User Email: \(email ?? "")")
            
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("User Name: \(username)")
            print("User Password: \(password)")
        default:
            break
        }
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "NewsProject", account: "userIdentifier").addKeychain(userIdentifier)
            //saveItem(userIdentifier)
            
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        print(error.localizedDescription)
        #endif
    }
}




extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}




extension UIViewController {
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func showMainVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC)
        //        self.present(mainVC, animated: true, completion: nil)
    }
}




extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 101:
            guard let text = textField.text else { return false }
            guard text.count > 0 else { return false }
            return true
        case 102:
            signIn()
            return true
        default:
            break
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
