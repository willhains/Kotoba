# Kotoba Installation

**Note:** An Apple Developer account is required.

## Build and Run on iPhone or iPad

1. Clone or download [Kotoba from GitHub](https://github.com/willhains/Kotoba).
2. Open `code/Kotoba.xcodeproj` in Xcode.
3. Select the Kotoba project file in Navigator, select the "Kotoba" target, then select the "Signing & Capabilities" tab.
4. Change the "Team" to your Apple Developer account team.
5. Open the "Devices and Simulators" window (Shift-Cmd-2) and confirm your device is connected. If not, connect it via USB.
6. Product > Run.


## Set Up iCloud Sync

Create an app identifier on the [developer portal](https://developer.apple.com/account/resources/identifiers/list):

1. Register a new Identifier

	+ Platform: iOS
	+ App ID Prefix: Pick the one that has Team ID
	+ Description: Kotoba
	+ Bundle ID: com.willhains.Kotoba

2. Select capabilities

	+ iCloud / Include CloudKit support (requires Xcode 6)
	+ If you get an error about bundle ID not being available, go Back and change it to something unique like com.yourdomain.Kotoba, then try again. You'll need to change the Xcode project to use the same bundle ID. You'll lose all previous word history at this point, because the words are stored in the app with the old bundle identifier. Yay provisioning.

3. Register

4. Back in Xcode, on the "Signing & Capabilities" tab of the "Kotoba" target, click the + icon to add iCloud.

5. Make sure "Key-value storage" is turned on.
