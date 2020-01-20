require 'facter'

def decode(data, key)
  map = 'BCDFGHJKMPQRTVWXY2346789'.split('')
  raw = []
  i = 52
  while i < 67
    raw << data[i]
    i += 1
  end
  i = 28
  while i >= 0
    if ((i + 1) % 6).zero?
      key[i] = '-'
    else
      k = 0
      j = 14
      while j >= 0
        k = (k * 256) ^ raw[j].to_i
        raw[j] = (k / 24)
        k %= 24
        key[i] = map[k]
        j -= 1
      end
    end
    i -= 1
  end
  key.to_s.gsub(%r{\\CurrentVersion}, '')
end

Facter.add('windows_productkey') do
  confine kernel: :windows

  if Facter.value(:kernel) == 'windows'
    productkey = 'unknown'
    begin
      if RUBY_PLATFORM.downcase.include?('mswin') || RUBY_PLATFORM.downcase.include?('mingw32')
        require 'win32/registry'
        access = Win32::Registry::KEY_READ | 0x100
        key = 'Software\Microsoft\Windows NT\CurrentVersion'
        Win32::Registry::HKEY_LOCAL_MACHINE.open(key, access) do |reg|
          reg.each do |name, _type, data|
            productkey = if name.eql?('DigitalProductIdMAK')
                           data
                         elsif name.eql?('DigitalProductId') && Facter.value(:windows_systemtype) == 'x86'
                           decode(data, key)
                         elsif name.eql?('DigitalProductId4') && Facter.value(:windows_systemtype) == 'x64'
                           decode(data, key)
                         else
                           'unknown'
                         end
          end
        end
      end
    rescue
      # do nothing but comment
      nil
    end

    setcode do
      productkey
    end
  end
end

Facter.add('windows_sid') do
  confine osfamily: :windows

  if Facter.value(:kernel) == 'windows'
    sid = 'unknown'
    begin
      if RUBY_PLATFORM.downcase.include?('mswin') || RUBY_PLATFORM.downcase.include?('mingw32')
        require 'win32/registry'
        access = Win32::Registry::KEY_READ | 0x100
        Win32::Registry::HKEY_LOCAL_MACHINE.open('Software\Microsoft\Windows\CurrentVersion\Group Policy', access) do |reg|
          reg.keys.each do |key|
            if key.start_with?('S-1-5-21')
              sid = key.gsub(%r{-500$}, '')
            end
          end
        end
      end
    rescue
      nil
    end
  end

  setcode do
    sid
  end
end

Facter.add('windows_ad_domain') do
  confine osfamily: :windows
  setcode do
    begin
      require 'win32ole'
      wmi = WIN32OLE.connect('winmgmts:\\\\.\\root\\cimv2')
      foo = wmi.ExecQuery('SELECT * FROM Win32_ComputerSystem').each.first
      foo.Domain
    rescue
      # do nothing but comment
      nil
    end
  end
end

Facter.add('windows_powershell') do
  confine osfamily: :windows
  powershell = {}
  setcode do
    powershell['major'] = Facter::Core::Execution.execute('powershell $PSversiontable.psversion.major')
    powershell['minor'] = Facter::Core::Execution.execute('powershell $PSversiontable.psversion.minor')
    powershell
  end
end

Facter.add('windows_features') do
  confine osfamily: :windows
  setcode do
    Facter::Core::Execution.execute('powershell "(Get-WindowsFeature | Where-Object {$_.Installed -match \"True\"} | Select-Object -expand Name) -join \",\""').split(',')
  end
end