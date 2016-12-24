//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Dan Waseen on 12/16/16.
//  Copyright © 2016 RevWon. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

   
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    var audioRecorder : AVAudioRecorder? // = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        
        do{
            
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            // Create url for audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
   //         print("###############")
   //         print(audioURL)
    //        print("###############")
    
            // Create settings for the audio recorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey]  = kAudioFormatMPEG4AAC
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            //Create AudioRecorder object
            
            audioRecorder =  try AVAudioRecorder(url: audioURL!, settings : settings)
            audioRecorder!.prepareToRecord()
        }catch let error as NSError{
            print(error)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func playTapped(_ sender: Any) {
        do {
            try  audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop the recording
            audioRecorder?.stop()
            
            //Change button tittle to Record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }
        else {
            //Start the recording
            audioRecorder?.record()
            
            //Change button tittle to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }

  
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context : context)
        sound.name = nameText.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
