#!/bin/bash

CONFIG_DIR="./config/vendors"
OUTPUT_FILE="./config/mockserver.json"

echo "=== DEBUG: Merging JSON files from $CONFIG_DIR ==="

# Check if there are any JSON files before merging
if [ -z "$(ls -A $CONFIG_DIR/*.json 2>/dev/null)" ]; then
    echo "ERROR: No JSON files found in $CONFIG_DIR. Keeping existing $OUTPUT_FILE."
    exit 1
fi

# Log the list of JSON files
echo "=== DEBUG: Found JSON files ==="
ls -lah $CONFIG_DIR/*.json

# Extract all endpoints and group them by vendor
VENDOR_ENDPOINTS="[]"
for FILE in $CONFIG_DIR/*.json; do
    VENDOR_NAME=$(basename "$FILE" .json) # Extract vendor name from filename
    ENDPOINTS=$(jq -c --arg vendor "$VENDOR_NAME" '[.[] | {vendor: $vendor, method: .httpRequest.method, path: .httpRequest.path}]' "$FILE" | jq -c 'map(select(.path != "/"))')

    if [ -n "$ENDPOINTS" ] && [ "$ENDPOINTS" != "[]" ]; then
        VENDOR_ENDPOINTS=$(echo "$VENDOR_ENDPOINTS" | jq --argjson endpoints "$ENDPOINTS" '. + $endpoints')
    fi
done

echo "=== DEBUG: Vendor Endpoints ==="
echo "$VENDOR_ENDPOINTS" | jq .

# Ensure VENDOR_ENDPOINTS is not empty
if [ -z "$VENDOR_ENDPOINTS" ] || [ "$VENDOR_ENDPOINTS" == "[]" ]; then
    echo "ERROR: No valid vendor endpoints found. Aborting merge."
    exit 1
fi

# Generate homepage HTML dynamically with clickable links and HTTP methods
echo "=== DEBUG: Generating homepage HTML ==="
HOMEPAGE_HTML=$(jq -n --argjson vendorEndpoints "$VENDOR_ENDPOINTS" '[
    {
        "httpRequest": {
            "method": "GET",
            "path": "/"
        },
        "httpResponse": {
            "statusCode": 200,
            "body": ("<!DOCTYPE html>
        <html>
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
            <title>MockServer API Endpoints</title>
        <style>
            body { 
                font-family: Arial, sans-serif; 
                background: #141419; /* Darker background */
                padding: 20px; 
                text-align: center; 
                color: #cdd6f4; /* Light text color */
            }

            h1 { 
                color: #cdd6f4; /* Light text */
            }

            table { 
                width: 80%; 
                margin: 0 auto; 
                border-collapse: collapse; 
                background: #1a1b26; /* Darker table background */
                box-shadow: 0px 0px 10px rgba(0,0,0,0.4); 
                border-radius: 8px; 
                overflow: hidden;
            }

            th, td { 
                padding: 12px; 
                border: 1px solid #22232e; /* Slightly darker border */
                text-align: left; 
            }

            th { 
                background: #20212b; /* Darker header */
                color: #f8f8f2; /* Light text */
                text-transform: uppercase;
                font-weight: bold;
            }

            tr:nth-child(even) { 
                background: #191a23; /* Slightly darker than before */
            }

            tr:hover { 
                background: #22232e; /* More subtle hover effect */
            }

            a { 
                text-decoration: none; 
                color: #7aa2f7; /* Slightly darker Nautobot blue */
                font-weight: bold; 
            }

            a:hover { 
                text-decoration: underline; 
                color: #6d99e5; /* Adjusted hover color */
            }

            .method { 
                font-weight: bold; 
                text-transform: uppercase; 
                padding: 3px 6px; 
                border-radius: 3px; 
                color: white; 
            }

            /* Darkened API method colors */
            .GET { background-color: #3dbb67; }  /* Darker green for GET */
            .POST { background-color: #6ab7d6; } /* Darker blue for POST */
            .PUT { background-color: #d4c356; }  /* Darker yellow for PUT */
            .DELETE { background-color: #d94f4f; } /* Darker red for DELETE */
            .PATCH { background-color: #505a75; } /* Darker grey for PATCH */
        </style>
        </head>
        <body>
            <h1>MockServer API Endpoints</h1>
            <table>
                <tr><th>Vendor</th><th>Method</th><th>Endpoints</th></tr>" +
                ($vendorEndpoints | map(
                    "<tr><td><strong>" + (.vendor[:1] | ascii_upcase) + .vendor[1:] + "</strong></td>" + 
                    "<td><span class=\"method " + .method + "\">" + .method + "</span></td>" +
                    "<td><a href=\"" + .path + "\" target=\"_blank\">" + .path + "</a></td></tr>"
                ) | join("")) +
            "</table>
        </body>
        </html>"),
            "headers": {
                "Content-Type": "text/html"
            }
        }
    }
]')

echo "=== DEBUG: Generated HOMEPAGE_HTML ==="
echo "$HOMEPAGE_HTML" | jq .

# Merge homepage with vendor mocks (Fixed merging)
jq -s 'add' <(echo "$HOMEPAGE_HTML") $CONFIG_DIR/*.json > "$OUTPUT_FILE.tmp"

# Validate output before replacing the old file
if [ -s "$OUTPUT_FILE.tmp" ]; then
    mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
    echo "=== SUCCESS: Merged JSON written to $OUTPUT_FILE ==="
else
    echo "ERROR: jq produced an empty file. Aborting merge."
    rm -f "$OUTPUT_FILE.tmp"
    exit 1
fi
