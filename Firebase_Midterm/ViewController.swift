//
//  ViewController.swift
//  Firebase_Midterm
//
//  Created by ChloeHuHu on 2020/11/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import EasyRefresher

class ViewController: UIViewController {
    
    var db:Firestore!
    
    let myButton = UIButton()
    
    var article: [String] = []
    var author: [String] = []
    var category: [String] = []
    var createdTime: [Timestamp] = []
    var content: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addPostButton: UIButton!{
        didSet{
            addPostButton.layer.cornerRadius = 25
            addPostButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableView.automaticDimension
        tableViewConfig()
        getPost()
        listenPost()
        refreshHeader()
    }
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueAddPost", sender:UIButton.self)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC = segue.destination as? SecondViewController
//    }
    
    func refreshHeader() {
        tableView.refresh.header.addRefreshClosure {
            self.getPost()
            self.tableView.refresh.header.endRefreshing()
        }
    }
    
    //MARK:-獲得現有Article
    func getPost() {
        let articles = Firestore.firestore().collection("articles")
        articles.order(by: "createdTime",descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("現有的資料 \(document.documentID) => \(document.data())")
                    self.article.append(document.data()["title"] as! String)
                    self.category.append(document.data()["category"] as! String)
                    self.content.append(document.data()["content"] as! String)

//                    self.createdTime.append(document.data()["createdTime"] as! Timestamp)
//                    self.author.append(document.data().["author"] as! String)

                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    //MARK:-監聽Article
    func listenPost() {
        let articles = Firestore.firestore().collection("articles")
        articles.addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            //監聽新增項目
            documents.documentChanges.forEach{ diff in
                if (diff.type == .added) {
                    print("新增: \(diff.document.data())")
                    self.tableView.reloadData()
                }
                if (diff.type == .modified) {
                    print("修改: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("刪除: \(diff.document.data())")
                }
            }
        }
        
    }
}

//MARK:-
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = article[indexPath.row]
        cell.categoryLabel.text = category[indexPath.row]
        
        if cell.categoryLabel.text == "Beauty"
        {
            cell.categoryLabel.textColor = UIColor.blue
        } else if cell.categoryLabel.text == "Gossiping" {
            cell.categoryLabel.textColor = UIColor.systemGreen
        } else if cell.categoryLabel.text == "IU" {
            cell.categoryLabel.textColor = UIColor.purple
        } else {cell.categoryLabel.textColor = UIColor.black
            
        }
//
        cell.contentLabel.text = content[indexPath.row]
//        cell.timeLabel.text = createdTime[indexPath.row]
//        cell.authorLabel.text = author[indexPath.row]

        return cell
    }
    
    
}

