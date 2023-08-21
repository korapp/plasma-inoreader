# Inoreader Plasmoid

[![plasma](https://img.shields.io/static/v1?message=KDE%20Store&color=54a3d8&logo=kde&logoColor=FFFFFF&label=)][kdestore]
[![downloads](https://img.shields.io/github/downloads/korapp/plasma-inoreader/total)][releases]
[![release](https://img.shields.io/github/v/release/korapp/plasma-inoreader)][releases]

Plasma applet for [Inoreader](https://innoreader.com).

![Plasmoid full view](preview.jpg)

## Features

* Unread count in compact representation
* Marking as read/unread and starrign articles
* Option for stripping images from summary
* Multiple views

## Use

According to free API limits it is necessary that user registers own app and acquire appId and appKey to put in plasmoid's configuration.
It can be done on [Inoreader account preferences page](https://www.inoreader.com/?show_dialog=preferences_dialog&params={set_category:%27preferences_developer%27,ajax:true}).

## Requirements

* Active KDE Wallet
* Qt >= 5.14, KDE Frameworks >= 5.77, KDE Plasma >= 5.19 (e.g. Kubuntu 21.04 and newer)

## Installation

The preferred and easiest way to install is to use Plasma Discover or KDE Get New Stuff and search for *Inoreader*.

### From file

Download the latest version of plasmoid from [KDE Store][kdestore] or [release page][releases]

#### A) Plasma UI

1. Right click on panel or desktop
2. Select *Add Widgets > Get New Widgets > Install From Local File*
3. Choose downloaded plasmoid file

#### B) Terminal

```sh
plasmapkg2 -i plasma-inoreader-*.plasmoid
```

### From GitHub

Clone repository and go to the project directory

```sh
git clone --recurse-submodules https://github.com/korapp/plasma-inoreader.git
cd plasma-inoreader
```

Install

```sh
plasmapkg2 -i package
```

## Support

Say thank you with coffee ☕ if you'd like.

[![liberapay](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/korapp/donate)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/korapp)
[<img src="https://img.shields.io/badge/Revolut-white?logo=Revolut&logoColor=black" height="30"/>](https://revolut.me/korapp)

[kdestore]: https://store.kde.org/p/1829436/
[releases]: https://github.com/korapp/plasma-inoreader/releases