import Flutter
import MessageUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate,
  MFMessageComposeViewControllerDelegate
{
  private var pendingSmsResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    registerTrustedSupportChannel()
    registerICloudKvStoreChannel()

    return didFinish
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func registerTrustedSupportChannel() {
    guard let registrar = registrar(forPlugin: "TrustedSupportComposePlugin") else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "avoid_todo/trusted_support",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "composeSms":
        self.composeSms(call: call, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func registerICloudKvStoreChannel() {
    guard let registrar = registrar(forPlugin: "ICloudKvStorePlugin") else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "avoid_todo/icloud_kv_store",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isAvailable":
        result(FileManager.default.ubiquityIdentityToken != nil)
      case "getString":
        guard
          let arguments = call.arguments as? [String: Any],
          let key = arguments["key"] as? String
        else {
          result(nil)
          return
        }
        result(NSUbiquitousKeyValueStore.default.string(forKey: key))
      case "setString":
        guard
          let arguments = call.arguments as? [String: Any],
          let key = arguments["key"] as? String,
          let value = arguments["value"] as? String
        else {
          result(false)
          return
        }
        let store = NSUbiquitousKeyValueStore.default
        store.set(value, forKey: key)
        result(store.synchronize())
      case "remove":
        guard
          let arguments = call.arguments as? [String: Any],
          let key = arguments["key"] as? String
        else {
          result(false)
          return
        }
        let store = NSUbiquitousKeyValueStore.default
        store.removeObject(forKey: key)
        result(store.synchronize())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func composeSms(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard pendingSmsResult == nil else {
      result("error")
      return
    }

    guard MFMessageComposeViewController.canSendText() else {
      result("unavailable")
      return
    }

    guard
      let arguments = call.arguments as? [String: Any],
      let recipient = arguments["recipient"] as? String,
      let body = arguments["body"] as? String
    else {
      result("error")
      return
    }

    guard let presenter = topViewController() else {
      result("error")
      return
    }

    let composer = MFMessageComposeViewController()
    composer.messageComposeDelegate = self
    composer.recipients = [recipient]
    composer.body = body

    pendingSmsResult = result
    DispatchQueue.main.async {
      presenter.present(composer, animated: true)
    }
  }

  func messageComposeViewController(
    _ controller: MFMessageComposeViewController,
    didFinishWith result: MessageComposeResult
  ) {
    controller.dismiss(animated: true)

    let flutterResult = pendingSmsResult
    pendingSmsResult = nil

    switch result {
    case .cancelled:
      flutterResult?("cancelled")
    case .sent:
      flutterResult?("sent")
    case .failed:
      flutterResult?("error")
    @unknown default:
      flutterResult?("error")
    }
  }

  private func topViewController(base: UIViewController? = nil) -> UIViewController? {
    let root = base ?? activeWindow()?.rootViewController
    if let navigationController = root as? UINavigationController {
      return topViewController(base: navigationController.visibleViewController)
    }
    if let tabBarController = root as? UITabBarController {
      return topViewController(base: tabBarController.selectedViewController)
    }
    if let presented = root?.presentedViewController {
      return topViewController(base: presented)
    }
    return root
  }

  private func activeWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap(\.windows)
        .first(where: \.isKeyWindow)
    }
    return window
  }
}
