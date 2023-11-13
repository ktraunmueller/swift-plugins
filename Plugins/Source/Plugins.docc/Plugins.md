# ``Plugins``

A framework for managing units of functionality ("plugins").

## Overview

This framework provides facilities for registering and consuming functionality provided
by so-called _plugins_.

Plugins are the basic units of functionality. Think "separation of concerns".

### Plugins

The functionality provided by a plugin is formalized trough its
_plugin interface_. Here's a simple example of a plugin interface:

```swift
protocol AdderInterface {
    func add(lhs: Int, rhs: Int) -> Int
}
```

The implementation of the plugin interface is provided by a corresponding _plugin object_:

```swift
final class AdderObject: AdderInterface, PluginLifecycle {
    
    // MARK: AdderInterface

    func add(lhs: Int, rhs: Int) -> Int {
        return lhs + rhs
    }

    // MARK: PluginLifecycle

    private(set) var state: PluginState = .stopped

    func start() /*async*/ throws {
        state = .starting
        state = .started
    }

    func stop() /*async*/ throws {
        state = .stopping
        state = .stopped
    }
}
```

The concrete types of plugin objects are not exposed to clients, however: 
clients only ever interact with plugin objects through the corresponding 
plugin interface. In order to acchieve this, _plugin handles_ are introduced
as a man-in-the-middle.

### The Plugin Registry

Plugins 

### The Plugin Lifecycle

### Plugin Handles

Plugin handles serve two purposes:

- They hide the concrete plugin object type from clients (clients only see
  the _plugin interface_ type).
- They handle the plugin lifecycle. If a client wants to interact
  with a plugin, and the plugin is not yet in the started state, it will be
  transparently started by the plugin handle before it can be used by a client.

## Topics

### asd

asasdas
