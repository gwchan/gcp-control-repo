Facter.add('datacenter') do
  setcode do
    if Facter.value(:hostname)[-1,1]  == 1
        'PDC'
    elsif
        'SDC'
    end
  end
end