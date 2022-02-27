//
//  TopicTableViewController.swift
//  testmaps
//
//  Created by Makino Ruki on 1/23/22.
//

import UIKit

class TopicTableViewController : UITableViewController {
    
    var listOfTopics = [Topic]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    var modified = false
    func setTopics(topics:[Topic]) {
        self.listOfTopics = topics
       // self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
//        print("inside=")
//        print(listOfTopics.count)
//        print(listOfTopics[0])
//        print(listOfTopics[0].title)
        return listOfTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let topic = listOfTopics[indexPath.row]
            
            cell.textLabel?.text = topic.title
            
        return cell
    }
    
    func buildMessage(topic: Topic) -> String {
        var msg: String = topic.title + "\n\n"
        msg += topic.content + "\n"
        let replies: [String] = topic.replies
        for reply in replies {
            msg += "\n" + "==================\n\n" + reply
        }
        msg += "\n"
        return msg
    }
    
    func buildBlock() -> String {
        var blk:String = ""
        for i in (1...20) {
            blk += "\n"
        }
        return blk
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
//
//        //getting the text of that cell
//        let currentItem = currentCell.textLabel!.text
        let topic = listOfTopics[indexPath!.row]
//        if self.modified {
//            let topicId = topic.topicId
//            let newTopic = Topic(topicId: topicId, title: "", content: "", latitude: 0.0, longitude: 0.0)
//            newTopic.getTopic { [self, indexPath] result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let curTopic):
//                    self.listOfTopics[indexPath!.row] = curTopic
//                    //print("status=\(status)")
//                }
//            }
//            topic = listOfTopics[indexPath!.row]
//        }
        
        let alert = UIAlertController(title: "Nearby Topics", message: buildBlock(), preferredStyle: .alert)

        // (TODO:ruki) Add text view for topics
        let textView = UITextView(frame: CGRect(x: 25, y: 50, width: 220, height: 320))
        textView.backgroundColor = UIColor.white
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.text = buildMessage(topic: topic)
        alert.view.addSubview(textView)

        alert.view.frame = CGRect(x: 50, y: 50, width: 500, height: 500)

        alert.addTextField { field in
            field.placeholder = "Reply"
            field.returnKeyType = .next
            field.keyboardType = .default
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, topic, indexPath] _ in
            guard let fields = alert.textFields, fields.count == 1 else {
                return
            }
            let replies: String = fields[0].text!
            let replyRequest = Reply(topicId:topic.topicId, content:replies)
            replyRequest.postReply { [self, indexPath] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let status):
                    let topicId = topic.topicId
                    let newTopic = Topic(topicId: topicId, title: "", content: "", latitude: 0.0, longitude: 0.0)
                    newTopic.getTopic { [self, indexPath] result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let curTopic):
                            self.listOfTopics[indexPath!.row] = curTopic
                            //print("status=\(status)")
                        }
                    }
                    print("status=\(status)")
                }
            }
        }))

        present(alert, animated: true)

        
        //        let defaultAction = UIAlertAction(title: "Close Alert", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//
//        presentViewController(alertController, animated: true, completion: nil)
    }
}
