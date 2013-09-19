# Proofer

Proofer runs the code sample present in your documentation to make sure
they work the way you intend.

Currently only supports markdown and ruby. But the sky is the limit. At least,
that's what Icarus told me.. moments before he flew too high and burst in to
flames. What a goon.

Proofer is NOT NOT NOT meant to replace unit tests, integration tests,
acceptence tests or any other kind of test. It is for ensuring that code
samples included in your documentation work as intended.

## Installation

Add this line to your application's Gemfile:

    gem 'proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proofer

## Usage

### Command Line

Run `bin/proofer`. If an filename argument is given, that file will be
processed and tested. If no filename is given it will search the current
directory for any markdown (*.md) files and attempt to run them.

### Code

You can load markdown from a file:

```ruby
  require 'rubygems' # only needed for 1.8.7 and older.
  require 'proofer'

  proofer = Proofer.from_file('./test.md')

  proofer.passed?
  # => true
```

You can also load it from a string:

```ruby
  require 'rubygems' # only needed for 1.8.7 and older.
  require 'proofer'

  proofer = Proofer.from_string('string of markdown')

  proofer.passed?
  # => true
  proofer.failed?
  # => false
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
