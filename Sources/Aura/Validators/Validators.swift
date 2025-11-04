//
//  Validators.swift
//  Aura
//
//  Created by Mehdi Legoullon on 04/11/2025.
//

import Vapor

extension ValidatorResults {
    public struct EmailValidation: ValidatorResult {
        public let isValid: Bool
        public var isFailure: Bool { !isValid }
        public var successDescription: String? { "est un email valide" }
        public var failureDescription: String? { "n'est pas un au format valide." }
    }
    
    public struct PasswordValidation: ValidatorResult {
        public let isValid: Bool
        public var isFailure: Bool { !isValid }
        public var successDescription: String? { "est un mot de passe valide" }
        public var failureDescription: String? { "doit contenir au moins 5 caractères." }
    }
    
    public struct FirstNameValidation: ValidatorResult {
        public let isValid: Bool
        public var isFailure: Bool { !isValid }
        public var successDescription: String? { "est un prénom valide" }
        public var failureDescription: String? { "ne peut pas être vide." }
    }
}

extension Validator where T == String {
    public static var email: Validator<T> {
        .init { email in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let range = email.range(of: emailRegex, options: .regularExpression)
            return ValidatorResults.EmailValidation(isValid: range != nil)
        }
    }
    
    public static var password: Validator<T> {
        .init { password in
            return ValidatorResults.PasswordValidation(isValid: password.count >= 5)
        }
    }
    
    public static var firstName: Validator<T> {
        .init { firstName in
            return ValidatorResults.FirstNameValidation(isValid: !firstName.isEmpty)
        }
    }
}
