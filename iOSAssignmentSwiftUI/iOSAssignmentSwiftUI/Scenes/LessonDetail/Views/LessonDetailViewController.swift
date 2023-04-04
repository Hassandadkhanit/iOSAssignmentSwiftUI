//
//  LessonDetailViewController.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 03/04/2023.
//

import UIKit
import SwiftUI
import AVFoundation
import AVKit

class LessonDetailViewController: UIViewController {

    var navigationView = UIView()
    var videoView = UIView()
    var contentView = UIView()
    var scrollView = UIView()
    var downloadButton =  UIButton(type: .custom)
    var backButton =  UIButton(type: .custom)
    var previousButton =  UIButton(type: .custom)
    var nextButton =  UIButton(type: .custom)
    var lesson: Lessons?
    
    var selectedOffset: Int?
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let playerController           = AVPlayerViewController()
    
    var videoViewHeightConstraints = NSLayoutConstraint()
    var navigationHeightConstraint = NSLayoutConstraint()
    var scrollViewHeightConstraint = NSLayoutConstraint()


    
    //MARK: - Init
    init() {
        super.init(nibName: String(describing: LessonDetailViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.setupViews()
            self.setValues()
            self.setButtons()
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    //MARK: - Setup
    func setupViews() {
        self.view.backgroundColor = .customBackgroundColor
        self.addChild(playerController)
        self.setupNavigationView()
        self.setupPlayerView()
        self.setupScrollView()
        self.setupPlayer()

        
    }
    func setupNavigationView() {
         navigationView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        navigationView.backgroundColor = .customBackgroundColor


        let downloadButton =  UIButton(type: .custom)
        downloadButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for:.normal)
        downloadButton.setTitle(" Download", for: .normal)
        downloadButton.setTitleColor(.systemBlue, for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        
         backButton =  UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for:.normal)
        backButton.setTitle(" Lessons", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        

        navigationView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        
        navigationView.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(navigationView)
        navigationView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate(
            [
                navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                
            ]
        )
        navigationHeightConstraint =                 navigationView.heightAnchor.constraint(equalToConstant: 50)
        navigationHeightConstraint.isActive = true

        
        NSLayoutConstraint.activate(
            [
                backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
                backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16)
            ]
        )
        NSLayoutConstraint.activate(
            [
                downloadButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
                downloadButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16)
            ]
        )

        
    }
    func setupPlayerView() {
        videoView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.3))
        videoView.backgroundColor = .yellow
        self.view.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                videoView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
                videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
                videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0),
            ]
        )
        videoViewHeightConstraints =   videoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        
        videoViewHeightConstraints.isActive = true
        /*
        let playPauseButton =  UIButton(type: .custom)
        playPauseButton.setImage(UIImage(systemName: "play"), for:.normal)
        playPauseButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        videoView.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                playPauseButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
                playPauseButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            ]
        )
        
         */
        
       
        
    }
    func setupScrollView() {

        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)

            
        ])
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        scrollViewHeightConstraint.isActive = false
        
        contentView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.6))
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)

        ])
        
        titleLabel = UILabel.init()
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)

        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel = UILabel.init()
        descriptionLabel.textColor = .customTextColor
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton =  UIButton(type: .custom)
        nextButton.setImage(UIImage(systemName: "chevron.right"), for:.normal)
        nextButton.setTitle("Next Lesson ", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.semanticContentAttribute = .forceRightToLeft
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        self.contentView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        previousButton =  UIButton(type: .custom)
        previousButton.setImage(UIImage(systemName: "chevron.left"), for:.normal)
        previousButton.setTitle(" Previous Lesson ", for: .normal)
        previousButton.setTitleColor(.systemBlue, for: .normal)
        previousButton.isHidden = true
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        self.contentView.addSubview(previousButton)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        ])
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant:  16)

        ])
        
        NSLayoutConstraint.activate([
            
            previousButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previousButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0),

        ])
        
    }
    
    
    //MARK: - Set Values
    func setValues() {
        titleLabel.text = lesson?.name ?? ""
        descriptionLabel.text = lesson?.description ?? ""
        
    }
    func setButtons() {
        self.previousButton.isHidden = (self.selectedOffset ?? -1) > 0 ? false : true
        self.nextButton.isHidden = (self.selectedOffset ?? -1) == ((DataManager.shared.lessons.lessons?.count ?? 0)  - 1) ? true : false
    }
    func setupPlayer() {
        let videoUrl = URL.init(string: lesson?.video_url ?? "")
        player = AVPlayer.init(url: videoUrl!)
        playerController.view.frame = self.videoView.bounds
        playerController.player = player
        self.videoView.addSubview(playerController.view)
        
    }
    
    //MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if  UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            self.scrollViewHeightConstraint.isActive = true
            self.videoViewHeightConstraints.isActive = false
            self.navigationHeightConstraint.constant = 0
            self.navigationView.isHidden = true
            self.contentView.isHidden = true
            
        } else {
            self.navigationHeightConstraint.constant = 50
            self.navigationView.isHidden = false
            self.videoViewHeightConstraints.isActive =  true
            self.scrollViewHeightConstraint.isActive = false
            self.contentView.isHidden = false
  
        }
        
        
        
    }
    
    //MARK: - IB Action
    @objc func backTapped() {
        NavigationUtilities.popToRootView()
    }
    @objc func downloadTapped() {
        
    }
    @objc func playTapped() {
        player.play()
    }
    
    @objc func nextTapped() {
        let nextIndex  = (self.selectedOffset ?? 0) + 1
        if nextIndex < DataManager.shared.lessons.lessons?.count ?? 0 {
            self.selectedOffset = nextIndex
            self.lesson = DataManager.shared.lessons.lessons?[nextIndex]
            self.setupPlayer()
            self.setValues()
            
            self.previousButton.isHidden = nextIndex > 0 ? false : true
            self.nextButton.isHidden = nextIndex == ((DataManager.shared.lessons.lessons?.count ?? 0)  - 1) ? true : false
        }
        
    }
    @objc func previousTapped() {
        let previousIndex  = (self.selectedOffset ?? 0) - 1
        if previousIndex >= 0  {
            self.selectedOffset = previousIndex
            self.lesson = DataManager.shared.lessons.lessons?[previousIndex]
            self.setupPlayer()
            self.setValues()
            
            self.previousButton.isHidden = previousIndex > 1 ? false : true
            self.nextButton.isHidden = previousIndex < ((DataManager.shared.lessons.lessons?.count ?? 0)  - 1) ? false : true
        }
    }

}
extension UIApplication {

   var statusBarView: UIView? {
      return value(forKey: "statusBar") as? UIView
    }

}
