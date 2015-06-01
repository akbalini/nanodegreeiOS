//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Akbal Juarez on 5/12/15.
//  Copyright (c) 2015 akbalini. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    
    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var session:AVAudioSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        configAudioSession()
        
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        player.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        audioFile =  AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configAudioSession(){
        //Congiguring session to use the output speaker system and instead of headset system.
        session = AVAudioSession.sharedInstance()
        var error:NSError?
        
        if(!session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)){
            print("There was an error overriding with : \(error?.description)")
        }
        
    }
    
    func playSound(rate: Float){
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        player.rate = rate
        player.currentTime=0.0
        player.play()
        player.updateMeters()
    }
    
    
    
    @IBAction func playSoundSlow(sender: UIButton) {
        
       playSound(0.5)
        
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        //stop audio both audioplayer and engine,  reset audio engine.
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        //Using AVAUdioUnitTimePith to create an effect on the pitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        player.stop()
        audioEngine.stop()
    }

}
