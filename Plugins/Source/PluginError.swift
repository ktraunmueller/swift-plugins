/// Errors thrown by the plugin registry or plugin objects.
public enum PluginError: Error {
    case internalError
    // TODO get rid (we're exposing internals here)
    case pluginObjectDoesNotImplementPluginInterface
    // TODO get rid (we're exposing internals here)
    case pluginObjectDoesNotImplementPluginLifecycle
    case notRegistered
    case alreadyRegistered
    case couldNotBeStarted
}
