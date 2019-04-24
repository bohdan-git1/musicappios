//
//  PlaySongViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 23/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit


import MediaPlayer
import MBCircularProgressBar


class PlaySongViewController: BaseViewController,TopBarDelegate {
    
    @IBOutlet weak var lblSongName : UILabel!
    @IBOutlet weak var lblSongURL : UILabel!
    @IBOutlet weak var imgSong : UIImageView!
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    
    var index = 0
    var timer: Timer?
    var countTime:Int = 0
    var audioUrl:String? = ""
    var audioPlayer:AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.configure()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.topBarHeight.constant = TOP_BAR_HEIGHT
            container.btnMenu.isHidden = true
            container.btnBack.isHidden = false
            container.btnEdit.isHidden = true
            container.lblTitle.text = ""
            container.delegate = self
        }
    }
    func configure(){
        self.player?.pause()
        self.player = nil
        let song = Global.shared.songList.songList[self.index]
        self.lblSongURL.text = song.path
        self.lblSongName.text = song.title
        self.audioUrl =  Global.shared.songList.songList[self.index].path
        let urlstring = audioUrl!
        let url = URL.init(string: urlstring)
        print("the url = \(url!)")
        self.downloadFileFromURL(audioUrl: url!)
        //self.downloadSound(url: url!)
        
        
        
        

        //playsong(url: song.path)

    }
    
    
    func downloadFileFromURL(audioUrl:URL){
        
        GCD.async(.Background) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            // print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                GCD.async(.Main, execute: {
                   // self.setActivityStatus(isShow: false)
                    self.playAudio(url: destinationUrl)
                })
                
                
                // if the file doesn't exist
            }
            else {
                var downloadTask:URLSessionDownloadTask
                
                downloadTask = URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        
                        
                        GCD.async(.Main, execute: {
                           // self.setActivityStatus(isShow: false)
                            self.playAudio(url: destinationUrl)
                        })
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                })
                
                //            downloadTask = URLSession.shared.downloadTask(with: audioUrl, completionHandler: { [weak self](URL, response, error) -> Void in
                //                self?.play(url: URL!)
                //            })
                downloadTask.resume()
            }
        }
        
    }
    

    func playAudio(url: URL) {
        GCD.async(.Main, execute: {
            print("playing \(url)")
            do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                //try AVAudioSession.sharedInstance().setActive(true)
                
                
                self.player = AVPlayer(url: url)
                self.player?.volume = 1
                 self.player?.play()
                self.progressBar.setProgress(to: 1000, withAnimation: true)
               // self.audioSlider.minimumValue = 0
                //self.audioSlider.maximumValue = Float(CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!))
                let duration = Float(CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!))
                
               
                
                if(duration > 0){
                    self.updateAudioSlider(progress:duration)
                }
                //self.lblEndTime.text = self.getDurationString(seconds: Int(duration))
                
//                if let del = self.delegate{
//                    del.actionCallBackStopAudio(index: self.index, play: true, player: self.player!)
//                    del.actionCallBackSetActivityStatus(isShow: false, index: self.index)
//                    del.actionCallBackUpdateButtonStatus(isSelected: true, index: self.index)
//                }
                
                
            } catch let error as NSError {
                //self.player = nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
        })
    }
    func updateAudioSlider(progress:Float){
        if #available(iOS 10.0, *) {
            self.countTime = 0
            //self.audioSlider.value = Float(self.countTime)
            progressBar.safePercent = Int(progress)
            self.progressBar.setProgress(to: Double(progress), withAnimation: true)
//            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
//                self.countTime = self.countTime + 1
//
//               // self.lblStartTime.text = self.getDurationString(seconds: self.countTime)
//            })
        } else {
            // Fallback on earlier versions
        }
    }
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    @objc func updateTime() {
        self.countTime = self.countTime + 1
       print(self.getDurationString(seconds: self.countTime))
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getDurationString(seconds:Int) -> String {
        let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: seconds)
        var timerString = ""
        var hours = ""
        var minuts = ""
        var seconds = ""
        if(h > 9){
            hours = "\(h):"
        }else{
            hours = "0\(h):"
        }
        if(h < 1){
            hours = ""
        }
        if(m > 9){
            minuts = "\(m)"
        }else{
            minuts = "0\(m)"
        }
        if(s > 9){
            seconds = "\(s)"
        }else{
            seconds = "0\(s)"
        }
        timerString = hours + minuts + ":" + seconds
        return timerString
    }

    
  
    
    func actionCallBackMoveBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionCallBackEdit() {
        
    }
    
    @IBAction func actionNext(_ sender:Any){
        
        if(self.index < Global.shared.songList.songList.count-1){
            self.index = self.index+1
            self.configure()
           
            
        }
    }
    
    @IBAction func actionPrevious(_ sender:Any){
        if(self.index > 0){
             self.index = self.index-1
            self.configure()
           
        }
    }
    
    @IBAction func actionRepeat(_ sender:Any){
        self.configure()
    }
    
    @IBAction func actionShuffle(_ sender:Any){
        let randomInt = Int.random(in: 0..<Global.shared.songList.songList.count)
        self.index = randomInt
        self.configure()
    }

   

}
