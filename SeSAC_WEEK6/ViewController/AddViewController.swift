//
//  AddViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    static let identifier = "AddViewController"
    
    let localRealm = try! Realm()
    let imagepickerController = UIImagePickerController()
    var fCurTextfieldBottom: CGFloat = 0.0
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        self.imagepickerController.delegate = self
        
        titleTextField.returnKeyType = .done
        contentTextView.returnKeyType = .done
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        title = "일기 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonPressed))
        
        enrollAlertEvent()
        addGestureRecognizer()
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        hideKeyboard()
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        let buttonDate = dateButton.currentTitle!
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
//        let date = dateButton.currentTitle!
//        let value = format.date(from: buttonDate)
//
        // let value = DateFormatter.customFormat.date(from: date)
        guard let date = dateButton.currentTitle, let value = format.date(from: date) else { return }
        
        let task = UserDiary(diaryTitle: titleTextField.text!, diaryContent: contentTextView.text!, writeDate: value, registerDate: Date())
        try! localRealm.write {
            localRealm.add(task)
            saveImageToDocumentDirectory(imageName: "\(task._id).png", image: contentImageView.image!)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
        
        // 스토리보드 씬 + 클래스 -> 화면 전환 코드
//        let contentView = DatePickerViewController()
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController else {
            
            print("DatePickerViewController에 오류가 있음")
            return
        }
        contentView.view.backgroundColor = .green
//        contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        contentView.preferredContentSize.height = 200
        alert.setValue(contentView, forKey: "contentViewController")
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            //확인 버튼 눌렀을 때 버튼의 타이틀 변경
            self.dateButton.setTitle(value, for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fCurTextfieldBottom = textField.frame.origin.y + textField.frame.height
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        fCurTextfieldBottom = textView.frame.origin.y + textView.frame.height
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if fCurTextfieldBottom <= self.view.frame.height - keyboardSize.height {
                    return
                }
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
    
    func enrollAlertEvent() {
        let photoLibraryAlertAction = UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openAlbum()
        }
        
        let camearAlertAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cacelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlertAction)
        self.alertController.addAction(camearAlertAction)
        self.alertController.addAction(cacelAlertAction)
        guard let alertControllerPopoverPresentationController = alertController.popoverPresentationController else { return }
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    func openAlbum() {
        self.imagepickerController.sourceType = .photoLibrary
        present(self.imagepickerController, animated: false, completion: nil)
    }
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.imagepickerController.sourceType = .camera
            present(self.imagepickerController, animated: false, completion: nil)
        } else {
            print("카메라를 사용할 수 없습니다")
        }
    }
    
    func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedUIImageView(_:)))
        self.contentImageView.addGestureRecognizer(tapGestureRecognizer)
        self.contentImageView.isUserInteractionEnabled = true
    }
    
    @objc func tappedUIImageView(_ gesture: UITapGestureRecognizer) {
        self.present(alertController, animated: true, completion: nil)
    }

}

extension AddViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.view
        popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.minY, width: 0, height: 0)
        popoverPresentationController.permittedArrowDirections = []
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            contentImageView.image = image
        } else {
            print("didFinishPickingMediaWithInfo에서 이미지 가져오기 실패")
        }
        dismiss(animated: true, completion: nil)
    }
}
