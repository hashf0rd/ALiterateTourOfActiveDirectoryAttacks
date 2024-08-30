
## Overview
This series of notebooks is an attempt to explore and demonstrate how modern attacks against Active Directory work internally. Where possible the noteboks use PowerShell only - where this is not possible Python is used. The aim is to demonstrate each attack using code - no attack uses already established tooling such as Ruebus, Powersploit etc. Because of this, the code is __POC only__: no consideration has been given for performance, scalability, compatibility, or more importantly, operational security.

## Requirements
The labs require:
- [Hyper-V](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
- [Automatedlab](https://automatedlab.org/en/latest/)
- Windows Server ISOs

While the notebooks require:
- A Juypter notebook server
- The [.Net interactive kernel](https://github.com/dotnet/interactive)
- Alternatively, VSCode and the [Polyglot Notebook extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode) __(Recommended)__

## Starting a Lab
The scripts that build each lab utilise [Automatedlab](https://automatedlab.org/en/latest/). The scripts that configure each lab are based off of the [excellent work by Safebuffer](https://github.com/safebuffer/vulnerable-AD). 

The scripts to build each lab are named `Lab<chapter number>-<lab name>.ps1`, with each script calling the appropriate configuration script. Calling the appropriate `Lab<chapter number>-<lab name>.ps1` script should be all that is required to set up each lab.

Simply call the lab script for the lab you want to run, automatedlab will do the rest.

## Troubleshooting
If you need to close the lab and come back to it later do so by stopping the lab vm and closing the admin console: `Stop-LabVM <vm name>`.

Coming back to the lab later: `Import-Lab <labname>` and `Start-LavVM <vm name>`.

If you need to check the configuration on the lab machine for any reason, you can do this by running `Enter-PSLabSession <vm name>` from an admin console.

__Note:__ The lab scripts set up the lab machine as a DNS server for the virtualised network. You may find this causes a slight delay in your regular internet browsing. When not using the lab, disable the virtual network adapter with `Enable-NetAdapter vEther*`, and enable it again when you bring the lab machine back up: `Disable-NetAdapter vEther*`.

## Labs
1. [ACL Abuse](./1.%20ACL%20Abuse)
2. [GPO Abuse](./2.%20GPO%20Abuse)
3. [Kerberoasting](./3.%20Kerberoasting)
4. Targeted Kerberoast
5. ASREP Roast
6. ASREQ Roast
7. Timeroasting
8. Bronze Ticket
9. Silver Ticket
10. Golden Ticket
11. Diamond Ticket
12. Sapphire Ticket
13. Unconstrained Delegation
14. Constrained Delegation
15. Resource Based Constrained Delegation
16. S4u2self Abuse
17. Kerberos Relaying
18. Pass the Ticket
19. Overpass the Hash
20. Pass the Key
21. Pass the Cache (for linux)
22. UNPac the Hash
23. Encryption Downgrade
24. Skeleton Key
25. SAMAccountName Spoofing
26. SPN Jacking
27. Ticket Creation with SID History
28. Shadow Credentials
29. PrimaryGroupID Attack
