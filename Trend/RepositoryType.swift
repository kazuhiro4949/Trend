//
//  RepositoryType.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 5/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

enum Result<T, Error: ErrorType> {
    case Success(T)
    case Failure(Error)
    
    init(value: T) {
        self = .Success(value)
    }
    
    init(error: Error) {
        self = .Failure(error)
    }
}

enum RepositoryError: ErrorType {
    case GeneralError(message: String)
}

protocol RepositoryType {
    associatedtype Element
    associatedtype Query
    
    func all(complete: (Result<[Element], RepositoryError>) -> Void)
    func find(query: Query, complete: (Result<[Element], RepositoryError>) -> Void)
    func add(element: Element, complete: (Result<[Element], RepositoryError>) -> Void)
    func add(elements: [Element], complete: (Result<[Element], RepositoryError>) -> Void)
    func update(elements: [Element], complete: (Result<[Element], RepositoryError>) -> Void)
    func remove(query: Query, complete: (Result<[Element], RepositoryError>) -> Void)
}

struct AnyRepository<T, U, S: RepositoryType where S.Element == T, S.Query == U>: RepositoryType {
    typealias Element = T
    typealias Query = U
    typealias Repository = S

    private let _repository: S
    
    init(repository: S) {
        _repository = repository
    }
    
    func all(complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.all(complete)
    }
    
    func find(query: Query, complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.find(query, complete: complete)
    }
    
    func add(element: Element, complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.add(element, complete: complete)
    }
    
    func add(elements: [Element], complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.add(elements, complete: complete)
    }
    
    func update(elements: [Element], complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.update(elements, complete: complete)
    }
    
    func remove(query: Query, complete: (Result<[Element], RepositoryError>) -> Void) {
        _repository.remove(query, complete: complete)
    }
}