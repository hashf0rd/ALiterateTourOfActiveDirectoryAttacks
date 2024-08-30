
## Overview

## Starting A Lab
The scripts that build each lab utilise [Automatedlab](https://automatedlab.org/en/latest/). The scripts that configure each lab are based off of the [excellent work by Safebuffer](https://github.com/safebuffer/vulnerable-AD). The scripts to build each lab are named <b>Lab\<chapter number\>-\<lab name\>.ps1</b>, with each script calling the appropriate configuration script. Calling the <b>Lab\<chapter number\>-\<lab name\>.ps1</b> script should be all that is required to set up each lab.

Simply call the lab script for the lab you want to run, automatedlab will do the rest.

## Requirements
- [Hyper-V](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
- [RSAT: Active Directory Domain Services and Lightweight Directory Services Tools](https://www.microsoft.com/en-gb/download/details.aspx?id=45520)
- [Automatedlab](https://automatedlab.org/en/latest/)
- Windows Server ISOs

## Troubleshooting
Import-Lab \<labname\>
Enter-PSLabSession \<usually _DC01_\>
Enable-NetAdapter vEther* and Disable-NetAdapter vEther*

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