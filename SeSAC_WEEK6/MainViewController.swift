//
//  ViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         ----> S-CoreDream-2ExtraLight
         ----> S-CoreDream-5Medium
         ----> S-CoreDream-9Black
         welcomeLabel.text = LocalizableStrings.welcome_text.localized
         
         //11 ~ 20 폰트사이즈가 적당함
         welcomeLabel.font = UIFont().mainBlack
         
         //
         backupLabel.text = LocalizableStrings.data_backup.localizedSetting

         */
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed))
 
        self.title = "HOME"

    }

    @objc func addButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: AddViewController.identifier) as! AddViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
}

