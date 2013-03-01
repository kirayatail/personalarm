#Personalarm release notes
###Description
This iPhone application serves as a personal alarm and connects to the PersonAlarm web service. Please note that the software is in pre-release state and should not be considered ready for public deployment.

###Install guidelines
The provided .ipa is signed for use by authorized developers with specially registered testing devices. The .ipa is ready for deployment using TestFlight. If you're not part of the original dev team, please use your own Apple Developer License and compile the sources instead.

###Bug reporting
Please use the GitHub issue tracker to post any bugs or issues found. <https://github.com/kirayatail/personalarm/issues>

##v0.2
Phone-related issues solved

###Features

 * + Ability to choose a contact from the contact book.
 * + Phone numbers with spaces and dashes are accepted and reformatted automatically.

###Bug fixes

 * ~ App responds to bad input and prompts the user to review the number to be saved if it contains anything but a valid phone number.

###Known bugs
 [None reported]

##v0.1
Simple page-based gui with a trigger button. and calling service

###Features 

 * Specify a number to call in the settings and that number is saved for later.
 * Trigger the alarm and the phone will call the saved number.

###Known bugs

 * Number saving feature will accept any string, which may lead to malfunction or crash