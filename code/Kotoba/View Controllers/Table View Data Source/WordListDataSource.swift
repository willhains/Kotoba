//
//  WordListDataSource.swift
//  Kotoba
//
//  Created by Gabor Halasz on 19/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
import CoreData

final class WordListDataSource: NSObject
{
	let contextProvider: ContextProvider
	let fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>
	weak var delegate: TableViewDataSourceDelegate?
	var allowRowEdit: Bool = true
	
	init(request: NSFetchRequest<NSFetchRequestResult>, contextProvider: ContextProvider)
	{
		self.contextProvider = contextProvider
		self.fetchResultsController = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: contextProvider.mainContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		super.init()
		try? fetchResultsController.performFetch()
		fetchResultsController.delegate = self
	}
}

extension WordListDataSource: TableViewDataSource
{
	// MARK:- displaying data
	func numberOfSections(in tableView: UITableView) -> Int
	{
		guard let sectionCount = fetchResultsController.sections?.count else { return 0 }
		return sectionCount
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		guard let tableViewSection = fetchResultsController.sections?[section] else { return 0 }
		return tableViewSection.numberOfObjects
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let cellID = delegate?.cellIdentifier(for: indexPath) else { fatalError("No cell type registered for given IndexPath") }
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		delegate?.configure(cell: cell, with: fetchResultsController.object(at: indexPath), at: indexPath)
		return cell
	}
	
	// MARK:- editing data
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return allowRowEdit }
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete
		{
			deleteObject(at: indexPath)
		}
	}
	
	// MARK:- getting object
	func object(at indexPath: IndexPath) -> NSFetchRequestResult
	{
		return fetchResultsController.object(at: indexPath)
	}
}

extension WordListDataSource
{
	private func deleteObject(at indexPath: IndexPath)
	{
		guard let dictionaryQuery = fetchResultsController.object(at: indexPath) as? NSManagedObject else { return }
		let id = dictionaryQuery.objectID
		DispatchQueue.global(qos: .default).async
		{
			[unowned self] in
			let context = self.contextProvider.backgroundContext
			let backgroundDictionaryQuery = context.object(with: id)
			context.makeChanges
			{
				context.delete(backgroundDictionaryQuery)
			}
		}
	}
}

extension WordListDataSource: NSFetchedResultsControllerDelegate
{
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
		delegate?.currentTableView()?.beginUpdates()
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath: IndexPath?)
	{
		if type == .delete
		{
			delegate?.currentTableView()?.deleteRows(at: [indexPath!], with: .automatic)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
		delegate?.currentTableView()?.endUpdates()
	}
}
