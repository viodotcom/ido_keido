#!/bin/sh

COUNTRY_DB_KEY=$1
if [ -z "$COUNTRY_DB_KEY" ]; then
  GEOIP_COUNTRY_DB="GeoLite2-Country"
  COUNTRY_DB_KEY=000000000000
  echo "MaxMind License key for Country database was not given, using free license key ($COUNTRY_DB_KEY)"
else
  GEOIP_COUNTRY_DB="GeoIP2-Country"
fi

CITY_DB_KEY=$2
if [ -z "$CITY_DB_KEY" ]; then
  GEOIP_CITY_DB="GeoLite2-City"
  CITY_DB_KEY=000000000000
  echo "MaxMind License key for City database was not given, using free license key ($CITY_DB_KEY)"
else
  GEOIP_CITY_DB="GeoIP2-City"
fi

GEOIP_BASE_URL="https://www.maxmind.com/app/geoip_download"
GEOIP_DATA_DIR="data"
GEOIP_TEMP_DIR="/tmp/geoip"

print_header()
{
  echo ""
  echo "---------------------------------------------"
  echo "$@"
  echo "---------------------------------------------"
}

download_database()
{
  geoip_db=$1
  local_db=$2
  license_key=$3
  geoip_response_file="$GEOIP_TEMP_DIR/geoip_response"
  url="$GEOIP_BASE_URL?edition_id=$geoip_db&suffix=tar.gz&license_key=$license_key"

  echo $url

  # Download
  status_code=$(curl -s -o $geoip_response_file -w "%{http_code}" $url)

  # Check the response
  if [ "$status_code" != "200" ]; then
    echo "Error: `cat $geoip_response_file`"
    exit 1
  fi

  # Extract
  tar zxvf $geoip_response_file -C $GEOIP_TEMP_DIR

  # Move .mmdb file to final directory
  # Example:
  # mv /tmp/geoip/GeoIP2-Country_20180703/GeoIP2-Country.mmdb data/country.mmdb
  mv $GEOIP_TEMP_DIR/$geoip_db*/$geoip_db.mmdb $GEOIP_DATA_DIR/$local_db.mmdb
}

# Create directories
if [ ! -d "$GEOIP_DATA_DIR" ]; then mkdir -p $GEOIP_DATA_DIR; fi
if [ ! -d "$GEOIP_TEMP_DIR" ]; then mkdir -p $GEOIP_TEMP_DIR; fi

print_header "Downloading Country database"
download_database $GEOIP_COUNTRY_DB "country" $COUNTRY_DB_KEY

print_header "Downloading City database"
download_database $GEOIP_CITY_DB "city" $CITY_DB_KEY

print_header "List databases"
ls -la $GEOIP_DATA_DIR

# Cleanup
rm -rf $GEOIP_TEMP_DIR

print_header "Done!"
