
Facter.add('cluster_owner') do
  confine osfamily: :windows
  cowner = 'NA'

  setcode do
    cowner = Facter::Core::Execution.execute('powershell "(Get-ClusterGroup -Name \"Cluster Group\" | Select -ExpandProperty \"OwnerNode\" | Select -ExpandProperty \"Name\")"')
    cowner  
  end
end

Facter.add('cluster_is_owner') do
  confine osfamily: :windows
  cowner = 'NA'
  result = 'No'

  setcode do
    cowner = Facter::Core::Execution.execute('powershell "(Get-ClusterGroup -Name \"Cluster Group\" | Select -ExpandProperty \"OwnerNode\" | Select -ExpandProperty \"Name\")"')
    if Facter.value(:hostname) == cowner
      result = 'Yes'
    end
    
    result  
  end
end