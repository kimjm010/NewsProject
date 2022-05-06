//
//  KeychainItem.swift
//  NewsProject
//
//  Created by Chris Kim on 5/3/22.
//

import Foundation


struct KeychainItem {
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    let service: String
    var account: String
    
    
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
    
    
    // MARK: Keychain access
    
    /// load userId from Keychain
    /// - Returns: Core Foundation Object(Any Object)
    func loadKeychain(_ account: String) throws -> String {
        
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
        
        guard let existingItem = item as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8) else {
                  throw KeychainError.unexpectedPasswordData
              }
        
        print("Keychain이 로드되었습니다.")
        return password
    }
    
    func readItem() throws -> String {
        var query = KeychainItem.keychainQuery(withService: service, account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // feth the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // check return status.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8) else {
                  throw KeychainError.unexpectedPasswordData
              }
        print("Keychain이 로드되었습니다.")
        return password
    }
    
    
    /// add user account to Keychain
    /// - Parameters:
    ///   - userIdValue: user account's ID
    ///   - passwordValue: user account's password
    /// - Returns: Bool value depends on success or fail to add
    func addKeychain(_ passwordValue: String) throws {
        guard let password = passwordValue.data(using: .utf8) else { throw KeychainError.unhandledError }
        
        let query : [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        var attributesToUpdate = [String: AnyObject]()
        attributesToUpdate[kSecValueData as String] = password as AnyObject?
        
        
        
        do {
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == errSecSuccess else { throw KeychainError.unhandledError }
            print("Keychain이 업데이트되었습니다.")
        } catch KeychainError.noPassword {
            var newItrm = [String: AnyObject]()
            newItrm[kSecValueData as String] = password as AnyObject?
            
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError }
            print("Keychain에 저장되었습니다.")
        }
    }
    
    
    func saveItem(_ password: String) throws {
        guard let encodedPassword = password.data(using: .utf8) else { throw KeychainError.unhandledError }
        
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
            print("Keychain이 업데이트되었습니다.")
        } catch KeychainError.noPassword {
            // No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = KeychainItem.keychainQuery(withService: service, account: account)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
            print("Keychain에 저장되었습니다.")
        }
    }
    
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
        print("Keychain이 삭제되었습니다.")
    }
    
    
    private static func keychainQuery(withService service: String, account: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        return query
    }
    
    
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "NewsProject", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return ""
        }
    }
    
    
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "NewsProject", account: "userIdentifier").deleteItem()
        } catch {
            print("Unable to delete userIdentifier from keychain")
        }
    }
}
