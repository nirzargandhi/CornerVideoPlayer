//
//  HomeVC.swift
//  CornerVideoPlayer
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import UIKit
import AVFoundation

class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    private(set) weak var videoOverlay: UIView!
    private(set) weak var videoDragContainer: UIView!
    private(set) weak var videoContainer: UIView!
    private(set) weak var closeVideoBtn: UIButton!
    
    
    // MARK: - Properties
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var player: AVPlayer?
    fileprivate var isVideoPlaying = false
    fileprivate let videoStr = "https://cdn.pixabay.com/video/2023/07/12/171274-845168276_large.mp4"
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        NC.addObserver(self, selector: #selector(self.reloadByDidBecomeActive), name: NSNotification.Name(rawValue: UIApplication.didBecomeActiveNotification.rawValue), object: nil)
        
        self.setUpVideoPlayerUI()
        self.playVideo()
    }
    
    fileprivate func setUpVideoPlayerUI() {
        
        self.view.backgroundColor = .white
        self.view.isOpaque = false
        
        let width: CGFloat = 147
        let height: CGFloat = 194
        let padding: CGFloat = 20
        
        // Video Ovelay
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
        self.videoOverlay = overlay
        overlay.backgroundColor = .clear
        self.view.addSubview(overlay)
        
        // Video Drag View
        let videodragview = UIView(frame: CGRect(x: 0,
                                                 y: SCREENHEIGHT - height - (padding * 2),
                                                 width: width + (padding * 2),
                                                 height: height + (padding * 2)))
        self.videoDragContainer = videodragview
        self.view.addSubview(videodragview)
        videodragview.backgroundColor = .clear
        
        // Video View
        let videoview = UIView(frame: CGRect(x: padding, y: padding, width: width, height: height))
        self.videoContainer = videoview
        videodragview.addSubview(videoview)
        videoview.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        videoview.addRadiusWithBorder(radius: 10)
        videoview.clipsToBounds = true
        videoview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrageVideoContainer(_:))))
        
        // Video Close Button
        let closevideobtn = UIButton(frame: CGRect(x: width, y: 3, width: 40, height: 40))
        self.closeVideoBtn = closevideobtn
        videodragview.addSubview(closevideobtn)
        closevideobtn.backgroundColor = .clear
        closevideobtn.setImage(UIImage(named: "CrossFilledWhite"), for: .normal)
        closevideobtn.showsTouchWhenHighlighted = false
        closevideobtn.adjustsImageWhenHighlighted = false
        closevideobtn.adjustsImageWhenDisabled = false
        closevideobtn.addTarget(self, action: #selector(closeVideoBtnTouch(_:)), for: .touchUpInside)
        
        self.view.bringSubviewToFront(overlay)
        self.view.bringSubviewToFront(videodragview)
        
        overlay.isHidden = true
        videodragview.isHidden = true
    }
}


// MARK: - Call back
extension HomeVC {
    
    @objc fileprivate func reloadByDidBecomeActive() {
        
        if self.isVideoPlaying {
            self.player?.play()
        }
    }
    
    fileprivate func playVideo() {
        
        self.videoContainer.layer.sublayers?.removeAll()
        
        let videoURL = URL(string: self.videoStr)
        
        self.playerItem = AVPlayerItem(url: videoURL!)
        self.playerItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        
        self.player = AVPlayer(playerItem: self.playerItem)
        self.player?.isMuted = true
        self.player?.actionAtItemEnd = .none
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.videoContainer.bounds
        
        self.videoContainer.layer.addSublayer(playerLayer)
        self.isVideoPlaying = true
        
        if let item = self.playerItem {
            NC.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        }
        NC.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NC.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            if self.player != nil {
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            
            if let status = self.playerItem?.status {
                
                switch status {
                    
                case .readyToPlay:
                    self.player?.play()
                    self.videoOverlay.isHidden = false
                    self.videoDragContainer.isHidden = false
                    
                case .failed:
                    print("Failed to load AVPlayerItem.")
                    
                default:
                    print("AVPlayerItem status ?: \(status.rawValue)")
                }
            }
        }
    }
    
    @objc fileprivate func onDrageVideoContainer(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        let width = self.videoDragContainer.bounds.width / 2
        let height = self.videoDragContainer.bounds.height / 2
        
        let centerMinX: CGFloat = width
        let centerMaxX: CGFloat = SCREENWIDTH - width
        let centerMinY: CGFloat = STATUSBARHEIGHT + NAVBARHEIGHT + height
        let centerMaxY: CGFloat = SCREENHEIGHT - height
        
        if sender.state == .changed {
            
            var centerX = self.videoDragContainer.center.x + translation.x
            var centerY = self.videoDragContainer.center.y + translation.y
            
            if centerX < centerMinX {
                centerX = centerMinX
            } else if centerX > centerMaxX {
                centerX = centerMaxX
            }
            
            if centerY < centerMinY {
                centerY = centerMinY
            } else if centerY > centerMaxY {
                centerY = centerMaxY
            }
            
            self.videoDragContainer.center = CGPoint(x: centerX, y: centerY)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    fileprivate func closeVideoPlayer(isCallApi: Bool = false) {
        
        if self.playerItem?.observationInfo != nil {
            self.playerItem?.removeObserver(self, forKeyPath: "status")
        }
        if let item = self.playerItem {
            NC.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        }
        NC.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.player?.pause()
        self.player = nil
        self.playerItem = nil
        
        if self.isVideoPlaying {
            
            self.videoContainer.layer.sublayers?.removeAll()
            self.videoDragContainer.isHidden = true
            
            self.videoOverlay.isHidden = true
            
            self.videoOverlay.removeFromSuperview()
            self.videoContainer.removeFromSuperview()
            self.closeVideoBtn.removeFromSuperview()
            self.videoDragContainer.removeFromSuperview()
            
            self.isVideoPlaying = false
        }
    }
}


// MARK: - Button Touch & Action
extension HomeVC {
    
    @objc func closeVideoBtnTouch(_ sender: UIButton) {
        
        self.closeVideoPlayer(isCallApi: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            
            self?.setUpVideoPlayerUI()
            self?.playVideo()
        }
    }
}
