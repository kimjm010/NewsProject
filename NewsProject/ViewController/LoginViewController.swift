//
//  LoginViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 4/27/22.
//

import UIKit
import AuthenticationServices


class LoginViewController: UIViewController {

    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
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
    
}




extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // TODO: keychain에 저장코드 구현하기
            
            self.showMainViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
        case let passwordCredential as ASPasswordCredential:
            
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            DispatchQueue.main.async {
                self.showMainViewController(userName: userName, password: password)
            }
            
        default:
            break
        }
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        // TODO: KeyChain 저장 구현하
//        do {
//            try
//        } catch {
//            print(error.localizedDescription, "Unable to save userIdentifier to Keychain.")
//        }
    }
    
    
    private func showMainViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        guard let vc = self.presentingViewController as? GeneralSettingsViewController else { return }
        
        DispatchQueue.main.async {
            vc.userEmail = email
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    private func showMainViewController(userName: String, password: String) {
        guard let vc = self.presentingViewController as? GeneralSettingsViewController else { return }
        
        DispatchQueue.main.async {
            vc.userEmail = userName
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        // handling error
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
}
