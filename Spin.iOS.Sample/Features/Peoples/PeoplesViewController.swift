//
//  FilmsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Reusable
import RxSwift
import RxRelay
import Spin
import Spin_RxSwift
import UIKit

class PeoplesViewController: UIViewController, StoryboardBased {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    private var datasource = [(People, Bool)]()
    
    var commandBuilder: PeoplesFeature.Commands.Builder!
    let commandsRelay = PublishRelay<AnyCommand<Observable<PeoplesFeature.Action>, PeoplesFeature.State>>()
        
    @IBAction func previousTapped(_ sender: UIButton) {
        self.commandsRelay.accept(self.commandBuilder.buildPreviousCommand())
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.commandsRelay.accept(self.commandBuilder.buildNextCommand())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.commandsRelay.accept(self.commandBuilder.buildAllCommand())
    }
}

extension PeoplesViewController {
    func emitCommands() -> Observable<AnyCommand<Observable<PeoplesFeature.Action>, PeoplesFeature.State>> {
        return self.commandsRelay.asObservable()
    }
}

extension PeoplesViewController {
    func interpret(state: PeoplesFeature.State) -> Void {

        guard
            self.activityIndicator != nil,
            self.previouxButton != nil,
            self.nextButton != nil,
            self.tableView != nil else { return }

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.alpha = 0.5
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        case .loaded(let peoples, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.alpha = 1
            self.datasource = peoples
            self.tableView.reloadData()
            self.previouxButton.isEnabled = (previous != nil)
            self.nextButton.isEnabled = (next != nil)
        case .failed:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        }
    }
}

extension PeoplesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.name
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension PeoplesViewController {
    static func make(commandBuilder: PeoplesFeature.Commands.Builder) -> PeoplesViewController {
        let viewController = PeoplesViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}


