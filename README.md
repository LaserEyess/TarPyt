# TarPyt: a Python ssh/http/smtp/etc. tarpit

TarPyt takes its inspiration from [Endlessh: an SSH Tarpit](https://nullprogram.com/blog/2019/03/22/).
Specifically, the very last section about using
[Python's asyncio libtrary](https://docs.python.org/3/library/asyncio.html).
There are two projects I can see like this one:

 - [endlessh](https://github.com/skeeto/endlessh)
 - [tarssh](https://github.com/Freaky/tarssh)

Both of them probably do a better job than me explaining the specifics of the problem, so I encourage
you to read the blog post and the README's of those other projects.

## !! WARNING !!
By design, this program will wait on an open port on your system and *unconditionally* accept
random connections from *anywhere* on the internet. This is done without encryption, authorization,
or authentication. Obviously, this is dangerous in almost all circumstances; especially if you
don't know what you're doing! The design goals below go over the protections in place that make
this "safe" to use, but make no mistake: this is a **risk**. You must accept that risk before
running TarPyt! You have officially been warned.

## Design Goals
This program is _**extremely**_ opinionated in its design, extra features outside of the following
goals will not be added.

 1. This program is designed to be run as a highly sandboxed systemd socket-activated service. This
    is because systemd will handle resource control, namespacing, privilege dropping, and most
    importantly binding to any port without running as root or using capabilities. TarPyt will
    merely accept a socket at instantiation, and use that socket for its entire lifetime. It does
    not handle anything beyond merely receiving this socket and being used as a tarpit.
 2. This program is written for Python `>=3.11` and **only** uses the standard library. This
    allows for easy portability and installation on any system that runs systemd and Python, which
    should cover the vast majority of Linux installations. Older versions of Python will not work.
 3. Python is used for its easy of development and quick auditing, but typing will be
    strictly enforced. The combination of systemd sandboxing, Python's memory safety as an
    interpreted language, and typing makes TarPyt (in theory) very safe as a tarpit.

The supported platforms are exclusively any not-so-old Linux distribution that uses systemd `>=247`
and Python `>=3.11`.

## Requirements
Building (configuring and installing) is done with `meson`. A version `>= 0.60.0` is required.

For testing, a couple of other utils are needed:

 - `curl`: for `test/test_http.sh`
 - `openssh`: for `test/test_ssh.sh`

For runtime:

 - `systemd >=247`: as well as `libsystemd.so` which should be present on any system running
    systemd
 - `Python >= 3.11`: The standard library is all that is required

## Building & Installing
Using meson:

```sh
meson setup --prefix="$prefix" "$builddir"
meson install -C "$buildtir"
```

## Usage
TarPyt is supposed to be exclusively used as a systemd socket-activated service. To run an ssh tarpit
you would do

```sh
systemctl enable --now tarpyt-ssh@22.socket
```

To run an http tarpit you would do
```sh
systemctl enable --now tarpyt-http@80.socket
```

Obviously, your filewall needs to have these ports open, or no connections will be received.

## Configuration
Because systemd is handling the socket, there is very little to configure at this time. Though
specific timeouts could be configured per connection type and per port.

## License
TarPyt is licensed under the terms of the GNU Public License v3 (or Later) (GPLv3+). See
[LICENSE](./LICENSE) for more information.