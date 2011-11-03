HSBackspaceFriendlyTextField
============================

**This code is dangerous, and likely to break on minor system updates.
Use at your own risk.**

This project shows how to detect when the user hits the backspace
key at the beginning of a `UITextField`. There is no publicly exposed
mechanism for doing this, so `HSBackspaceFriendlyTextField` uses some
runtime wizardry to subclass an internal UIKit class in order to detect
the backspace keypress.

This mechanism is obviously not Apple-approved. I have tested it on
iOS 5.0. I make no guarantee about compatibility with future iOS releases,
compatibility with the App Store Review Guidelines, or anything else. I've
tried to make it fail gracefully, but I cannot anticipate everything Apple
might do in the future.

The license on this code is quite simple:

 - Use it however you like.
 - No attribution required.
 - No contributor to this code shall be held liable for any defects, faults,
   etc. relating to the use of this code. Use at your own risk.