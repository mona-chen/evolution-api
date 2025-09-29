# Evolution API - Session Recovery Monitoring Dashboard

## Overview

The monitoring dashboard provides real-time visibility into the automatic session recovery system that handles stream conflicts and decryption errors in WhatsApp connections.

## Accessing the Dashboard

1. **Start your Evolution API server**:
   ```bash
   npm run dev:server
   # or
   bun dev:server
   ```

2. **Open the dashboard** in your browser:
   ```
   http://localhost:5858/monitoring-dashboard.html
   ```

   Replace `5858` with your configured server port if different.

## Features

### Real-time Monitoring

- **Decryption Errors**: Track "Bad MAC" and session decryption failures
- **Stream Conflicts**: Monitor connection conflicts and recovery attempts
- **Automatic Recovery**: View threshold-based automatic session recovery
- **Cooldown Tracking**: See recovery cooldown periods to prevent excessive operations

### Manual Controls

- **Manual Session Recovery**: Trigger immediate session recovery
- **Auto-refresh**: Enable/disable automatic data updates (30-second intervals)
- **Instance Configuration**: Configure API endpoint and authentication

## API Endpoints

The dashboard consumes these REST API endpoints:

### GET `/instance/decryptionErrorStatus/{instanceName}`
Returns decryption error statistics and recovery status.

**Response:**
```json
{
  "status": "SUCCESS",
  "error": false,
  "response": {
    "errorCount": 0,
    "lastErrorTime": null,
    "lastRecoveryTime": null,
    "nextRecoveryThreshold": 10,
    "cooldownRemaining": 0
  }
}
```

### GET `/instance/streamConflictStatus/{instanceName}`
Returns stream conflict statistics and recovery status.

**Response:**
```json
{
  "status": "SUCCESS",
  "error": false,
  "response": {
    "conflictCount": 0,
    "lastConflictTime": null,
    "nextRecoveryThreshold": 3
  }
}
```

### POST `/instance/manualSessionRecovery/{instanceName}`
Triggers manual session recovery with cooldown protection.

**Response:**
```json
{
  "status": "SUCCESS",
  "error": false,
  "response": {
    "success": true,
    "message": "Session recovery completed successfully"
  }
}
```

## Configuration

### API Settings
- **Instance Name**: Your WhatsApp instance name (default: "MyWa")
- **API Base URL**: Your Evolution API server URL (default: "http://localhost:5858")
- **API Key**: Optional authentication key if required

### Recovery Thresholds

The system automatically triggers recovery based on these thresholds:

- **Decryption Errors**: 10+ errors within 5 minutes
- **Stream Conflicts**: 3+ conflicts within 10 minutes
- **Cooldown Period**: 30 minutes between recovery operations

## Status Indicators

- 🟢 **Green (Healthy)**: No issues detected
- 🟠 **Orange (Warning)**: Issues detected but below threshold
- 🔴 **Red (Error)**: Threshold exceeded, recovery pending or in progress

## Troubleshooting

### Dashboard Not Loading
- Ensure your Evolution API server is running
- Check that the server port matches the dashboard configuration
- Verify API key if authentication is required

### API Errors
- Check browser console for detailed error messages
- Verify instance name exists and is connected
- Ensure proper API key configuration

### Recovery Not Working
- Check cooldown periods (30 minutes between recoveries)
- Verify instance is in a recoverable state
- Review server logs for detailed error information

## Security Notes

- The dashboard stores configuration in browser localStorage
- API keys are transmitted with each request
- Consider HTTPS in production environments
- Implement proper authentication for production use

## Browser Compatibility

- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

## Contributing

The dashboard is a static HTML file that can be customized and extended. Key files:
- `public/monitoring-dashboard.html` - Main dashboard interface
- `src/api/controllers/instance.controller.ts` - Backend API logic
- `src/api/routes/instance.router.ts` - API route definitions