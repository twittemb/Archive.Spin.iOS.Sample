//
//  PlanetsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Reusable
import RxFlow
import RxRelay
import RxSwift
import Spin
import UIKit

class PlanetsViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    private var datasource = [Planet]()
    
    var commandBuilder: Planets.Commands.Builder!
    let commandsRelay = PublishRelay<AnyCommand<Observable<Planets.Action>, Planets.State>>()
        
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

extension PlanetsViewController {
    func emitCommands() -> Observable<AnyCommand<Observable<Planets.Action>, Planets.State>> {
        return self.commandsRelay.asObservable()
    }
}

extension PlanetsViewController {
    func interpret(state: Planets.State) -> Void {

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
        case .loaded(let planets, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.alpha = 1
            self.datasource = planets
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

extension PlanetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].name
        return cell
    }
}

extension PlanetsViewController {
    static func make(commandBuilder: Planets.Commands.Builder) -> PlanetsViewController {
        let viewController = PlanetsViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}

