//
//  SecondViewController.swift
//  Firebase_Midterm
//
//  Created by ChloeHuHu on 2020/11/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class SecondViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet {
            contentTextView.text = "input content"
            contentTextView.textColor = UIColor.lightGray
            //            textViewDidBeginEditing()
            //            textViewDidEndEditing()
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        addData()
        titleTextField.text = ""
        categoryTextField.text = ""
        contentTextView.text = ""
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
                if contentTextView.text.isEmpty{
                    contentTextView.text = "input content"
                    contentTextView.textColor = UIColor.lightGray
                }
    }
   
    func addData() {
        
        guard let title = titleTextField.text,
              let category = categoryTextField.text,
              let content = contentTextView.text
        
        else { return }
        
        //設定路徑
        let articles = Firestore.firestore().collection("articles")
        let document = articles.document()
        
        //設定data 內容
        let data : [String: Any] = [
            "author": [
                "email": "chloe@gmail.com",
                "id": "chloehuhu0924",
                "name": "ChloeHuHu"
            ],
            
            "title": title,
            "content": content,
            "createdTime": FirebaseFirestore.FieldValue.serverTimestamp(),
            "category": category,
            "id": document.documentID
        ]
        //setData 到firebase
        document.setData(data)
        
    }
}
