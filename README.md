# What is this?

html_validator_pack in

- [tidy-html5](https://github.com/w3c/tidy-html5)
- [CSSTidy(PHP)](https://github.com/Cerdic/CSSTidy)
- [csstidy(CLI Interface)](https://gist.github.com/etienned/2789689)
- [javascriptlint](https://github.com/davepacheco/javascriptlint)

# Operation

1. Find current directory on *.(html|css|js|php) create validate filelist
1. if exist excludeslist grep action
1. make [tidy-html5](https://github.com/w3c/tidy-html5)
1. make [javascriptlint](https://github.com/davepacheco/javascriptlint)
1. read filelist
1. validate html,css,js,php

# Requirement

CentOS release 6.4 (Final)

* gcc
* python-devel
* php

MacOS X

* Xcode
* MacPorts

# Usage

**running on html_validator_pack non-required root privileges**

```
cd <validate_html_dir>
git clone --recursive git@github.com:INSANEWORKS/html_validator_pack.git
./html_validator_pack/check.sh
```
