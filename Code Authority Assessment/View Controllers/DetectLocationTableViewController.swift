//
//  DetectLocationTableViewController.swift
//  Code Authority Assessment
//
//  Created by Jason Cox on 6/26/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

import CoreLocation;
import UIKit

class DetectLocationTableViewController: UITableViewController, CLLocationManagerDelegate
{
    // MARK: - IBOutlets
    
    // Setup any needed IBOutlets
    @IBOutlet private var barButtonRefresh: UIBarButtonItem!;
    @IBOutlet private var labelAddress: UILabel!;
    @IBOutlet private var labelCity: UILabel!;
    @IBOutlet private var labelCountry: UILabel!;
    @IBOutlet private var labelGalaxy: UILabel!;
    @IBOutlet private var labelLatitude: UILabel!;
    @IBOutlet private var labelLongitude: UILabel!;
    @IBOutlet private var labelPlanet: UILabel!;
    @IBOutlet private var labelState: UILabel!;
    @IBOutlet private var labelSystem: UILabel!;
    
    // MARK: - Classes
    
    // Setup any required classes
    private let alerts: Alerts = Alerts();
    
    // MARK: - Variables
    
    // Setup any required variables
    private let locationManager: CLLocationManager = CLLocationManager();
    
    // MARK: - General Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        // Configure the location manager
        locationManager.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // Update the view
        self.updateView();
    }
    
    // MARK: - Delegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        // Check to see if the user has just authorized this app to use location services
        // This can be triggered by both the in-app popup or by the user adjusting permissions in Settings when this view is visible
        if (status == .authorizedWhenInUse)
        {
            // Update the view
            self.updateView();
        }
        else
        {
            // Show an alert indicating that Location Services access is denied
            alerts.DetectLocation_LocationServicesDenied(okAction: nil);
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        // Indicate that the location data is being updated
        self.labelGalaxy.text = "Unknown";
        self.labelSystem.text = "Unknown";
        self.labelPlanet.text = "Unknown";
        self.labelLatitude.text = "Unknown";
        self.labelLongitude.text = "Unknown";
        self.labelCountry.text = "Unknown";
        self.labelState.text = "Unknown";
        self.labelCity.text = "Unknown";
        self.labelAddress.text = "Unknown";
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // Extract the user's current location
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: { (placemark, error) in
            // Populate the form with location data
            self.labelGalaxy.text = "Milky Way";
            self.labelSystem.text = "Sol";
            self.labelPlanet.text = "Sol III (Earth)";
            self.labelLatitude.text = String(format: "%f", (placemark![0].location?.coordinate.latitude)!);
            self.labelLongitude.text = String(format: "%f", (placemark![0].location?.coordinate.longitude)!);
            self.labelCountry.text = placemark![0].country;
            self.labelState.text = placemark![0].administrativeArea;
            self.labelCity.text = placemark![0].locality;
            self.labelAddress.text = placemark![0].name;
        });
    }
    
    // MARK: - IBActions
    
    @IBAction private func barButtonRefresh_Tap(sender: UIBarButtonItem)
    {
        // Update the view
        self.updateView();
    }
    
    // MARK: - User Interface
    
    private func updateView()
    {
        // Check to see if Location Services are enabled
        if (CLLocationManager.locationServicesEnabled())
        {
            // Check to see if this app is authorized to access location services
            if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
            {
                // Indicate that the location data is being updated
                self.labelGalaxy.text = "Updating...";
                self.labelSystem.text = "Updating...";
                self.labelPlanet.text = "Updating...";
                self.labelLatitude.text = "Updating...";
                self.labelLongitude.text = "Updating...";
                self.labelCountry.text = "Updating...";
                self.labelState.text = "Updating...";
                self.labelCity.text = "Updating...";
                self.labelAddress.text = "Updating...";
                
                // Request that location data be updated
                self.locationManager.requestLocation();
            }
            else if (CLLocationManager.authorizationStatus() == .notDetermined)
            {
                // Request that the user authorize this app to use location services
                locationManager.requestWhenInUseAuthorization();
            }
            else
            {
                // Show an alert indicating that Location Services access is denied
                alerts.DetectLocation_LocationServicesDenied(okAction: nil);
            }
        }
        else
        {
            // Show an alert indicating that Location Services is disabled
            alerts.DetectLocation_LocationServicesNoteEnabled(okAction: nil);
        }
    }
}
