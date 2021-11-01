//
//  AddViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit

class AddViewController: UIViewController {
    
    static let identifier = "AddViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonPressed))
        self.title = "일기 작성"
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        print("save")
    }

}


