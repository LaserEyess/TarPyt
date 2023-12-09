project('tarpyt',
  license: 'GPL3+',
  version: '0.0.1',
  meson_version: '>=0.60.0')

find_program('python3', version: '>=3.11', required: true)
dependency('libsystemd', version: '>=247', required: true)

systemd_install_dir = get_option('libdir') / 'systemd' / 'system'

# Templated out service files
config_data = {'bindir': get_option('prefix') / get_option('bindir')}
foreach protocol: ['ssh', 'http', 'smtp']
  config_data += {'PROTOCOL': protocol}
  configure_file(input: 'tarpyt@.socket.in',
    output:'tarpyt-@0@@.socket'.format(protocol),
    configuration: config_data,
    install_dir: systemd_install_dir)

  configure_file(input: 'tarpyt@.service.in',
    output: 'tarpyt-@0@@.service'.format(protocol),
    configuration: config_data,
    install_dir: systemd_install_dir)
endforeach

install_data('tarpyt', install_dir: get_option('bindir'), install_mode: 'rwxr--r--')