import Foundation
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions)
	{
		guard let windowScene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: windowScene)

		let rootView = AddWordView(
			wordSuggestionsModel: WordSuggestionsModel(
				pasteboard: RealPasteboard(pasteboard: UIPasteboard.general),
				userDefaults: .standard))

		window?.rootViewController = UIHostingController(rootView: rootView)
		window?.makeKeyAndVisible()
	}
}
