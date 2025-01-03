#!/bin/bash

# Variables
SOURCE_ORG_ALIAS="flow+triggers"
EXPORT_DIR="data"
QUERY_FILE="data/query.txt"

# Read queries from file and export data
while IFS= read -r query
do
  sobject=$(echo $query | awk '{print $4}')
  sf data export tree --query "$query" --target-org $SOURCE_ORG_ALIAS --output-dir $EXPORT_DIR
done < "$QUERY_FILE"

# Create data plan file
cat > $EXPORT_DIR/data-plan.json <<EOL
[
  {
    "sobject": "Pricebook2",
    "saveRefs": true,
    "resolveRefs": false,
    "files": ["Pricebook2.json"]
  },
  {
    "sobject": "Product2",
    "saveRefs": true,
    "resolveRefs": true,
    "files": ["Product2.json"]
  },
  {
    "sobject": "PricebookEntry",
    "saveRefs": false,
    "resolveRefs": true,
    "files": ["PricebookEntry.json"]
  }
]
EOL

echo "Data export completed successfully."