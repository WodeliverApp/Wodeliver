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
    static let baseURL : String = "http://18.217.139.93:8082/"
    static let iosBaseURL : String = "http://18.217.139.93:8082/ios/"
    static let userURL : String = "\(baseURL)user"
    static let loginURL : String = "\(baseURL)login"
    static let signUpURL : String = "\(baseURL)user"
    static let categoryURL : String = "\(baseURL)category"
    static let storeListURL : String = "\(iosBaseURL)store/category/location/?"
    static let itemListURL : String = "\(iosBaseURL)menu/itemCategory/?"
    static let hotspotListURL : String = "\(baseURL)hotspot?storeId="
    static let searchURL : String = "\(baseURL)searchlist"
    static let forgotPasswordURL = "\(userURL)forgotPassword"
    static let changePasswordURL = "\(userURL)changePassword"
    static let storeMenuItem = "\(iosBaseURL)menu/?"
    static let storeAddItem = "\(baseURL)menu"
    static let storeCurrentOrder = "\(baseURL)order/storeId/current?storeId="
    static let storeHistorytOrder = "\(baseURL)order/storeId/completed?storeId="
    static let deleteItem = "\(baseURL)menu/delete?itemId="
    static let addHotSpotItem = "\(baseURL)hotspot"
    static let addBannner = "\(baseURL)banner"
    static let commentList = "\(baseURL)comment/?entity="
    static let menuListUrl : String = "\(baseURL)menu/itemCategory/?"
    static let getTimeSlot : String = "\(baseURL)getEmptySlotList?"
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
    
    // Store: Item
    static let itemValidation = "Please Enter Item Name."
    static let itemPriceValidation = "Please Enter Price."
    static let itemCatValidation = "Please Eelect Category."
    static let itemDescValidation = "Please Enter Description."
    static let itemImgValidation = "Please Select Item Image."
    
    // Store: Banner
    static let startDateValidation = "Please Select Start Date."
    static let endDateValidation = "Please Select End Date."
    static let startTimeValidation = "Please Select Start Time."
    static let endTimeValidation = "Please Select End Time."
    static let locationValidation = "Please Select Banner Location"
    static let hotspotImgValidation = "Please Select Banner Image."
    
    // Store: Profile
    static let storeCategory = "Please Select Category."
    static let storeProfileImage = "Please Select Image."
    static let storeName = "Please Enter Store Name."
    static let storeAddress = "Please Enter Store Address."
    static let storeCity = "Please Enter Store City."
    static let storeCountry = "Please Enter Store Country."
    static let storePhone = "Please Enter Store Phone Number."
    static let storeDescription = "Please Enter Store Description."
}

struct AppConstant {
    static let isCurrentLocationSaved = "_isCurrentLocationSaved"
    static let currentUserLocation = "_userLocation"
}

struct GooglePlace {
    static let googlePlaceKey = "AIzaSyCl4DiAtMzojEJPBMxDoknyveoez1lOt10"
    static let googleAPIKey = "AIzaSyDdRtWVaZ7JWm-uaLRronAx036agZx07dU"
}

struct HockeyKeys {
    static let appId = "9b325bb316c2440a8c1de3a4e6da73ab"
    static let secret = "21fc1ba22633acdb6def9d05f009556d"
}
