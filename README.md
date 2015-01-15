# MDPSplitView
An `NSSplitView` subclass that provides a method to animate the position of a divider in a way that works with Auto Layout.

## Usage
`MDPSplitView` adds a single method: `setPosition:ofDividerAtIndex:animated:`. This mirrors `NSSplitView`’s `setPosition:ofDividerAtIndex:`, but adds an option to animate the position.

In order to implement a minimum-width collapsing behavior, you’ll need to manually add and remove your width constraint when you move the divider. See the included demo project for an example.

## Setup
To add `MDPSplitView` to your project:

1. Add the repository as a submodule (`git submodule add https://github.com/mdiep/MDPSplitView [<path>]`).
2. Add `MDPSplitView.framework` to your project in Xcode.
3. Add `MDPSplitView.framework` to the _Link Binary With Libraries_ section of your target’s _Build Phases_.
4. Add `MDPSplitView.framework` to a _Copy Files_ build phase that copies into the `Frameworks` directory.

Or you can use [Carthage](https://github.com/Carthage/Carthage/).

## Credits
This wouldn’t be possible without the help of [@robrix](https://github.com/robrix). :sparkles:

## License
Available under the [MIT License](LICENSE.md).
