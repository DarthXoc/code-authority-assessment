//
//  Alerts.swift
//  Code Authority Assessment
//
//  Created by Jason Cox on 6/26/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

import UIKit

class Alerts: NSObject
{
    // MARK: - Enumerations
    
    // Define coordinate types
    internal enum CoordinateType: String
    {
        case Both;
        case Latitude;
        case Longitude;
    }
    
    // MARK: - Variables
    
    // Setup any required variables
    var alertController: UIAlertController = UIAlertController();
    
    // MARK: - General Functions
    
    // Function to create a generic alert with an OK button
    private func createGenericAlert(stringTitle: String?, stringMessage: String?, stringButtonOk: String, okAction: (() -> Void)?)
    {
        // Setup the UIAlertController
        self.alertController = UIAlertController(title: stringTitle,
                                                 message: stringMessage,
                                                 preferredStyle: .alert);
        
        // Add an action to the UIAlertController
        self.alertController.addAction(UIAlertAction(title: stringButtonOk, style: .default, handler: { (alertAction) in
            // Execute the action
            okAction?();
        }));
        
        // Present the UIAlertController
        self.presentAlert(alertController: self.alertController);
    }
    
    // Function to present the UIAlertController on the top-most UIViewController
    private func presentAlert(alertController: UIAlertController)
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        
        // Retreive the top-most view controller
        let viewController: UIViewController = appDelegate.getTopMostViewController(viewController: UIApplication.shared.keyWindow!.rootViewController!);
        
        // Present the UIAlertController
        viewController.present(alertController, animated: true, completion: nil);
    }
    
    // MARK: - Detect Location
    
    internal func DetectLocation_LocationServicesDenied(okAction: (() -> Void)?)
    {
        // Create a generic alert
        self.createGenericAlert(stringTitle: "Location Access Denied",
                                stringMessage: "In order for this demo to function you must allow this app access to your location data.\r" +
                                    "\r" +
                                    "Please adjust this setting in Settings under Privacy > Location Services.",
                                stringButtonOk: "OK",
                                okAction: { okAction?() });
    }
    
    internal func DetectLocation_LocationServicesNoteEnabled(okAction: (() -> Void)?)
    {
        // Create a generic alert
        self.createGenericAlert(stringTitle: "Location Services Disabled",
                                stringMessage: "Location Services are disabled on your device. Please enable Location Services in order to continue.",
                                stringButtonOk: "OK",
                                okAction: { okAction?() });
    }
    
    // MARK: - Get Location
    
    internal func GetLocation_InvalidCoordinate(coordinateType: CoordinateType, okAction: (() -> Void)?)
    {
        // Create a generic alert
        self.createGenericAlert(stringTitle: "Invalid " + (coordinateType == .Both ? "Coordinates" : "Coordinate"),
                                stringMessage: (coordinateType == .Both ? "The entered coordinates are invalid.\r" : "The entered " + coordinateType.rawValue.lowercased() + " coordinate is invalid.\r") +
                                    "\r" +
                                    "Please enter your coordinates in one of the following formats:\r" +
                                    "33°06'14.4\"N\r" +
                                    "33.103997\r",
                                stringButtonOk: "OK",
                                okAction: { okAction?() });
    }
}
