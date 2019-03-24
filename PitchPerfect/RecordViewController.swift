//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Omar Yahya Alfawzan on 3/16/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var statusRecording: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonUI(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonUI(true)
    }
    
    
    @IBAction func recordAudio1(_ sender: Any) {
        setButtonUI(false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecordingButton(_ sender: Any) {
        setButtonUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
       
    }
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
         self.performSegue(withIdentifier: "playRecord", sender: audioRecorder.url)

        } else {
            print("Recording not succssful!")
            statusRecording.text = "Recording not succssful!"
            statusRecording.textColor = UIColor.red

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playRecord" {
            let playViewController = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playViewController.recordedAudioURL = recordedAudioURL
        }
    }
    
    
     func setButtonUI(_ enabled: Bool) {
        stopRecordButton.isHidden = enabled
        stopRecordButton.isEnabled = !enabled
        recordButton.isHidden = !enabled
        recordButton.isEnabled = enabled
        statusRecording.text = enabled ? "Tap to start recording " : "Recording in Progress"
        statusRecording.textColor = enabled ? UIColor.lightText : UIColor.cyan
       
    }
    
    
}
