//
//  Validation.swift
//  Code Authority Assessment
//
//  Created by Jason Cox on 6/26/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

import UIKit

class Validation: NSObject
{
    // Function to sanitize a string by removing all characters except the specified characters
    internal func sanitize(string: String?, stringCharacters: String) -> String
    {
        // Filter out all characters except the specified characters
        
        return string?.filter(stringCharacters.contains) ?? "";
    }
}
