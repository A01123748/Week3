//
//  DetailViewController.swift
//  Week3
//
//  Created by Eliseo Fuentes on 7/16/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tittle: UITextField!
    @IBOutlet weak var authors: UITextView!
    @IBOutlet weak var portada: UIImageView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.tittle {
                label.text = detail.valueForKey("title")!.description
            }
            if let label = self.authors {
                label.text = detail.valueForKey("authors")!.description
            }
            if let label = self.portada {
                let url = detail.valueForKey("cover")!.description
                if url != "img1.jpg"{
                    self.portada.image = UIImage(data: NSData(contentsOfURL: NSURL(string:url)!)!)
                }
                else{
                    self.portada.image = UIImage(named: url)
                }
            }
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tittle.text = "Hola mundo"
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

