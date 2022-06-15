# Innoreader Plasmoid

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

Download the latest version of plasmoid from [KDE Store](https://store.kde.org/p/1829436/) or [release page](https://github.com/korapp/plasma-inoreader/releases)

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
git clone https://github.com/korapp/plasma-inoreader.git
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
