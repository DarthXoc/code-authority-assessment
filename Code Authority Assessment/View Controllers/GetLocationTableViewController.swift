//
//  GetLocationTableViewController.swift
//  Code Authority Assessment
//
//  Created by Jason Cox on 6/26/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

import MapKit
import UIKit

class GetLocationTableViewController: UITableViewController
{
    // MARK: - IBOutlets
    
    // Setup any needed IBOutlets
    @IBOutlet private var buttonFindLocation: UIButton!;
    @IBOutlet private var labelCityName: UILabel!;
    @IBOutlet private var textFieldLatitude: UITextField!;
    @IBOutlet private var textFieldLongitude: UITextField!;
    @IBOutlet private var mapView: MKMapView!;
    
    // MARK: - Classes
    
    // Setup any required classes
    private let alerts: Alerts = Alerts();
    private let validation: Validation = Validation();
    
    // MARK: - General Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        //
        mapView.layer.borderColor = UIColor.lightGray.cgColor;
        mapView.layer.borderWidth = 0.33;
        mapView.layer.cornerRadius = 8.0;
        
        // Update the view
        self.updateView();
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonFindLocation_Tap(sender: UIButton)
    {
        // Update the view
        self.updateView();
    }
    
    // MARK: - User Interface
    
    private func updateView()
    {
        // Check to see if textFieldLatitude or textFieldLongitude are nil
        // Note: In a production app I'd do a much better job of sanitizing user-entered data, such as validiting it through a regex... but for a demo that's just overkill. The code below should handle the basic ways you guys will probably try to crash the app.
        if (textFieldLatitude.text != "" && textFieldLongitude.text != "")
        {
            // Setup variables to hold the converted or sanitized degrees latitude and longitude
            var degreesDecimalLatitude: Double = Double.zero;
            var degreesDecimalLongitude: Double = Double.zero;
            
            // Check to see if the coordinates entered are Degrees/Minutes/Seconds or Coordinates
            if (textFieldLatitude.text!.contains("°") || textFieldLatitude.text!.contains("º"))
            {
                // Setup an array of allowed characters
                let arrayAllowedCharacters: [String.Element] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."];
                
                // Extract an array of numberic values from textFieldLatitude
                let arrayLatitude: [Substring] = textFieldLatitude.text!.split(whereSeparator: { !arrayAllowedCharacters.contains($0)  });
                
                // Convert from Degrees, Minutes, Seconds to Degrees Decimal
                var degrees: Double = Double(String(arrayLatitude[0])) ?? 0;
                degrees += ((Double(String(arrayLatitude[1])) ?? 0) / 60);
                degrees += ((Double(String(arrayLatitude[2])) ?? 0) / 3600);
                degrees = textFieldLatitude.text!.contains("S") ? -degrees : degrees;
                
                degreesDecimalLatitude = degrees;
            }
            else if (validation.sanitize(string: textFieldLatitude.text!, stringCharacters: "0123456789.-").count > 0)
            {
                degreesDecimalLatitude = Double(validation.sanitize(string: textFieldLatitude.text!, stringCharacters: "0123456789.-")) ?? Double.zero;
            }
            else
            {
                // Show an alert indicating that the provided latitude coordinate is invalid
                alerts.GetLocation_InvalidCoordinate(coordinateType: .Latitude, okAction: nil);
                
                degreesDecimalLatitude = 0;
            }
            
            // Check to see if the coordinates entered are Degrees/Minutes/Seconds or Coordinates
            if (textFieldLongitude.text!.contains("°") || textFieldLongitude.text!.contains("º"))
            {
                // Setup an array of allowed characters
                let arrayAllowedCharacters: [String.Element] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."];
                
                // Extract an array of numberic values from textFieldLongitude
                let arrayLongitude: [Substring] = textFieldLongitude.text!.split(whereSeparator: { !arrayAllowedCharacters.contains($0)  });
                
                // Convert from Degrees, Minutes, Seconds to Degrees Decimal
                var degrees: Double = Double(String(arrayLongitude[0])) ?? 0;
                degrees += ((Double(String(arrayLongitude[1])) ?? 0) / 60);
                degrees += ((Double(String(arrayLongitude[2])) ?? 0) / 3600);
                degrees = textFieldLongitude.text!.contains("W") ? -degrees : degrees;
                
                degreesDecimalLongitude = degrees;
            }
            else if (validation.sanitize(string: textFieldLongitude.text!, stringCharacters: "0123456789.-").count > 0)
            {
                degreesDecimalLongitude = Double(validation.sanitize(string: textFieldLongitude.text!, stringCharacters: "0123456789.-")) ?? Double.zero;
            }
            else
            {
                // Show an alert indicating that the provided longitude coordinate is invalid
                alerts.GetLocation_InvalidCoordinate(coordinateType: .Longitude, okAction: nil);
                
                degreesDecimalLongitude = 0;
            }
            
            // Extract the user's current location
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: degreesDecimalLatitude, longitude: degreesDecimalLongitude), completionHandler: { (placemark, error) in
                // Populate the form with location data
                self.labelCityName.text = placemark![0].locality ?? placemark![0].administrativeArea ?? "Unknown";
            });
            
            // Setup a new pin centered on the entered coordinates
            let pointAnnotation: MKPointAnnotation = MKPointAnnotation();
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: degreesDecimalLatitude, longitude: degreesDecimalLongitude);
            
            // Remove existing pins
            mapView.removeAnnotations(mapView.annotations);
            
            // Add a new pin to the mmap
            mapView.addAnnotation(pointAnnotation);
            
            // Zoom the map view to this region
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: degreesDecimalLatitude, longitude: degreesDecimalLongitude), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)), animated: true);
        }
        else
        {
            // SHow an alert indicating both sets of coordinates are invalid
            alerts.GetLocation_InvalidCoordinate(coordinateType: .Both, okAction: nil);
        }
    }
}
