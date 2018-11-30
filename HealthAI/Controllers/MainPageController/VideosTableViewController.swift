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

    let videos = ["video1","video"]
    let videoTitles = ["Workout1","Workout2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let button = cell.viewWithTag(1) as! UIButton

        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        
        button.tag = indexPath.row
        
        button.addTarget(self, action: #selector(videoplayPressed(sender:)), for: .touchUpInside)

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
