# SeatFindr
SeatFindr app for the 2022 Tan Kah Kee Young Inventor's Award project.

## Background
> For this project, the task was to create a mobile app that could link to an Arduino via its bluetooth module, the HC-05.
> One way to create the app would be to use the MIT app inventor. However, after considering cross-platform functionalities and the freedom in being able to design the app exactly how I wanted it to be, I decided to use the Flutter framework.

## Description
> This app is created using the Flutter framework, coded in the programming language, Dart.
> It makes use of the flutter_bluetooth_serial module to communicate wirelessly with the HC-05 from the Arduino.
> Codes for both the front and back end of the app can be found under TKKYIA App Development -> seatfindr -> lib

1) On the Home Page, a simple swipe up motion is required to enter the app.

<img src="https://user-images.githubusercontent.com/81336452/168464832-2d2daff5-3ee3-465a-9a29-339a7aa2d1bd.jpg" width="300" height="650">


2) Upon entering the app, a Menu Page is displayed. Here, a list of all hawker centres in Singapore can be found.

<img src="https://user-images.githubusercontent.com/81336452/168464833-711980a4-e2f0-46cc-b817-3c138c5252e9.jpg" width="300" height="650">


a) Holding on a hawker centre widget will save the hawker centre into a Saved Page. The heart icon on the right of the hawker centre will also turn red, to indicate that it has been saved. Holding on a saved hawker centre widget will revert its status back to unsaved.

<img src="https://user-images.githubusercontent.com/81336452/168464834-a6854525-278f-451d-8d70-509a49ed2f54.jpg" width="300" height="650">

b) Clicking on the "Heart" icon at the top right corner of the page brings the user to the Saved Page. Here, a list of saved hawker centres will be displayed.

<img src="https://user-images.githubusercontent.com/81336452/168464883-38f164b7-5b79-4a22-b409-03c2a29b9c1b.jpg" width="300" height="650">

3) Clicking on a hawker centre widget, either in the Menu Page or the Saved Page, will bring the user to a Connection Page. A list of Bluetooth devices is displayed. The user will need to click on the device that corresponds to the hawker centre that they are in. In this case, the user will click on "Seatfindr".

<img src="https://user-images.githubusercontent.com/81336452/168464963-a043acc3-b4b2-418c-b313-8d5c57f72ea4.jpg" width="300" height="650">

4) Upon clicking on the device, the user is brought to the Layout Page. The layout of the hawker centre is displayed, with each shape representing a table in the hawker centre. Squares on the app represent square tables, while circles represent circular tables, and so on. Each table has a number within them, to represent the number of available seats. They are also represented with a colour, with green to signify that it is clean and ready for use, and red to signify that they are dirty.

<img src="https://user-images.githubusercontent.com/81336452/168465053-655d6375-b58e-4868-8160-6df4bdbe4720.jpg" width="650" height="300">
