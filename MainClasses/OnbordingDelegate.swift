//
//  OnbordingDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
protocol OnboardingDelegate {
    func startOnboarding(title: String, subtitle: String, buttonTitle: String, buttonTitle1: String,imgUrl : String,backgroundColors : String,textColor: String, completion: @escaping (Bool, String?) -> Void)
}
