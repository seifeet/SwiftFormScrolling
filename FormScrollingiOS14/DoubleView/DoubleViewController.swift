//
//  DoubleViewController.swift
//  FormScrollingiOS14
//
//  Created by AT on 1/10/21.
//

import UIKit

final class DoubleViewController: BottomSheetContainerViewController
<ContentViewController, ContainerViewController> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do something
    }
    
}

class ContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
    }
}

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
    }

}
