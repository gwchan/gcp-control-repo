Facter.add('link_status') do
  confine :kernel => :windows 
  setcode do
     begin
      link_status = {}
        cmd_output = Facter::Core::Execution.exec('C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy remotesigned -Command "& { Get-WmiObject -class Win32_NetworkAdapter -ComputerName . | Where { $_.PhysicalAdapter } | Select-Object -Property  NetConnectionID,Netenabled,Speed,MACAddress,Name | convertto-csv|select-object -skip 2 | out-file -Encoding ASCII \"C:\Temp\link_status.txt\" }"')
        file_name = 'C:\Temp\link_status.txt' #. split("\n")   #.gsub(/\d.?000000000/,'Gbps').gsub(/\d.?000000/,'Mbps')
        if File.file?(file_name)
          #:encoding => 'utf-8'
          file_out = File.read(file_name).split("\n")
          
          file_out.each do |line|
            puts line
            item  = line.tr('"', '').split(',')
            link_status[item[0]] = {
              'Status'     => item[1].gsub(/True/,'Up'),
              'Speed' => (item[2].to_i / 1000000000).to_s + ' Gbps',
              'MacAddress' => item[3],
              'Name' => item[4]
            }
          end
        end
        # Clear Temp File
        clear_file = Facter::Core::Execution.exec('C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy remotesigned -Command "& { rm \"C:\Temp\link_status.txt\" }"')  
        link_status
        
      
     rescue StandardError => e
         # TODO
         e.message 
     end         
  end
end