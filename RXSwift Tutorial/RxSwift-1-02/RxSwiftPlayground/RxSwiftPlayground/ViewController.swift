//
//  ViewController.swift
//  RxSwiftPlayground
//
//  Created by Tom Lai on 6/17/18.
//  Copyright © 2018 Lai. All rights reserved.
//

import UIKit
import RxSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _ = Observable.of("Hello RxSwift")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

