//
//  ViewController.swift
//  testmaps
//
//  Created by Makino Ruki on 12/31/21.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var myMap: GMSMapView!
    let locationManager = CLLocationManager()
    //var topicList: [Topic] = [Topic]()
    let topicViewTable = TopicTableViewController()
    let funViewTable = FunTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let addTopicButton = UIButton(frame: CGRect(x: 10, y: 500, width: 150, height: 50))
        view.addSubview(addTopicButton)
        addTopicButton.backgroundColor = .systemBlue
        addTopicButton.setTitle("Add Topic", for: .normal)
       // button.center = view.center
        addTopicButton.setTitleColor(.white, for: .normal)
        addTopicButton.addTarget(self, action: #selector(addTopics), for: .touchUpInside)
        
        let getHotTopicsButton = UIButton(frame: CGRect(x: 10, y: 570, width: 150, height: 50))
        view.addSubview(getHotTopicsButton)
        getHotTopicsButton.backgroundColor = .systemBlue
        getHotTopicsButton.setTitle("Trending Topics", for: .normal)
       // button.center = view.center
        getHotTopicsButton.setTitleColor(.white, for: .normal)
        getHotTopicsButton.addTarget(self, action: #selector(getTrendingTopics), for: .touchUpInside)
        
        let getTopicsByKeywordButton = UIButton(frame: CGRect(x: 10, y: 640, width: 150, height: 50))
        view.addSubview(getTopicsByKeywordButton)
        getTopicsByKeywordButton.backgroundColor = .systemBlue
        getTopicsByKeywordButton.setTitle("Topics@Keyword", for: .normal)
       // button.center = view.center
        getTopicsByKeywordButton.setTitleColor(.white, for: .normal)
        getTopicsByKeywordButton.addTarget(self, action: #selector(getTopicsByKeyword), for: .touchUpInside)
        
        let navigationButton = UIButton(frame: CGRect(x: 10, y: 710, width: 150, height: 50))
        view.addSubview(navigationButton)
        navigationButton.backgroundColor = .systemBlue
        navigationButton.setTitle("Local Fun", for: .normal)
       // button.center = view.center
        navigationButton.setTitleColor(.white, for: .normal)
        navigationButton.addTarget(self, action: #selector(getLocalFunStuff), for: .touchUpInside)
//        if CLLocationManager.locationServicesEnabled()
//        {
//            locationManager.requestLocation()
//        }
//        else {
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    @objc private func getTopicsByKeyword() {
        let alert = UIAlertController(
            title: "Get topics by keyword",
            message: "Input single keyword to match interesting topics",
            preferredStyle: .alert
        )
        alert.addTextField { field in
            field.placeholder = "Keyword"
            field.returnKeyType = .continue
            field.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
            guard let fields = alert.textFields, fields.count == 1 else {
                return
            }
            let keyword: String = fields[0].text!
            self.sendSearchRequest(keyword: keyword, latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        }))
        
        present(alert, animated: true)
    }
    
    func sendSearchRequest(keyword: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let url = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
//        print("Topic: \(topic)")
//        print("Content: \(content)")
//        print("Latitude: \(latitude)")
//        print("Longitude: \(longitude)")
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
        let topicRequest = GetTopics(keyword: keyword, latitude: latitude, longitude: longitude)
        topicRequest.searchTopics { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let topics):
                print("len=")
                print(topics.count)
                self?.topicViewTable.setTopics(topics: topics)
                //self?.topicList = topics
            }
        }
        present(self.topicViewTable, animated: true)
      //  print("value2" + value)
    }
    
    @objc private func getLocalFunStuff() {
        let getFunStuffRequest = GetFuns(latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        getFunStuffRequest.searchFuns() { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let funs):
                print("len=")
                print(funs.count)
                self?.funViewTable.setFuns(funs: funs, currentLatitude: self?.locationManager.location?.coordinate.latitude ?? 0.0, currentLongitude: self?.locationManager.location?.coordinate.longitude ?? 0.0)
                //self?.topicList = topics
            }
        }
        
        print("x=")
       // print(self.topicList.count)
//        let table = TopicTableViewController()
//        table.setTopics(topics: self.topicList)
        present(self.funViewTable, animated: true)
    }
    
    @objc private func getNavigation() {
//        CLLocationCoordinate2D start = { 34.052222, -118.243611 };
//        CLLocationCoordinate2D destination = { 37.322778, -122.031944 };
//        CLLocationDegrees x = 100.0
//        CLLocationDegrees y = -110.0
        
        
        var start: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
        var dest: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7124740, longitude: -122.4033333)
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
        
        // Using Google maps on web, navigation in app need to be charged (?)
//        let urlString = "https://www.google.co.in/maps/dir/?saddr=\(start.latitude),\(start.longitude)&daddr=\(dest.latitude),\(dest.longitude)&directionsmode=driving"
        
//        let urlString = "http://maps.google.com/?saddr=\(start.latitude),\(start.longitude)&daddr=\(dest.latitude),\(dest.longitude)&directionsmode=driving"
//
//        UIApplication.shared.openURL(URL(string: urlString)!)
    }
    
    @objc private func getTrendingTopics() {
       // let alert = UITableViewController()
//        var topics:[Topic] = [Topic(title: "test", content: "test", latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)]
        
        let getTrendingTopicsRequest = GetTopics(keyword: "", latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        getTrendingTopicsRequest.searchTopics() { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let topics):
                print("len=")
                print(topics.count)
                self?.topicViewTable.setTopics(topics: topics)
                //self?.topicList = topics
            }
        }
        
        print("x=")
       // print(self.topicList.count)
//        let table = TopicTableViewController()
//        table.setTopics(topics: self.topicList)
        present(self.topicViewTable, animated: true)
        
    }
    
    @objc private func addTopics() {
        let alert = UIAlertController(
            title: "Add topic",
            message: "Please add your topic here",
            preferredStyle: .alert
        )
        alert.addTextField { field in
            field.placeholder = "Topic"
            field.returnKeyType = .next
            field.keyboardType = .default
        }
        alert.addTextField { field in
            field.placeholder = "Content"
            field.returnKeyType = .continue
            field.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
            guard let fields = alert.textFields, fields.count == 2 else {
                return
            }
            let topic: String = fields[0].text!
            let content: String = fields[1].text!
            self.sendAddTopicRequest(topic: topic, content: content, latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        }))
        
        present(alert, animated: true)
    }
    
    func sendAddTopicRequest(topic: String, content: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let url = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
//        print("Topic: \(topic)")
//        print("Content: \(content)")
//        print("Latitude: \(latitude)")
//        print("Longitude: \(longitude)")
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
        let topicRequest = Topic(topicId: 0, title: topic, content: content, latitude: latitude, longitude: longitude)
        topicRequest.postTopic { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let status):
                print("status=\(status)")
            }
        }
      //  print("value2" + value)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myMap.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), zoom: 8, bearing: 0, viewingAngle: 0)
     //   print(locationManager.location?.coordinate.latitude)
     //   print(locationManager.location?.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        marker.title = "Hey Hi"
        marker.snippet = "Im here"
        
        marker.map = myMap
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways:
                return
            case .authorizedWhenInUse:
                return
            case .denied:
                return
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


