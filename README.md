# azure-utilities

This repository contains a collection of Azure automation scripts to help you manage and deploy various Azure resources. Each script is documented with clear instructions on usage, prerequisites, and expected outcomes.

## Getting Started

### Prerequisites

- Azure CLI installed and configured
- Active Azure subscription
- Bash shell environment (Linux, macOS, or Windows with WSL/Git Bash)
- PowerShell 7.0+ (for PowerShell scripts)

### General Usage Steps

1. Clone this repository:

   ```
   git clone https://github.com/geekobueno/azure-utilities.git
   cd azure-utilities
   ```

2. Navigate to the script directory you want to use:

   ```
   cd directory
   ```

3. Make the script executable (for Bash scripts):

   ```
   chmod +x script-name.sh
   ```

4. Login to your Azure account:

   ```
   az login
   ```

5. Review and modify any script-specific variables before running

6. Run the script:
   ```
   ./script-name.sh
   # or
   pwsh script-name.ps1
   ```

## Script Documentation

Each script directory contains:

- The script file(s)
- A README.md with detailed documentation
- Sample output files (when applicable)
- Any supporting configuration files

## Security Best Practices

- **Never hardcode credentials** in scripts. Use environment variables, Azure Key Vault, or managed identities
- Review all resource permissions before running scripts that modify Azure resources
- Scripts should follow the principle of least privilege
- Use service principals with appropriate RBAC roles for automation
- Enable diagnostic logging for troubleshooting

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-script`)
3. Commit your changes (`git commit -m 'Add amazing script for X'`)
4. Push to the branch (`git push origin feature/amazing-script`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
