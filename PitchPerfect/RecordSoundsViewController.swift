//
//  RecordSoundsViewController
//  PitchPerfect
//
//  Created by Desarrollo Adagal on 27/11/17.
//  Copyright © 2017 Adagal Sistemas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lblTap: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnStop.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }

    @IBAction func recordAudio(_ sender: Any) {
        btnRecord.isHidden = true
        btnStop.isHidden = false
        btnRecord.isEnabled = false
        btnStop.isEnabled = true
        lblTap.text = "Grabando audio..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])

        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (!flag) {
            print ("Recording failed")
            return
        } else {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        btnRecord.isHidden = false
        btnStop.isHidden = true
        btnRecord.isEnabled = true
        btnStop.isEnabled = false
        lblTap.text = "Pulsa para grabar"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}

