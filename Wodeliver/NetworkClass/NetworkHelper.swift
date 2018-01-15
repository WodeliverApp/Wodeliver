//
//  NetworkHelper.swift
//  Wodeliver
//
//  Created by Anuj Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkHelper{
    
    static func request(method: HTTPMethod, url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : method, parameters : param,  encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    if json["statusCode"].stringValue == "401" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 401)
                        completionHandler(nil,error)
                        // UserManager.logout(isDisable: false)
                    }else if json["statusCode"].stringValue == "404" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 404)
                        completionHandler(nil,error)
                    }else if json["statusCode"].stringValue == "426" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 426)
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", json["updateInfoText"].stringValue, controller, "Update", false, completionHandler: {
                                //  UIApplication.shared.openURL(URL.init(string: AppConstant.appStoreUrl)!)
                            })
                        }
                        completionHandler(nil,error)
                    }else{
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["errorMessage"].stringValue, controller)
                        }
                        if json["statusCode"].stringValue == "4XX"{
                            let error = NSError.init(domain: json["errorMessage"].stringValue, code: 400)
                            completionHandler(nil,error)
                        }else{
                            let error = NSError.init(domain: json["errorMessage"].stringValue, code: 500)
                            completionHandler(nil,error)
                        }
                    }
                }else{
                    if let updateInfoText = response.response?.allHeaderFields["updateInfoText"] as? String {
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", updateInfoText, controller, "Update", true, completionHandler: {
                            })
                        }
                    }
                    completionHandler(json, nil)
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func post(url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        headers["Content-Type"] = "application/json"
        Alamofire.request(url, method : .post, parameters : param,  encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    if json["status"].stringValue == "401" {
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["message"].stringValue, controller)
                        }
                    }else{
                        completionHandler(json, nil)
                    }
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    
    static func get(url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        headers["Content-Type"] = "application/json"
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : .get, parameters : param, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    if json["status"].stringValue == "401" {
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["message"].stringValue, controller)
                        }
                    }else{
                        completionHandler(json, nil)
                    }
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func put(url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        //  headers["Myu-Auth-Token"] = UserManager.getAuthToken()
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : .put, parameters : param,  encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    completionHandler(json, nil)
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func patch(url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : .patch, parameters : param,  encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    if json["statusCode"].stringValue == "401" {
                        let error = NSError.init(domain: "PATCH", code: 401, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        completionHandler(nil,error)
                    }else if json["statusCode"].stringValue == "404" {
                        let error = NSError.init(domain: "PATCH", code: 404, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        completionHandler(nil,error)
                    }else if json["statusCode"].stringValue == "426" {
                        let error = NSError.init(domain: "PATCH", code: 426, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", json["updateInfoText"].stringValue, controller, "Update", false, completionHandler: {
                            })
                        }
                        completionHandler(nil,error)
                    }else{
                        let errorReport: NSError
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["errorMessage"].stringValue, controller)
                        }
                        if json["statusCode"].stringValue == "4XX"{
                            let error = NSError.init(domain: "PATCH", code: 400, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                            errorReport = error
                            completionHandler(nil,error)
                        }else{
                            let error = NSError.init(domain: "PATCH", code: 500, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                            errorReport = error
                            completionHandler(nil,error)
                        }
                    }
                }else{
                    if let updateInfoText = response.response?.allHeaderFields["updateInfoText"] as? String {
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", updateInfoText, controller, "Update", true, completionHandler: {
                            })
                        }
                    }
                    completionHandler(json, nil)
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func delete(url: String, param: [String: Any], _ controller:UIViewController?, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : .delete, parameters : param, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                // json = JSON.parse(value.replace(target: "null", withString: "\"\""))
                if json["statusCode"].stringValue != "2XX"{
                    if json["statusCode"].stringValue == "401" {
                        let error = NSError.init(domain: "DELETE", code: 401, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        completionHandler(nil,error)
                        //                        UserManager.logout(isDisable: false)
                    }else if json["statusCode"].stringValue == "404" {
                        let error = NSError.init(domain: "DELETE", code: 404, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        completionHandler(nil,error)
                    }else if json["statusCode"].stringValue == "426" {
                        let error = NSError.init(domain: "DELETE", code: 426, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", json["updateInfoText"].stringValue, controller, "Update", false, completionHandler: {
                                //                                UIApplication.shared.openURL(URL.init(string: AppConstant.appStoreUrl)!)
                            })
                        }
                        completionHandler(nil,error)
                    }else{
                        let errorReport: NSError
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["errorMessage"].stringValue, controller)
                        }
                        if json["statusCode"].stringValue == "4XX"{
                            let error = NSError.init(domain: "DELETE", code: 400, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                            errorReport = error
                            completionHandler(nil,error)
                        }else{
                            let error = NSError.init(domain: "DELETE", code: 500, userInfo: [NSLocalizedDescriptionKey: json["errorMessage"].stringValue])
                            errorReport = error
                            completionHandler(nil,error)
                        }
                        var reportParam = param
                    }
                }else{
                    if let updateInfoText = response.response?.allHeaderFields["updateInfoText"] as? String {
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", updateInfoText, controller, "Update", true, completionHandler: {
                            })
                        }
                    }
                    completionHandler(json, nil)
                }
            case .failure(let error):
                if (error as NSError).code != -999{
                    if let controller = controller {
                        OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                    }
                    completionHandler(nil, error)
                }else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func upload(url: String, param: [String: Any], _ controller:UIViewController?, _ media: Any, completionHandler: @escaping (JSON?, Error?) -> ()) {
        var json: JSON!
        var headers:[String:String] = [:]
        //        headers["Myu-Auth-Token"] = UserManager.getAuthToken()
        headers["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Alamofire.request(url, method : .post, parameters : param,  encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                json = JSON(value)
                if json["statusCode"].stringValue != "2XX"{
                    if json["statusCode"].stringValue == "401" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 401)
                        completionHandler(nil,error)
                        //                        UserManager.logout(isDisable: false)
                    }else if json["statusCode"].stringValue == "404" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 404)
                        completionHandler(nil,error)
                    }else if json["statusCode"].stringValue == "426" {
                        let error = NSError.init(domain: json["errorMessage"].stringValue, code: 426)
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", json["updateInfoText"].stringValue, controller, "Update", false, completionHandler: {
                                //                                UIApplication.shared.openURL(URL.init(string: AppConstant.appStoreUrl)!)
                            })
                        }
                        completionHandler(nil,error)
                    }else{
                        if let controller = controller {
                            OtherHelper.simpleDialog("Error", json["errorMessage"].stringValue, controller)
                        }
                        if json["statusCode"].stringValue == "4XX"{
                            let error = NSError.init(domain: json["errorMessage"].stringValue, code: 400)
                            completionHandler(nil,error)
                        }else{
                            let error = NSError.init(domain: json["errorMessage"].stringValue, code: 500)
                            completionHandler(nil,error)
                        }
                    }
                }else{
                    if let updateInfoText = response.response?.allHeaderFields["updateInfoText"] as? String {
                        if let controller = controller{
                            OtherHelper.buttonDialog("new_version_available", updateInfoText, controller, "Update", true, completionHandler: {
                                //                                UIApplication.shared.openURL(URL.init(string: AppConstant.appStoreUrl)!)
                            })
                        }
                    }
                    completionHandler(json, nil)
                }
            case .failure(let error):
                if let controller = controller {
                    OtherHelper.simpleDialog("Network_Error", error.localizedDescription, controller)
                }
                completionHandler(nil, error)
            }
        }
    }
    
    static func stopAllSessions() {
        SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach { if $0.originalRequest?.url?.lastPathComponent == "typeahed" || $0.originalRequest?.url?.lastPathComponent == "myRelative" || $0.originalRequest?.url?.lastPathComponent == "search-media-inboards" { $0.cancel() }}
        }
    }
}
