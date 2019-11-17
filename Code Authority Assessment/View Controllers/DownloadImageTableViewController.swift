//
//  DownloadImageTableViewController.swift
//  Code Authority Assessment
//
//  Created by Jason Cox on 6/26/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

import UIKit

class DownloadImageTableViewController: UITableViewController
{
    // MARK: - IBOutlets
    
    // Setup any needed IBOutlets
    @IBOutlet private var buttonDownloadImage: UIButton!;
    @IBOutlet private var textFieldUrl: UITextField!;
    @IBOutlet private var viewError: UIView!;
    @IBOutlet private var webView: UIWebView!;
    
    // MARK: - General Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        // Update the view
        self.updateView();
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonDownloadImage_Tap(sender: UIButton)
    {
        // Update the view
        self.updateView();
    }
    
    // MARK: - User Interface
    
    private func updateView()
    {
        var boolLoadRequest: Bool = false;
        
        // Setup an array of supported image formats
        let arraySupportedImageFormats: [String] = [".gif", ".jpg", ".jpeg", ".png"];
        
        // Retreive the index of the last period character in the URL
        let indexLastIndexOfPeriod: String.Index? = textFieldUrl.text?.lastIndex(of: ".");
        
        // Check to make sure that indexLastIndexOfPeriod is not nil
        if (indexLastIndexOfPeriod != nil)
        {
            // Substring all characters that occur after the last period
            let stringAfterLastDot: Substring = textFieldUrl.text?.suffix(from: indexLastIndexOfPeriod!) ?? "";
            
            // Check to see if the substring is found in the array of supported image formats
            if (arraySupportedImageFormats.contains(String(stringAfterLastDot)))
            {
                // The substring was found in the array of supported image formats; okay to procede
                boolLoadRequest = true;
            }
        }
        
        // Toggle the error view and the web view's visibility
        viewError.isHidden = boolLoadRequest;
        webView.isHidden = !boolLoadRequest;
        
        // Check to see if the webview should execute the request
        if (boolLoadRequest)
        {
            // Execute the request
            webView.loadRequest(URLRequest(url: URL(string: textFieldUrl.text!)!));
        }
    }
}
