//
//  PlanetsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import ReactiveSwift
import Spin
import Spin_ReactiveSwift
import UIKit

class PlanetsFlow: Flow {
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
        
    var root: Presentable {
        return self.rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppSteps else { return .none }
        
        switch step {
        case .planets:
            return self.navigateToPlanets()
        case .planet(let planet):
            return self.navigate(to: planet)
        default:
            return .none
        }
    }
}

extension PlanetsFlow {
    func navigateToPlanets() -> FlowContributors {
        
        // build Spin
        let viewController = PlanetsViewController.make(commandBuilder: PlanetsFeature.Commands.Builder())
        let interpretFunction = weakify(viewController) { $0.interpret(state: $1) }

        Spinner
            .from(function: viewController.emitCommands)
            .executeAndScan(initial: .idle, reducer: PlanetsFeature.reducer)
            .consume(by: interpretFunction, on: UIScheduler())
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    func navigate(to planet: Planet) -> FlowContributors {

        let viewController = PlanetViewController.make(commandBuilder: PlanetFeature.Commands.Builder())
        let interpretFunction = weakify(viewController) { $0.interpret(state: $1) }

        Spinner
            .from(function: viewController.emitCommands)
            .executeAndScan(initial: .idle(planet: planet), reducer: PlanetFeature.reducer)
            .consume(by: interpretFunction, on: UIScheduler())
            .spin()
            .disposed(by: viewController.disposeBag)

        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
