SCN-VR
======

This is a iOS 8.1+ static library for rendering VR content with SceneKit.

A Hello World demo has also been provided that has profile support.

Why does SCN-VR exist?
======

I did not want to pay for unity pro license, so I created this framework from the now defunct ALPS-VR for unity. 

Concerns
======

1.	I'm pretty sure the color correction shader has a problem.

Future Work
======

1.	I really want to rewrite the distortion mesh logic, so the fragment shader could do less.
2.	I really want to rewrite the eye logic, so you could more finely control where and how large each eye target is.  And also ensure they are always 1:1 ratio.
3.	Integrate google cardboard QR scanning
4.	Integrate Mobile VR Station’s profile editing screen into SCN-VR.  So it could be used as a linked Storyboard.

Other Projects
======

1. I'm porting SCN-VR to ThreeJS

Setting Up
======

1. Create a new Workspace
2. Create a new project
3. Add GLKit & SceneKit libraries to your project
4. Add SCN-VR library to your workspace
5. Link your project to SCN-VR
6. Setup user header search paths
7. Add SCN-VR's String files into your app

Useful Classes
======

Workflow
======

Supported Devices
======

*iOS 8.1+ is Required*

- iPhone 4S
- iPhone 5/S/C
- iPhone 6
- iPhone 6 Plus
- iPad 2+
- iPad Air
- iPad Mini

Supported HMDs
======

- None
 - Mono Or Side By Side Options
- Altergaze
 - Side By Side Eyes
 - Barrel Distortion
 - Color Correction
- Cardboard
 - Side By Side Eyes
 - Barrel Distortion
 - Color Correction

Special Thanks
======

Part of this library is based upon work done by http://www.alpsvr.com/ , please visit them for building VR Unity apps.
