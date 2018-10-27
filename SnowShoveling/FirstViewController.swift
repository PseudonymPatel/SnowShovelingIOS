//
//  FirstViewController.swift
//  SnowShoveling
//
//  Created by Sheen Patel on 9/30/18.
//  Copyright © 2018 Sheen Patel. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let jsonstuff = """
                        {
                            "userID": 00000,
                            "ratingAvg": 3.2,
                            "ratings": [
                                {
                                    "title": "Example Title",
                                    "ratingNum": 1,
                                    "description": "Example Description"
                                },
                                {
                                    "title": "Example Title 2",
                                    "ratingNum": "2",
                                    "description": "Example Description 2"
                                }
                            ]
                        }
                        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedExample = try? decoder.decode(Rating.self, from: jsonstuff)
        print(decodedExample)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

