# fluent-plugin-json-extractor

[Fluentd](https://fluentd.org/) filter plugin to extract data from json

Plugin allows to select node and extract all data from node outside as new object. 

## Installation

### RubyGems

```
$ gem install fluent-plugin-json-extractor
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-json-extractor"
```

And then execute:

```
$ bundle
```

## Configuration

There is only one porperty to set:
- extract_key: this is a name of key. All data inside that key will be extracted.

You can generate configuration template:

```
$ fluent-plugin-config-format filter json-extractor
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2022- skoczo
* License
  * Apache License, Version 2.0
