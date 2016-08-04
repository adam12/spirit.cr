# Spirit
_Giving life to a user's daemons_

Lets be honest, I never started out wanting to make a process manager... I just
wanted to deploy my code and run my applications.

But I don't want the calling of `sudo` to be part of my deployment strategy, and
none of the other process managers fit my requirements (maybe I missed one - there
are already so many).

## Goals

- Light memory usage 
- Dependency free
- Single binary
- Single user
- INI file configuration
- Easy generation of boot scripts
- Run from crontab @reboot
- Non-forking processes only
- Memory status
- Simple HTTP check built in
- Preserve / discard stdio/stderr
- Custom restart/stop signals

## Installation


TODO: Write installation instructions here


## Usage

	spirit daemon

	spirit list
	spirit rescan

	spirit <instance> status|start|stop|restart
	spirit <instance> log|tail


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/adam12/spirit/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [adam12](https://github.com/adam12) Adam Daniels - creator, maintainer
