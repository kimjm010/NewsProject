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
        
        return password
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
        } catch KeychainError.noPassword {
            // No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = KeychainItem.keychainQuery(withService: service, account: account)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    
    private static func keychainQuery(withService service: String, account: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrService as String] = account as AnyObject?
        }
        
        return query
    }
    
    
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "com.example.apple", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return ""
        }
    }
    
    
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "com.example.apple", account: "userIdentifier").deleteItem()
        } catch {
            print("Unable to delete userIdentifier from keychain")
        }
    }
}
