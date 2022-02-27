//
//  FunTableViewController.swift
//  testmaps
//
//  Created by Makino Ruki on 2/12/22.
//

import UIKit
import GoogleMaps

class FunTableViewController : UITableViewController {
    
    var listOfFuns = [Fun]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var currentLatitude:CLLocationDegrees=0.0
    var currentLongitude:CLLocationDegrees=0.0
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    var modified = false
    func setFuns(funs:[Fun], currentLatitude:CLLocationDegrees, currentLongitude:CLLocationDegrees) {
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.listOfFuns = funs
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
        return listOfFuns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let fun = listOfFuns[indexPath.row]
            
            cell.textLabel?.text = fun.name
            
        return cell
    }
    
    func buildMessage(fun: Fun) -> String {
        var msg: String = fun.name + "\n\n"
        msg += fun.description + "\n"
        msg += "\n"
        return msg
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
//
//        //getting the text of that cell
//        let currentItem = currentCell.textLabel!.text
        let fun = listOfFuns[indexPath!.row]
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
        
        let alert = UIAlertController(title: "Nearby Funs", message: buildMessage(fun:fun), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Navigation", style: .default, handler: { [self, fun, indexPath] _ in
            var start: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongitude)
            var dest: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: fun.latitude, longitude: fun.longitude)
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
    //            let urlString = "http://maps.google.com/?daddr=\(dest.latitude),\(dest.longitude)&directionsmode=driving"

                // use bellow line for specific source location
                let urlString = "http://maps.google.com/?saddr=\(start.latitude),\(start.longitude)&daddr=\(dest.latitude),\(dest.longitude)&directionsmode=driving"

                UIApplication.shared.openURL(URL(string: urlString)!)
            } else {
                //let urlString = "http://maps.apple.com/maps?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&dirflg=d"
                let urlString = "http://maps.apple.com/maps?daddr=\(dest.latitude),\(dest.longitude)&dirflg=d"

                UIApplication.shared.openURL(URL(string: urlString)!)
            }
        }))

        present(alert, animated: true)

        
        //        let defaultAction = UIAlertAction(title: "Close Alert", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//
//        presentViewController(alertController, animated: true, completion: nil)
    }
}
