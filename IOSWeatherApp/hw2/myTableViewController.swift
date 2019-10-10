//
//  myTableViewController.swift
//  hw2
//
//  Created by 邓荔文 on 9/19/19.
//  Copyright © 2019 liwen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class myTableViewController: UITableViewController {
    // the latitude of the cities
    var lat:[String] = ["35.9940","35.9132","35.9101","35.8235","35.787743","35.7915","30.5728"]
    // the longtitude of the cities
    var lon:[String] = ["-78.8986","-79.0558","-79.0753","-78.8256","-78.644257","-78.7811","104.0668"]
    var cities:[String] = ["Durham","Chapel Hill","Carrboro","Morrisville","Raleigh","Cary","Chengdu"]
    var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    @IBAction func edit(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let apiKey = "b49d27ea81ec880cd29cea09b5d416ed"
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.startAnimating()
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myTableViewCell
    Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(self.lat[indexPath.row])&lon=\(self.lon[indexPath.row])&appid=\(apiKey)&units=metric").responseJSON {
        response in
        self.activityIndicator.stopAnimating()
        if let responseStr = response.result.value {
            let jsonResponse = JSON(responseStr)
            let jsonWeather = jsonResponse["weather"].array![0]
            let jsonTemp = jsonResponse["main"]
            let iconName = jsonWeather["icon"].stringValue
            cell.weather?.image = UIImage(named: iconName)
            cell.weatherName?.text = jsonWeather["main"].stringValue
            cell.degree?.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
            cell.cities?.text = jsonResponse["name"].stringValue
//            cell.backImage?.image = UIImage(named: self.cities[indexPath.row])
        }
        // Configure the cell...
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weather of cities"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC  = segue.destination as! cellDetailViewController
        let myRow = tableView!.indexPathForSelectedRow
        destVC.lon = lon[myRow?.row ?? 0]
        destVC.lat = lat[myRow?.row ?? 0]
    }
    
    // Cell removal
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cities.remove(at: indexPath.row)
            lon.remove(at: indexPath.row)
            lat.remove(at: indexPath.row)
//            degrees.remove(at: indexPath.row)
//            weatherName.remove(at: indexPath.row)
//            pictures.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Cell reorder
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedC = self.cities[sourceIndexPath.row]
        cities.remove(at: sourceIndexPath.row)
        cities.insert(movedC, at: destinationIndexPath.row)
            
        let movedLat = self.lat[sourceIndexPath.row]
        lat.remove(at: sourceIndexPath.row)
        lat.insert(movedLat, at: destinationIndexPath.row)
        
        let movedLon = self.lon[sourceIndexPath.row]
        lon.remove(at: sourceIndexPath.row)
        lon.insert(movedLon, at: destinationIndexPath.row)

    }

}
