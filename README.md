# iwantmyflog

**iwantmyflog** is a script which allows you to download all the *posts* from a given fotolog account.

## Operating Systems

* Linux
* OS X

## Prerequisites

* curl
* wget
* ruby 2.2.3+ ([installation guide](https://gorails.com/setup/) - just follow the steps up to the *Installing Ruby* section)
* bundler gem (`$ gem install bundler
`)
* nokogiri gem ([installation guide](http://www.nokogiri.org/tutorials/installing_nokogiri.html)

## Installation

```console
git clone https://github.com/cfsottile/iwantmyflog.git
cd iwantmyflog
bundle install
```

## Usage

```
bundle exec ruby iwantmyflog.rb your_fotolog_username
```

This will create a directory with a name like `xxxxxxxxxx-your_fotolog_username` whitin the script's one. Inside it, you will find two directories: `resources` and `posts`. `posts` includes symbolic links to the actual posts stored in `resources`. To open a post, which are identified by its fotolog post id, you just open the link in the directory `posts`.

## Considerations

* The script assumes your Internet connection is OK. If not, I can't tell what's the behavior because it is not tested.
* If, for any reason, the script doesn't complete its task, you'll have to start from scratch and download all the posts again.

## License

The MIT License (MIT)

Copyright (c) 2016 Cristian Sottile

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.