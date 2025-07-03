# AH Plugin - Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in the AH Plugin, please report it responsibly:

### For Security Issues:
1. **DO NOT** open a public issue
2. Email us directly at: [your-email@example.com]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Timeline:
- **24 hours**: Initial acknowledgment
- **72 hours**: Preliminary assessment
- **7 days**: Detailed response with timeline for fix

## Security Considerations

### Command Execution
- All functions validate input parameters
- Destructive operations require user confirmation
- No arbitrary command execution from untrusted sources

### Data Handling
- No sensitive data is logged or stored
- All operations are local to user environment
- No external network calls except for intended cloud operations

### Safe Practices
- Always review commands before execution
- Use confirmation prompts for destructive operations
- Implement proper error handling

## Best Practices for Users

1. **Keep Updated**: Regularly update to the latest version
2. **Review Commands**: Understand what each alias/function does
3. **Environment**: Use in trusted environments only
4. **Permissions**: Follow principle of least privilege

## Acknowledgments

We appreciate responsible disclosure of security vulnerabilities and will acknowledge contributors in our security advisories (unless they prefer to remain anonymous).

---

Last updated: July 3, 2025
