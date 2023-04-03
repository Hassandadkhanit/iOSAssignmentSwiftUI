//
//  LessonDetailViewController.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 03/04/2023.
//

import UIKit

class LessonDetailViewController: UIViewController {

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
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    //MARK: - Setup
    func setupViews() {
        
        let navigationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        navigationView.backgroundColor = .orange
        

        let downloadButton =  UIButton(type: .custom)
        downloadButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for:.normal)
        downloadButton.setTitle("Lessons", for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        
        let backButton =  UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for:.normal)
        backButton.setTitle("Download", for: .normal)
        backButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        
        self.view.addSubview(navigationView)
    }
    
    //MARK: - IB Action
    @objc func downloadTapped() {
        
    }


}
