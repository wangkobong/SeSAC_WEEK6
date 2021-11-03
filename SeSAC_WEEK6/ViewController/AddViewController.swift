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
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    
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
            saveImageToDocumentDirectory(imageName: "\(task._id).png", image: contentImageView.image!)
        }
        
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        
    
        //1. 이미지 저장할 경로 설정: 도큐먼트 폴더, FileManager
        // Desktop/jack/ios/folder
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축 (image.pngData())
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            print("이미지 압축 실패")
            return }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
        }
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 실패")
        }
    }

}


