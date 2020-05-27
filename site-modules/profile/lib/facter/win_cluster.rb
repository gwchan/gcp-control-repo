
Facter.add('Cluster Owner') do
  confine osfamily: :windows
  cowner = 'NA'

  cowner = Facter::Core::Execution.execute('powershell "Get-ClusterGroup -Name "Cluster Group" | Select -ExpandProperty "OwnerNode" | Select -ExpandProperty "Name""')
  
  setcode do
    cowner  
  end
end