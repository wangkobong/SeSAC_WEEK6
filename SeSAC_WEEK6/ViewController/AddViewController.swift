//
//  AddViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    static let identifier = "AddViewController"
    
    let localRealm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "일기 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonPressed))
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        
        let task = UserDiary(diaryTitle: titleTextField.text!, diaryContent: contentTextView.text!, writeDate: Date(), registerDate: Date())
        try! localRealm.write {
            localRealm.add(task)
        }
        
    }

}


