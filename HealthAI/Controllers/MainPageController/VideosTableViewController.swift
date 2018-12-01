//
//  VideosTableViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/30/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import AVKit

class VideosTableViewController: UITableViewController {
    
    

    let videos = ["video","video","video","video3","video4","video5","video6","video7","video8","video9"]
    let videoTitles = ["Workout1","Workout2","Workout3","Workout4","Workout5","Workout6","Workout7","Workout8","Workout9","Workout10"]
    let imagesArray = ["workout11","workout21","workout3","workout4","workout5","workout6","workout7","workout8","workout9","workout10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        cell.videoCellImageView.image = UIImage(named: imagesArray[indexPath.row])
        
        cell.playButton.tag = indexPath.row
        
        cell.playButton.addTarget(self, action: #selector(videoplayPressed(sender:)), for: .touchUpInside)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Video Tutorials"
    }
    
    
    @objc func videoplayPressed(sender: UIButton) {
        
        //play different videos here
        
        for index in 0..<videos.count {
            
            if sender.tag == index {
                playVideo(videoName: videos[index])
            }
            
        }
        
//        if sender.tag == 0 {
//
//            if let path = Bundle.main.path(forResource: "video", ofType: "MOV"){
//
//                let video = AVPlayer(url: URL(fileURLWithPath: path))
//
//                let videoPlayer = AVPlayerViewController()
//
//                videoPlayer.player = video
//
//                present(videoPlayer,animated: true,completion: {
//                    video.play()
//
//                })
//            }
//        }
        
    }
    
    func playVideo(videoName: String){
        
        if let path = Bundle.main.path(forResource: videoName, ofType: "MOV"){
            
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            
            let videoPlayer = AVPlayerViewController()
            
            videoPlayer.player = video
            
            present(videoPlayer,animated: true,completion: {
                video.play()
                
            })
        }
    
    }

   
}
