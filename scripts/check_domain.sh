#!/bin/sh
# /scripts/failover.sh

# Load environment variables from .env file if available
if [ -f "/scripts/.env" ]; then
    . /scripts/.env
fi

DOMAIN="${DOMAIN:-yourdomain.com}"
CHECK_INTERVAL="${CHECK_INTERVAL:-60}"  # Check every minute by default
PRIMARY_PORT="${PRIMARY_PORT:-443}"     # Default Coolify HTTPS port
FAILOVER_PORT="${FAILOVER_PORT:-8443}"  # Nginx failover HTTPS port
FAILOVER_ACTIVE=false

# Function to check if the primary domain is accessible
check_primary_domain() {
    echo "$(date): Checking primary domain ${DOMAIN}:${PRIMARY_PORT}..."
    # Try to connect to the domain on the primary port
    if curl -s --max-time 5 -o /dev/null -w "%{http_code}" "https://${DOMAIN}:${PRIMARY_PORT}/health" | grep -q "200"; then
        return 0  # Primary domain is accessible
    else
        return 1  # Primary domain is not accessible
    fi
}

# Function to activate DNS failover
activate_failover() {
    if [ "$FAILOVER_ACTIVE" = false ]; then
        echo "$(date): Activating failover for ${DOMAIN}..."
        
        # Here you would implement your specific DNS failover mechanism
        # Options include:
        # 1. Using a DNS API to update records (examples for different providers below)
        # 2. Triggering a notification to manually update DNS
        # 3. Using a local hosts file update for testing
        
        # Example: If using Cloudflare (would need the CF API token in env vars)
        # curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
        #      -H "Authorization: Bearer ${CF_API_TOKEN}" \
        #      -H "Content-Type: application/json" \
        #      --data '{"content":"'${FAILOVER_IP}'","ttl":60}'
        
        # For this example, we'll just log the event
        echo "$(date): FAILOVER ACTIVATED. Please update your DNS to point to the failover server." >> /scripts/failover.log
        
        FAILOVER_ACTIVE=true
    fi
}

# Function to deactivate DNS failover
deactivate_failover() {
    if [ "$FAILOVER_ACTIVE" = true ]; then
        echo "$(date): Deactivating failover for ${DOMAIN}..."
        
        # Similar to activate_failover but reverting changes
        # Example: If using Cloudflare
        # curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
        #      -H "Authorization: Bearer ${CF_API_TOKEN}" \
        #      -H "Content-Type: application/json" \
        #      --data '{"content":"'${PRIMARY_IP}'","ttl":300}'
        
        echo "$(date): FAILOVER DEACTIVATED. Primary service is back online." >> /scripts/failover.log
        
        FAILOVER_ACTIVE=false
    fi
}

# Main loop to continuously check domain and manage failover
echo "Starting domain failover service for ${DOMAIN}"
echo "Check interval: ${CHECK_INTERVAL} seconds"

while true; do
    if check_primary_domain; then
        echo "$(date): Primary domain is accessible."
        deactivate_failover
    else
        echo "$(date): Primary domain is NOT accessible!"
        activate_failover
    fi
    
    # Wait before checking again
    sleep $CHECK_INTERVAL
done