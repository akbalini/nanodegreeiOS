//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Akbal Juarez on 4/28/15.
//  Copyright (c) 2015 akbalini. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButon: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        readyToRecord()
    }

    //Reanabling labels and buttons to record
    func readyToRecord(){
        stopButon.hidden=true
        recordButton.enabled = true
        recordingLabel.text="Tap to Record"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func stopRecording(sender: UIButton) {
        stopButon.hidden=true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func recordAudio(sender: UIButton) {
            
        recordingLabel.text = "Recording in progress"
        stopButon.hidden = false
        recordButton.enabled = false
        //Record the user's voice
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var currentDataTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDataTime)+".wav"
        var pathArray = [dirPath,recordingName]
        var filePath = NSURL.fileURLWithPathComponents(pathArray)


        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //AVAudioRecoder is set with the new filePath created with the current DATATIME
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        println("in RecordAudio")
        
    
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //Cheking if the recording was successed recorded
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            //Reenabling To record.
            readyToRecord()
        }
        
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            //setting the RecordedAudio Model in the next viewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
}

