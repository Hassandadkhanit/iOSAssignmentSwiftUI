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
import Combine

class LessonDetailViewController: UIViewController {

    var navigationView = UIView()
    var videoView = UIView()
    var contentView = UIView()
    var scrollView = UIView()
    var progressView = UIView()
    var downloadButton : UIButton = {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for:.normal)
        button.setTitle(" Download", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button

    }()
    var backButton: UIButton = {
       let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.left"), for:.normal)
        button.setTitle(" Lessons", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var previousButton: UIButton = {
       let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.left"), for:.normal)
        button.setTitle(" Previous Lesson ", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var nextButton: UIButton = {
       let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.right"), for:.normal)
        button.setTitle("Next Lesson ", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var titleLabel: UILabel = {
       let label = UILabel.init()
        label.textColor = .customTextColor
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = .customTextColor
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var progressLabel: UILabel = {
       let  label = UILabel.init()
        label.textColor = .customTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let playerController           = AVPlayerViewController()
    var subscription = Set<AnyCancellable>()
    
    var videoViewHeightConstraints = NSLayoutConstraint()
    var navigationHeightConstraint = NSLayoutConstraint()
    var scrollViewHeightConstraint = NSLayoutConstraint()
    var progressViewHeightConstraint = NSLayoutConstraint()
    
    var viewModel = LessonDetailViewModel()


    
    //MARK: - Init
    init(viewModel: LessonDetailViewModel = LessonDetailViewModel()) {
        super.init(nibName: String(describing: LessonDetailViewController.self), bundle: nil)
        self.viewModel = viewModel
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
        self.bindViewModel()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.setupPlayer()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        player.seek(to: .zero)
        playerController.player?.seek(to: .zero)
        playerController.player?.pause()
        player.pause()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    // MARK: - BindViewModel
    func bindViewModel() {
        viewModel.$progress
            .receive(on: RunLoop.main)
            .sink { progress in
                if progress > 0.0 {
                    self.progressViewHeightConstraint.constant = 60
                    self.progressLabel.text = String(format: "Downloaded: %.2f", progress * 100) + "%"
                }
            }
            .store(in: &subscription)
        viewModel.$downloadResult
            .receive(on: RunLoop.main)
            .sink { result in
                self.progressViewHeightConstraint.constant = 0

                switch result {
                    
                case .failure(let error):
                    self.presentAlertWithTitleAndMessage(title: "", message: error.localizedDescription, options: "OK", completion: { buttons in
                    })
                    break
                case .success(let downloadResult):
                    break
                case.none:
                    print("none")
                    break
                }
            }
            .store(in: &subscription)

    }
    //MARK: - Setup
    func setupViews() {
        self.view.backgroundColor = .customBackgroundColor
        self.addChild(playerController)
        self.setupNavigationView()
        self.setupPlayerView()
        self.setupScrollView()
        self.setupProgressView()

        
    }
    func setupNavigationView() {
         navigationView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        navigationView.backgroundColor = .customBackgroundColor

        navigationView.addSubview(backButton)
        navigationView.addSubview(downloadButton)

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

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(nextButton)
        self.contentView.addSubview(previousButton)
        
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
    func setupProgressView() {
        progressView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        progressView.backgroundColor = .customBackgroundColor
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            

        ])
        
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalToConstant: 0)
        progressViewHeightConstraint.isActive = true
        self.progressView.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 8),
            progressLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -16)

        ])
    }
    
    
    //MARK: - Set Values
    func setValues() {
        titleLabel.text = viewModel.lesson?.name ?? ""
        descriptionLabel.text = viewModel.lesson?.description ?? ""
        
    }
    func setButtons() {
        self.previousButton.isHidden = (viewModel.selectedOffset ?? -1) > 0 ? false : true
        self.nextButton.isHidden = (viewModel.selectedOffset ?? -1) == ((DataManager.shared.lessons.lessons?.count ?? 0)  - 1) ? true : false
    }
    func setupPlayer() {
        
        player.seek(to: .zero)
        player.pause()

        if playerController.player != nil {
            playerController.player?.seek(to: .zero)
            playerController.player?.pause()
        }
        
        
        var videoUrl = URL(string: viewModel.lesson?.video_url ?? "")
        if !NetworkMonitor.shared.isReachable {
            let documentFile = Utilities.documentsUrl.appendingPathComponent("\(viewModel.lesson?.id ?? 0)" + "." + FileType.mp4.rawValue)
            videoUrl = URL(fileURLWithPath: documentFile.path)
        }
        player = AVPlayer.init(url: videoUrl!)
        playerController.view.frame = self.videoView.bounds
        playerController.player = player
        self.videoView.addSubview(playerController.view)
        player.play()
        
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
        if !viewModel.isDownloadInProgress {
            self.downloadButton.setTitle(" Cancel Download", for: .normal)
            self.viewModel.downloadVideoFrom(lesson: viewModel.lesson)

        } else {
            self.downloadButton.setTitle(" Download", for: .normal)
            self.viewModel.isDownloadInProgress = false
            self.progressViewHeightConstraint.constant = 0
            self.viewModel.cancelDownload()
        }
    }
    @objc func playTapped() {
        player.play()
    }
    
    @objc func nextTapped() {
        let nextIndex  = (viewModel.selectedOffset ?? 0) + 1
        if nextIndex < DataManager.shared.lessons.lessons?.count ?? 0 {
            viewModel.selectedOffset = nextIndex
            viewModel.lesson = DataManager.shared.lessons.lessons?[nextIndex]
            self.setupPlayer()
            self.setValues()
            
            self.previousButton.isHidden = nextIndex > 0 ? false : true
            self.nextButton.isHidden = nextIndex == ((DataManager.shared.lessons.lessons?.count ?? 0)  - 1) ? true : false
        }
        
    }
    @objc func previousTapped() {
        let previousIndex  = (viewModel.selectedOffset ?? 0) - 1
        if previousIndex >= 0  {
            viewModel.selectedOffset = previousIndex
            viewModel.lesson = DataManager.shared.lessons.lessons?[previousIndex]
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
