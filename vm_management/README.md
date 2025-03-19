# Azure VM Management Automation

This script automates the tasks from the "Manage Virtual Machines" lab (AZ-104), creating and managing Azure Virtual Machines and Virtual Machine Scale Sets with autoscaling configurations.

## Features

- Creates zone-resilient Azure VMs across availability zones
- Manages compute and storage scaling for VMs
- Creates and configures Azure Virtual Machine Scale Sets
- Configures autoscaling rules based on CPU metrics
- Demonstrates VM creation using the Azure CLI
- Generates JSON output files for verification and reference

## Prerequisites

- Azure CLI installed and configured
- Active Azure subscription
- Bash shell environment (Linux, macOS, or Windows with WSL/Git Bash)

## Usage

1. Make the script executable:
   ```
   chmod +x azure-vm.sh
   ```

2. Login to your Azure account:
   ```
   az login
   ```

3. Review and modify the global variables section as needed:
   - Change `ADMIN_PASSWORD` to a secure password
   - Update `RESOURCE_GROUP`, `LOCATION`, or other variables if desired

4. Run the script:
   ```
   ./azure-vm.sh
   ```

5. Review the JSON output files created in the same directory

6. To clean up resources after completion, uncomment the resource cleanup section at the end of the script

## Lab Tasks Automated

1. Deploy zone-resilient Azure VMs
2. Manage compute and storage scaling for VMs
3. Create and configure Azure Virtual Machine Scale Sets
4. Configure autoscaling rules
5. Create a VM using the CLI

## Security Warning

This script contains a placeholder password. **NEVER commit actual passwords to GitHub**. For production use, replace the password with environment variables or Azure Key Vault references.

## Output Files

The script generates several JSON files to verify the configuration:
- `vm1.json`, `vm2.json` - VM configuration details
- `vmss.json` - VM Scale Set configuration
- `autoscale.json` - Autoscaling rules configuration

## Troubleshooting

If you encounter errors:
1. Verify your Azure CLI version (`az --version`)
2. Check that your subscription has adequate permissions
3. Review the error messages for specific resource constraints
4. Ensure you have appropriate quota limits in your subscription
