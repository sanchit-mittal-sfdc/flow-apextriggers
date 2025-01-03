# Variables Default values
DEFAULT_SCRATCH_ORG_DURATION=7
DEFAULT_DEV_HUB_ALIAS="flow+triggers"
EXPORT_DIR="data"
PERMISSION_SETS=("Password_Never_Expires" "UserManagementObjectPermissions" ) # Add your permission sets here

# Read input parameters
read -p "Enter the scratch org alias: " SCRATCH_ORG_ALIAS
read -p "Enter the scratch org duration (in days, press Enter to use default $DEFAULT_SCRATCH_ORG_DURATION): " SCRATCH_ORG_DURATION
read -p "Enter the DevHub alias (press Enter to use default $DEFAULT_DEV_HUB_ALIAS): " DEV_HUB_ALIAS

# Use default duration if not provided
if [ -z "$SCRATCH_ORG_DURATION" ]; then
  SCRATCH_ORG_DURATION=$DEFAULT_SCRATCH_ORG_DURATION
fi

# Use default DevHub alias if not provided
if [ -z "$DEV_HUB_ALIAS" ]; then
  DEV_HUB_ALIAS=$DEFAULT_DEV_HUB_ALIAS
fi

# Check if EXPORT_DIR exists, if not create it
if [ ! -d "$EXPORT_DIR" ]; then
  echo "Directory $EXPORT_DIR does not exist. Creating it..."
  mkdir -p $EXPORT_DIR
else
  echo "Directory $EXPORT_DIR already exists."
fi

# Set the target DevHub
sf config set target-dev-hub $DEV_HUB_ALIAS

# exporting the data
sf data export tree --query "SELECT Name, IsActive, Description, (SELECT UnitPrice, UseStandardPrice FROM PricebookEntries) FROM Pricebook2" --target-org $DEV_HUB_ALIAS --output-dir $EXPORT_DIR
sf data export tree --query "SELECT Name, IsActive, Description, ProductCode, (SELECT UnitPrice, UseStandardPrice FROM PricebookEntries) FROM Product2" --target-org $DEV_HUB_ALIAS --output-dir $EXPORT_DIR

# Create a new scratch org
echo "Creating a new scratch org with alias '$SCRATCH_ORG_ALIAS' and duration '$SCRATCH_ORG_DURATION' days..."
sf org create scratch --target-dev-hub $DEV_HUB_ALIAS --definition-file config/project-scratch-def.json --set-default --duration-days $SCRATCH_ORG_DURATION -a $SCRATCH_ORG_ALIAS

# Push source to the scratch org
echo "Pushing source to the scratch org..."
sf project deploy start  --source-dir force-app --target-org $SCRATCH_ORG_ALIAS

# Assign the permission sets to the user
for PERMISSION_SET_NAME in "${PERMISSION_SETS[@]}"
do
  echo "Assigning permission set '$PERMISSION_SET_NAME' to the user '$SCRATCH_ORG_ALIAS' ..."
  sf org permset assign --name $PERMISSION_SET_NAME --target-org $SCRATCH_ORG_ALIAS
done

echo "Generating the new password for the user..."
sf org generate password --length 12 --complexity 1 --target-org $SCRATCH_ORG_ALIAS

# complexity values:
#  0 - lower case letters only
#  1 - lower case letters and numbers only
#  2 - lower case letters and symbols only
#  3 - lower and upper case letters and numbers only
#  4 - lower and upper case letters and symbols only
#  5 - lower and upper case letters and numbers and symbols only

# Open the scratch org
echo "Opening the scratch org..."
sf org open --target-org $SCRATCH_ORG_ALIAS

echo "Deleting the scratch org..."
sf org delete scratch --target-org $SCRATCH_ORG_ALIAS --no-prompt

echo "Deployment to scratch org completed successfully."