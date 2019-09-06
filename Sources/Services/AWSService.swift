//
//  AWSService.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/5/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public class AWSService: NSObject {

    // MARK: Properties

    public var enableLogs = false

    private var awsSession = URLSession()
    private var clientId = ""

    public typealias AWSCompletionHandler = (_ success: Any?, _ error: NSError?) -> Void
    public typealias AWSCompletionBoolHandler = (_ success: Bool) -> Void

    // MARK: Shared Instance

    public static let shared: AWSService = {
        let instance = AWSService()
        instance.setupManager()
        return instance
    }()

    // MARK: Setup Methods

    private func setupManager() {
        let config = URLSessionConfiguration.default
        self.awsSession = URLSession(configuration: config)
        self.consoleLog("AWS3A SDK", "🔶 setupManager()")
    }


    public func initialize(clientId: String) {
        self.clientId = clientId
        self.consoleLog("AWS3A SDK", "🔶 initialize(clientId: \(clientId)")
    }

    // MARK: Log Methods

    func consoleLog(_ title: String?, _ log: String) {
        if !self.enableLogs { return }
        print("❗️\(title ?? "AWS3A SDK")❗️")
        print("❗️\(log)❗️")
    }

    // MARK: AWS Restful Methods

    public func registerUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRegisterUser(clientId: self.clientId, email: email, password: password)
            self.consoleLog("AWS3A SDK: Register", "🌐 registerUser(email: \(email), password: \(password))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - registerUser: response", "✅ Success: [\(responseCode)] ❗️\n\(res.json)")
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmRegisterUser(email: String, code: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmRegisterUser(clientId: self.clientId, email: email, code: code)
            self.consoleLog("AWS3A SDK: Confirm Register", "🌐 confirmRegisterUser(email: \(email), code: \(code))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - confirmRegisterUser: response", "✅ Success: [\(responseCode)] ❗️\n\(true)")
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func loginUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestLoginUser(clientId: self.clientId, email: email, password: password)
            self.consoleLog("AWS3A SDK: Login User", "🌐 loginUser(email: \(email), password: \(password))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - loginUser: response", "✅ Success: [\(responseCode)] ❗️\n\(res.json)")
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmUser(email: String, newPassword: String, session: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmUser(clientId: self.clientId, email: email, newPassword: newPassword, session: session)
            self.consoleLog("AWS3A SDK: Confirm User", "🌐 confirmUser(email: \(email), newPassword: \(newPassword), session: \(session))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - confirmUser: response", "✅ Success: [\(responseCode)] ❗️\n\(true)")
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func refreshToken(refreshToken: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRefreshToken(clientId: self.clientId, refreshToken: refreshToken)
            self.consoleLog("AWS3A SDK: Refresh Token", "🌐 refreshToken(refreshToken: \(refreshToken))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - refreshToken: response", "✅ Success: [\(responseCode)] ❗️\n\(res.json)")
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
            }.resume()
        }
    }

    public func logout(accessToken: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestLogout(clientId: self.clientId, accessToken: accessToken)
            self.consoleLog("AWS3A SDK: Logout", "🌐 logout(accessToken: \(accessToken))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - logout: response", "✅ Success: [\(responseCode)] ❗️\n\(true)")
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func validateUser(accessToken: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestValidateUser(clientId: self.clientId, accessToken: accessToken)
            self.consoleLog("AWS3A SDK: Validate User", "🌐 validateUser(accessToken: \(accessToken))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - validateUser: response", "✅ Success: [\(responseCode)] ❗️\n\(res.json)")
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func changePassword(accessToken: String, previousPassword: String, proposedPassword: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestChangePassword(clientId: self.clientId, accessToken: accessToken, previousPassword: previousPassword, proposedPassword: proposedPassword)
            self.consoleLog("AWS3A SDK: Change Password", "🌐 requestChangePassword(accessToken: \(accessToken), previousPassword: \(previousPassword), proposedPassword: \(proposedPassword))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - requestChangePassword: response", "✅ Success: [\(responseCode)] ❗️\n\(res.json)")
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func resetPassword(username: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestResetPassword(clientId: self.clientId, username: username)
            self.consoleLog("AWS3A SDK: Reset Password", "🌐 requestResetPassword(username: \(username))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - requestResetPassword: response", "✅ Success: [\(responseCode)] ❗️\n\(true)")
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func resetConfirmPassword(username: String, password: String, code: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestResetConfirmPassword(clientId: self.clientId, username: username, password: password, code: code)
            self.consoleLog("AWS3A SDK: Reset Confirm Password", "🌐 resetConfirmPassword(username: \(username), password: \(password), code: \(code))")
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            self.consoleLog("AWS3A SDK - resetConfirmPassword: response", "✅ Success: [\(responseCode)] ❗️\n\(true)")
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    // MARK: Error Handling Methods

    private func awsHandleError(responseCode: Int, data: Data?, error: Error?) -> NSError? {
        let errorMessage = error?.localizedDescription ?? AWSError.unknownError.domain
        guard let data = data else {
            self.consoleLog("AWS3A SDK - awsHandleError: response", "🛑 Error: [\(responseCode)] ❗️\n\(errorMessage)")
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
        do {
            let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
            return self.awsHandleError(responseCode: responseCode, error: errorObject)
        } catch _ {
            self.consoleLog("AWS3A SDK - awsHandleError", "🛑 Error: [\(responseCode)] ❗️\n\(errorMessage)")
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
    }

    private func awsHandleError(responseCode: Int, error: AWSError?) -> NSError? {
        let errorMessage = error?.message ?? AWSError.unknownError.domain
        self.consoleLog("AWS3A SDK - awsHandleError", "🛑 Error: [\(responseCode)] ❗️\n\(errorMessage)")
        return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
    }
}
