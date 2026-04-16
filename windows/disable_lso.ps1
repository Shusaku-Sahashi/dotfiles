# WSL2 has network performance issues when Large Send Offload (LSO) is enabled. This script disables LSO for all
# vEthernet adapters.
Get-NetAdapterAdvancedProperty -Name 'vEthernet*' |
  Where-Object { $_.DisplayName -like 'Large Send Offload*v4*' } |
  Set-NetAdapterAdvancedProperty -DisplayValue 'Disabled'
