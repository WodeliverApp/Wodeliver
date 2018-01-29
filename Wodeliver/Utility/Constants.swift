//
//  Constants.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/12/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
     static let redBackgroundColor = UIColor(red: 226.0/255.0, green: 36.0/255.0, blue: 44.0/255.0, alpha: 1.0)
    static let viewBackgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    static let fullViewBackgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    
}


struct Path {
    static let baseURL : String = "http://18.217.139.93:8082"
    static let loginURL : String = "\(baseURL)/login"
    static let signUpURL : String = "\(baseURL)/user"
    static let categoryURL : String = "\(baseURL)/category"
    static let storeListURL : String = "\(baseURL)/store/category/location/?"
    static let itemListURL : String = "\(baseURL)/menu/itemCategory/?"
}

struct AlertMessages {
    //Login
    static let userNameValidation = "Please enter your name."
    static let userLastValidation = "Please enter your last name."
    static let userSurNameValidation = "Please enter your surname."
    static let userDOBValidation = "Please enter your DOB."
    static let userUniversityNameValidation = "Please select a university."
    static let userCampusNameValidation = "Please select a campus."
    static let userUploadIdValidation = "Please upload your id."
    static let userStudentIdValidation = "Please upload your student id."
    static let userEmailValidation = "Please enter a valid email address."
    static let userEmailEmpety = "Please enter email address."
    static let userTypeSelection = "Please select user role."
    static let passwordValidation =  "Please enter a valid password."
    static let passwordEmpety =  "Please enter a password."
    static let passwordLentValidation =  "The password must be atleast 8 characters long."
    static let repeatPasswordEmpety =  "Please confirm password."
    static let repeatPasswordValidation =  "Password and Confirm password are not matched"
    static let selecteUniversityFirstMessage =  "Please select university first."
    static let campusNotavailableForSelectedUniversityMessage =  "Campus is not available for selected university."
    static let userReleasionShipValidation = "Please enter relationship."
    
    static let seesionInvalidForLogoutMessage = "Your session is expired. Please login again."
    //Forgot Password
    static let forgotPassword = "Forgot Password?\nPlease enter your email address"
    
    static let imageNotSelectedFromLibrary = "Please select image."
    
    // Server issue
    static let serverError = "Server error.Please try again."
    static let InvalidResponsegMessage = "Invalid response.Please Try again"
    static let InvalidRequestMessage = "Invalid request. Try again"
    static let logoutAlertMessage = "Are you really want to logout?"
    
    // Request View
    static let NoDateAndTimeAlertMessage = "Please select atleast one time slot."
    static let NoDateAlertMessage = "Please select date"
    static let NoTimeAlertMessage = "Please select time"
    
    static let ErrorTimeForCurrentDateAlertMessage = "Please select valid date and time."
    
    //Feedback
    static let feedbackValidationMessage = "Please enter your feedback."
    
    // Filter
    static let moveInValidationMessage = "Please select move in date."
    static let moveOutSelectionValidationMessage = "Please select move in date first."
    static let moveOutValidationMessage = "Please select move out date first."
    static let moveOutDateValidationMessage = "Please select move out date."
    static let maximumBedRoomValidationMessage = "Maximum bedroom should be greater than minimum bedroom"
    static let minimumBedRoomValidationMessage = "Minimum bedroom should be less than maximum bedroom"
    static let minimumBedRoomForNumberOfPeopleValidationMessage = "Minimum bedroom should be greater than or equal to number of searching people"
    static let maximumBedRoomForNumberOfPeopleValidationMessage = "Maximum bedroom should be greater than number of seraching people"
    static let peopleValidationMessage = "Please select number of people"
    
    // Payment info
    static let userCardHolderNameValidation = "Please enter your name."
    static let userCardNumberValidation = "Please enter card number."
    static let userCardTypeValidation = "Please select card type."
    static let userCardExpiryDateValidation = "Please enter card expiry date."
    static let userCardCSVValidation = "Please enter card csv."
    static let userCardExpiryValidValidation = "Please select valid date."
    
    //InboxDetail
    
    static let textViewPlaceholderText = "  Write an answer here..."
    
    static let ComingSoonMessage = "Coming soon.."
    
}

struct AppConstant {
    static let isCurrentLocationSaved = "_isCurrentLocationSaved"
    static let currentUserLocation = "_userLocation"
}

struct GooglePlace {
    static let googlePlaceKey = "AIzaSyCl4DiAtMzojEJPBMxDoknyveoez1lOt10"
    static let googleAPIKey = "AIzaSyDdRtWVaZ7JWm-uaLRronAx036agZx07dU"
}
