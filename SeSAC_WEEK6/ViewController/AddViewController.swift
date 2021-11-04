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
    let datePicker = UIDatePicker()
    let imagepickerController = UIImagePickerController()
    var fCurTextfieldBottom: CGFloat = 0.0
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var regDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        regDateTextField.delegate = self
        contentTextView.delegate = self
        self.imagepickerController.delegate = self
        
        titleTextField.returnKeyType = .done
        regDateTextField.returnKeyType = .done
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
        
        let task = UserDiary(diaryTitle: titleTextField.text!, diaryContent: contentTextView.text!, writeDate: Date(), registerDate: Date())
        try! localRealm.write {
            localRealm.add(task)
            saveImageToDocumentDirectory(imageName: "\(task._id).png", image: contentImageView.image!)
        }
        self.dismiss(animated: true, completion: nil)
        
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
    
    func createDatePickerView(){
        //toolbar 만들기, done 버튼이 들어갈 곳
        let toolbar = UIToolbar()
        toolbar.sizeToFit() //view 스크린에 딱 맞게 사이즈 조정
        
        //버튼 만들기
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target : nil, action: #selector(donePressed))
        //action 자리에는 이후에 실행될 함수가 들어간다?
        
        //버튼 툴바에 할당
        toolbar.setItems([doneButton], animated: true)
        
        //toolbar를 키보드 대신 할당?
        regDateTextField.inputAccessoryView = toolbar
        
        //assign datepicker to the textfield, 텍스트 필드에 datepicker 할당
        regDateTextField.inputView = datePicker
        
        //datePicker 형식 바꾸기
        datePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        regDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
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
