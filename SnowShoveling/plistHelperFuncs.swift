//
//  plistHelperFuncs.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 2/24/19.
//  Copyright © 2019 Sheen Patel. All rights reserved.
//
//  https://stackoverflow.com/questions/47419327/swift-4-adding-dictionaries-to-plist
//

import Foundation

//get the path.
var plistURL:URL {
    let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    return documentDirectoryURL.appendingPathComponent("globals.plist")
}


func savePropertyList(_ plist: Any) throws {
    let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    try plistData.write(to: plistURL)
}

func loadPropertyList() throws -> [String:Any] {
    let data = try Data(contentsOf: plistURL)
    guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String:Any] else {
        return [String:String]()
    }
    return plist
}

func writeToStorage(key:String, value:Any) {
    do {
        var dictionary = try loadPropertyList()
        dictionary[key] = value
        //dictionary.updateValue(value, forKey: key)
        try savePropertyList(dictionary)
    } catch {
        print(error)
    }
}

func loadFromStorage(key:String) -> Any? {
    do {
        let dictionary = try loadPropertyList()
        return dictionary[key]
    } catch {
        print(error)
        return nil
    }
}
