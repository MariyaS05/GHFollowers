//
//  Constanse.swift
//  GHFollowers
//
//  Created by Мария  on 30.12.22.
//

import Foundation
import UIKit
enum SFSymbols {
    static let location = UIImage(systemName:"mappin.and.ellipse")
    static let repos  =  UIImage(systemName:"folder")
    static let gists = UIImage(systemName:"text.alignleft")
    static let followers = UIImage(systemName:"heart")
    static let following  = UIImage(systemName:"person.2")
}
enum Images {
    static let ghLogo = UIImage(named: "gh-logo")
    static let placeholder =  UIImage(named: "avatar-placeholder")
    static let emptyStateLogo =  UIImage(named: "empty-state-logo")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height =  UIScreen.main.bounds.size.height
    static let maxLength =  max(ScreenSize.width, ScreenSize.height)
    static let mimLength = min(ScreenSize.width, ScreenSize.height)
}

enum DevicesType {
    static let idiom =  UIDevice.current.userInterfaceIdiom
    static let nativeScale  =  UIScreen.main.nativeScale
    static let scale  =  UIScreen.main.scale
    
    static let isiPhoneSE =  idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standatr =  idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed =  idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandart =  idiom == .phone && ScreenSize.maxLength ==  736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX =  idiom == .phone  && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXrAnd11 =  idiom == .phone  && ScreenSize.maxLength == 896.0
    static let isiPhone11Pro = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhone11ProMax = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPhone12And12ProAnd13And14 = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12MiniAnd13Mini = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhone14Pro = idiom == .phone && ScreenSize.maxLength == 852.0
    static let isiPhone14ProMax = idiom == .phone && ScreenSize.maxLength == 932.0
    static let isiPhone14Plus = idiom == .phone && ScreenSize.maxLength == 926.0
    
    static func isiPhoneXAspectRatio()-> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXrAnd11
    }
}
