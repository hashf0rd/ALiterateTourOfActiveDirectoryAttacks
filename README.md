## Overview
This series of notebooks is an attempt to explore and demonstrate how modern attacks against Active Directory work internally. Where possible the noteboks use PowerShell only - where this is not possible Python is used, specifically the Impacket library. The aim is to demonstrate the internals of each attack via code, without using already established tooling such as Ruebus, Powersploit etc. Because of this, the code is __POC only__: no consideration has been given for performance, scalability, compatibility, or more importantly, operational security.

## Requirements
The labs require:
- [Hyper-V](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
- [Automatedlab](https://automatedlab.org/en/latest/)
- Windows Server ISOs (these labs were developed against __Windows Server 2019 Standard (Desktop Experience)__)

While the notebooks require:
- A Juypter notebook server and the [.Net interactive kernel](https://github.com/dotnet/interactive)
- A Juypter notebook frontend such as Juypterlab
- The specific frontend used to develop these labs was VSCode with the [Polyglot Notebook extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode)

## Virtualisation Options
If you wish to use a different hypervisor to Hyper-v, the lab configuration scripts for the most part work standalone - simply build your virtual environment 

## Starting a Lab
The scripts that build each lab utilise [Automatedlab](https://automatedlab.org/en/latest/). The scripts that configure each lab are based off of the [excellent work by Safebuffer](https://github.com/safebuffer/vulnerable-AD) and the [Orange Cyberdefense team](https://github.com/Orange-Cyberdefense/GOAD/tree/main/ad/GOAD/scripts). 

The scripts to build each lab are stored in the `Labs` folder and are individually named `Lab<chapter number>-<lab name>.ps1`, with each script then calling a corresponding configuration script stored in the `Labs\Lab-Configuration` folder. Calling the appropriate `Lab<chapter number>-<lab name>.ps1` script should be all that is required to set up each lab.

Simply call the lab script for the lab you want to run, Automatedlab will do the rest.

## Troubleshooting
If you need to close the lab and come back to it later do so by stopping the lab vm and closing the admin console: `Stop-LabVM <vm name>`.

Coming back to the lab later: `Import-Lab <labname>` and `Start-LavVM <vm name>`.

If you need to check the configuration on the lab machine for any reason, you can do this by running `Enter-PSLabSession <vm name>` from an admin console.

__Note:__ The lab scripts set up the lab machine as a DNS server for the virtualised network. You may find this causes a slight delay in your regular internet browsing. When not using the lab, disable the virtual network adapter with `Enable-NetAdapter vEther*`, and enable it again when you bring the lab machine back up: `Disable-NetAdapter vEther*`. Alternatively, a simpler solution is to set a custom DNS provider in your browsers DNS-over-HTTPS settings.

Alternatively, look for the vEther* virtual interfaces using `Get-NetIPInterface` and change the interface priority so its lower than the interface you use for web browsing with `Set-NetIPInterface vEther* -InterfaceMetric 45` (if for example, the output of `Get-NetIPInterface` showed your primary interface as having an interfacemetric of 35).

## Labs
1. [ACL Abuse](./1.%20ACL%20Abuse)
2. [GPO Abuse](./2.%20GPO%20Abuse)
3. [Kerberoasting](./3.%20Kerberoasting)
4. [Targeted Kerberoast]()
5. [ASREP Roast]()
6. [ASREQ Roast]()
7. [Timeroasting]()
8. [Bronze Ticket]()
9. [Silver Ticket]()
10. [Golden Ticket]()
11. [Diamond Ticket]()
12. [Sapphire Ticket]()
13. [Unconstrained Delegation]()
14. [Constrained Delegation]()
15. [Resource Based Constrained Delegation]()
16. [S4u2self Abuse]()
17. [Kerberos Relaying]()
18. [Pass the Ticket]()
19. [Overpass the Hash]()
20. [Pass the Key]()
21. [UNPac the Hash]()
22. [Encryption Downgrade]()
23. [Skeleton Key]()
24. [SAMAccountName Spoofing]()
25. [SPN Jacking]()
26. [Ticket Creation with SID History]()
27. [Shadow Credentials]()
28. [PrimaryGroupID Attack]()
