<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!--
*** Thanks for checking out Cypheria. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/aradazr/Cypheria">
    <img src="assets/images/icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Cypheria</h3>

  <p align="center">
    Secure Encryption & Decryption App - Protect your data with AES-256 encryption
    <br />
    <a href="https://github.com/aradazr/Cypheria"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/aradazr/Cypheria/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/aradazr/Cypheria/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#screenshots">Screenshots</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#security">Security</a></li>
    <li><a href="#platform-support">Platform Support</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://github.com/aradazr/Cypheria)

Cypheria is a powerful, secure encryption application that allows you to encrypt and decrypt text, images, files, and audio files using AES-256 encryption. All processing happens locally on your device—your data never leaves your phone.

Here's why Cypheria stands out:
* 🔐 **Military-Grade Security**: Uses AES-256-CBC encryption algorithm
* 📱 **Works Offline**: No internet connection required for encryption/decryption
* 🔒 **Privacy First**: Your data never leaves your device
* 🌐 **Multi-Platform**: Available on Android, iOS, Web, Windows, macOS, and Linux
* 🎨 **Beautiful UI**: Modern dark and light themes with responsive design
* 🌍 **Multi-Language**: Supports Persian and English
* 💬 **Speech to Text**: Convert speech to text on Android devices

Of course, no encryption app is perfect, and we're always looking to improve. If you have suggestions or find bugs, please open an issue or submit a pull request!

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Features

* 🔐 **Encrypt Everything**: Text, images, files, and audio files
* 🔑 **Custom Keys**: Use your own encryption keys
* 🌐 **Unicode Support**: Full support for Persian, English, and other Unicode characters
* 🎨 **Modern UI**: Beautiful dark and light themes
* 📱 **Responsive**: Works on all screen sizes
* 🔄 **Easy Toggle**: Quick switch between encryption and decryption modes
* 📋 **Copy & Paste**: Easy text copying and transfer
* 🏗️ **Clean Architecture**: Maintainable and scalable codebase
* 🌐 **PWA Support**: Install on iPhone without App Store
* 📴 **Offline First**: Works completely offline after initial load
* 💬 **Speech to Text**: Voice input on Android (Persian and English)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

Major frameworks and libraries used in this project:

* [![Flutter][Flutter.dev]][Flutter-url]
* [![Dart][Dart.dev]][Dart-url]
* [![Provider][Provider.dev]][Provider-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Screenshots

> 💡 **Note**: Add screenshots of your application here

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Before you begin, ensure you have the following installed:
* Flutter SDK (version 3.10 or higher)
  ```sh
  flutter --version
  ```
* Dart SDK (comes with Flutter)
* Android Studio / VS Code with Flutter extension
* Git

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/aradazr/Cypheria.git
   cd Cypheria
   ```
2. Install dependencies
   ```sh
   flutter pub get
   ```
3. Run the app
   ```sh
   flutter run
   ```
4. Build for release
   ```sh
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

### Encrypting Text

1. Select **Encoding** mode (default)
2. Enter your encryption key (remember this key!)
3. Enter the text you want to encrypt
4. Click **Encode** button
5. Copy the encrypted text

### Decrypting Text

1. Select **Decoding** mode
2. Enter the same encryption key you used for encryption
3. Enter the encrypted text
4. Click **Decode** button
5. View the decrypted text

### Encrypting Images/Files/Audio

1. Select the appropriate tab (Image/File/Audio)
2. Choose encoding or decoding mode
3. Select the file from your device
4. Enter your encryption key
5. Click **Encode** or **Decode** button
6. Save or share the result

### Important Notes

* ⚠️ **Remember your key**: Without the encryption key, decryption is impossible
* ⚠️ **Same key required**: Use the same key for encryption and decryption
* ⚠️ **Key security**: Share your key only with trusted parties
* ✅ **Unicode support**: You can use Persian, English, and other Unicode characters

_For more information, visit the [GitHub repository](https://github.com/aradazr/Cypheria)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- SECURITY -->
## Security

### Encryption Algorithm

Cypheria uses **AES-256-CBC** encryption, which is an industry-standard encryption algorithm.

### Security Features

* ✅ AES-256 encryption algorithm
* ✅ Key derivation using SHA-256
* ✅ Deterministic IV generation
* ✅ All processing happens locally
* ✅ No data transmission to servers

### Security Warnings

* ⚠️ **Keep your key secret**: Never share your encryption key publicly
* ⚠️ **No key recovery**: We cannot recover lost keys
* ⚠️ **Source code is public**: The algorithm is visible, but without the key, data cannot be decrypted
* ⚠️ **For general use**: This app is designed for general and personal use. For highly sensitive data (like banking information), use additional security measures.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- PLATFORM SUPPORT -->
## Platform Support

* ✅ **Android** - Full support including speech-to-text
* ✅ **iOS** - Full support (speech-to-text disabled)
* ✅ **Web (PWA)** - Install on iPhone without App Store
* ✅ **Windows** - Full support
* ✅ **macOS** - Full support
* ✅ **Linux** - Full support

### Installing on iPhone (Without App Store)

Cypheria is a **Progressive Web App (PWA)** that you can install directly on your iPhone:

1. Open Safari
2. Navigate to the website
3. Tap the **Share** button (square with arrow)
4. Select **"Add to Home Screen"**
5. Now you can use the app **offline**! 🎉

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Text encryption/decryption
- [x] Image encryption/decryption
- [x] File encryption/decryption
- [x] Audio encryption/decryption
- [x] Dark and light themes
- [x] Persian and English support
- [x] Speech to text (Android)
- [x] PWA support
- [ ] Cloud backup (optional)
- [ ] Key management system
- [ ] Multi-language support (more languages)
- [ ] Biometric authentication
- [ ] Export/import encrypted files

See the [open issues](https://github.com/aradazr/Cypheria/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Top contributors:

<a href="https://github.com/aradazr/Cypheria/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=aradazr/Cypheria" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Arad Azarpanah - [@aradazarpanah](https://twitter.com/aradazarpanah) - aradazarpanah27@gmail.com

Project Link: [https://github.com/aradazr/Cypheria](https://github.com/aradazr/Cypheria)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Flutter Documentation](https://flutter.dev/docs)
* [Dart Language](https://dart.dev)
* [Provider Package](https://pub.dev/packages/provider)
* [Encrypt Package](https://pub.dev/packages/encrypt)
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Best README Template](https://github.com/othneildrew/Best-README-Template)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/aradazr/Cypheria.svg?style=for-the-badge
[contributors-url]: https://github.com/aradazr/Cypheria/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/aradazr/Cypheria.svg?style=for-the-badge
[forks-url]: https://github.com/aradazr/Cypheria/network/members
[stars-shield]: https://img.shields.io/github/stars/aradazr/Cypheria.svg?style=for-the-badge
[stars-url]: https://github.com/aradazr/Cypheria/stargazers
[issues-shield]: https://img.shields.io/github/issues/aradazr/Cypheria.svg?style=for-the-badge
[issues-url]: https://github.com/aradazr/Cypheria/issues
[license-shield]: https://img.shields.io/github/license/aradazr/Cypheria.svg?style=for-the-badge
[license-url]: https://github.com/aradazr/Cypheria/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/aradazr
[product-screenshot]: assets/images/icon.png
[Flutter.dev]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white
[Flutter-url]: https://flutter.dev
[Dart.dev]: https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white
[Dart-url]: https://dart.dev
[Provider.dev]: https://img.shields.io/badge/Provider-6.1.1-6366F1?style=for-the-badge
[Provider-url]: https://pub.dev/packages/provider
