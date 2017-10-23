//
//  ViewController.swift
//  hello world
//
//  Created by Tom Lai on 10/23/17.
//  Copyright © 2017 Tom Lai. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let sp = SignalProducer<Any, NoError> { (sink: Signal.Observer, disposable: Disposable) in
            sink.send("Hello world")
            sink.sendCompleted()
        }

        sp.startWithValues { print($0) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

