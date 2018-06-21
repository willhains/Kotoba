//
//  WordPronouncer.swift
//  Kotoba
//
//  Created by Gabor Halasz on 21/06/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import AVFoundation

final class WordPronouncer {
  private let synth: AVSpeechSynthesizer = AVSpeechSynthesizer()
  
  func pronounce(_ word: String) {
    let utterence = AVSpeechUtterance(string: word)
    utterence.voice = AVSpeechSynthesisVoice(identifier: "en-US")
    
    synth.speak(utterence)
  }
}
