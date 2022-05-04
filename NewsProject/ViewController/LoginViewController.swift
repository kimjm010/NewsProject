//
//  LoginViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 4/27/22.
//

import UIKit
import AuthenticationServices


class LoginViewController: CommonViewController {

    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    @IBOutlet weak var enterWithoutLoginButton: UIButton!
    
    @IBAction func enterWithoutLogin(_ sender: Any) {
        transitionToMainVC()
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
    
}




extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        var userNumber = 0
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            self.saveUserInKeychain(userIdentifier)
            
            transitionToMainVC()
            print("User ID: \(userIdentifier)")
            print("User Full Name: \(fullName?.givenName ?? "") + \(fullName?.familyName ?? "")")
            print("User Email: \(email ?? "")")
            
            userNumber += 1
            
            var user = User(name: "user \(userNumber)",
                            timeInterval: nil,
                            date: nil,
                            lat: nil,
                            lon: nil,
                            radius: nil)
            let userInfo = ["user": user]
            NotificationCenter.default.post(name: .sendUserName, object: nil, userInfo: userInfo)
            
        default:
            break
        }
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
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
    
    func showMainVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC)
    }
}
