//
//  DetailViewController.swift
//  CampgroundManager
//
//  Created by Aaron Douglas on 8/17/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
                            
    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let siteNumber = detail.valueForKey("siteNumber")!.description
                label.text = "Campsite number: \(siteNumber)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

