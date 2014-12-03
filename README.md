# MDPSplitView
An `NSSplitView` subclass that provides a method to animate the position of a divider in a way that works with Auto Layout.

## Usage
`MDPSplitView` adds a single method: `setPosition:ofDividerAtIndex:animated:`. This mirror’s `NSSplitView`’s `setPosition:ofDividerAtIndex:`, but adds an option to animate the position.

In order to implement a minimum-width collapsing behavior, you’ll need to manually add and remove your width constraint when you move the divider. See the included demo project for an example.

## Setup
To add `MDPSplitView` to your project:

1. Add the repository as a submodule (`git submodule add https://github.com/mdiep/MDPSplitView [<path>]`) or download `MDPSplitView.h` and `MDPSplitView.m`.
2. Add `MDPSplitView.h` and `MDPSplitView.m` to your project and target in Xcode.

## Credits
This wouldn’t be possible without the help of @robrix. :sparkles:

## License
Available under the [MIT License](LICENSE.md).
